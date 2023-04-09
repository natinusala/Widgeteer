/*
   Copyright 2023 natinusala

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:path/path.dart' as p;
import 'package:watcher/watcher.dart';

import '../building/build_path.dart';
import '../building/build_task.dart';
import '../building/device.dart';
import '../logger.dart';

class RunCommand extends Command {
  RunCommand() {
    argParser.addOption(
      "device",
      abbr: "d",
      help: "The device id or name to run the app on (prefixes allowed).",
      defaultsTo: null,
    );

    argParser.addFlag(
      "release",
      help: "Build a release version of your app.",
      defaultsTo: false,
    );

    argParser.addFlag(
      "watch",
      abbr: "w",
      help: "Watch for Swift code changes and automatically "
          "rebuild and restart the app when that happens (\"hot restarting\").",
      defaultsTo: false,
    );

    argParser.addOption(
      "preview",
      abbr: "p",
      help: "Run the app previewing the given preview (prefixes allowed).",
      defaultsTo: null,
    );

    argParser.addFlag(
      "verbose",
      abbr: "v",
      defaultsTo: false,
    );
  }

  bool get watch => argResults!["watch"] || previewing;
  bool get previewing => argResults!["preview"] != null;
  bool get verbose => argResults!["verbose"];

  @override
  String get description => "Run your Widgeteer app on a connected device.";

  @override
  String get name => "run";

  @override
  void run() async {
    // Find the target device
    final devices = getDevices().toList();

    // If there are no devices, error out
    // (the desktop platform isn't guaranteed to be available if SDK or libs are missing)
    if (devices.isEmpty) {
      fail("No connected devices. "
          "Use 'widgeteer devices' to list connected devices.");
    }

    // If there is only one device, pick it
    // Otherwise require the user to explicitely select one with `-d`
    Device device;
    if (devices.length == 1) {
      device = devices.first;
    } else {
      final requestedDevice = argResults!["device"];
      if (requestedDevice == null) {
        fail("Multiple connected devices; please select one with '--device'. "
            "Use 'widgeteer devices' to list connected devices.");
      }

      final foundDevice = findDevice(requestedDevice, devices);
      if (foundDevice == null) {
        fail(
            "Did not find any connected device with name or id '$requestedDevice'. "
            "Use 'widgeteer devices' to list connected devices.");
      }

      device = foundDevice;
    }

    // Start build
    final bool release = argResults!["release"];
    final mode = release ? "release" : "debug";

    final artifactsDir = p.join(libBuildDir, device.target(), mode);
    final pidFile = File(p.join(artifactsDir, "widgeteer_pid"));
    final nextSoFile = File(p.join(artifactsDir, "widgeteer_next_so"));

    ensureWidgeteerProject();

    logger.log("Launching on ${device.name} "
        "in $mode mode...");

    // Build Swift library
    final swiftBuildArgs = ["build", "-c", mode] + device.swiftBuildArgs;
    await buildSwiftApp(swiftBuildArgs);

    // Find the path to the built library
    var appLibrary = await findAppLibrary(artifactsDir);

    if (appLibrary == null) {
      fail("Unable to find built Swift app "
          "shared library inside '$libBuildDir' with mode '$mode' "
          "and target '${device.target()}'");
    }

    List<String> additionalFlutterArgs = [];

    // Prepare hot restarting if needed
    if (watch) {
      if (mode == "release") {
        fail("Hot restarting and previews are only available in debug mode.");
      }

      // We don't want subsequent `swift build` calls to overwrite the
      // .so currently loaded by the app so we need to rename it
      final destination = await renameBuiltApp(appLibrary, artifactsDir);
      appLibrary = destination;

      // If `WIDGETEER_HOT_RESTART=true` at bootstrap, the Widgeteer app will write its own PID to
      // `widgeteer_pid`. Then, it will start listening for `SIGUSR1`.
      // When that signal happens, it will read the location of the new .so from "widgeteer_next_so",
      // dlopen it and call `widgeteer_main()` again.
      // We cannot use the built-in `--pid-file` option because it only works if hot reloading is enabled,
      // and we don't want it enabled to be able to catch `SIGUSR1` on our own.
      // On the host side, every time a Swift file changes, the .so will be rebuilt, "widgeteer_next_so" will be updated
      // with the new path and `SIGUSR1` will be sent to the app.
      // Note: as we cannot have any guarantee that the previous library can safely be dlclosed (there may be running
      // async or dispatch tasks, or Dart native finalizers not GC'd yet...), it is currently never closed, which can cause
      // a memory usage grow after a long period of periodic restarts.
      // TODO: maybe replace SIGUSR1 by something else and remove --no-hot since it prevents the layout inspector from being used
      if (await pidFile.exists()) {
        await pidFile.delete();
      }

      additionalFlutterArgs.add("--dart-define=WIDGETEER_HOT_RESTART=true");
      additionalFlutterArgs
          .add("--dart-define=WIDGETEER_PID=${pidFile.absolute.path}");
      additionalFlutterArgs
          .add("--dart-define=WIDGETEER_NEXT_SO=${nextSoFile.absolute.path}");
    }

    // Preview
    if (previewing) {
      // This tells the app to call `widgeteer_preview` instead of `widgeteer_run`
      // on restart
      final previewName = argResults!["preview"];
      additionalFlutterArgs.add("--dart-define=WIDGETEER_PREVIEW=$previewName");
    }

    // Platform specific build
    await device.build(libBuildDir, artifactsDir, mode);

    // Start watching for changes
    StreamSubscription<WatchEvent>? watcherStream;
    if (watch) {
      final watcher = DirectoryWatcher(libDir);
      watcherStream = watcher.events.listen((event) => EasyDebounce.debounce(
            "hot-reload",
            const Duration(milliseconds: 250),
            () => hotRestart(
              event,
              swiftBuildArgs,
              artifactsDir,
              device,
              nextSoFile,
              pidFile,
              mode,
            ),
          ));

      logger.log("🔥  Watching for changes in 'lib' to"
          " ${previewing ? "reload the preview" : "hot restart"}  🔥");
    }

    // Flutter run
    await runBuildTask(
      "flutter",
      [
            "run",
            "--$mode",
            "-d",
            device.id, // trust Flutter to find the device from its id
            "--dart-define=WIDGETEER_LIBRARY_PATH=$appLibrary",
            if (watch) "--no-hot",
          ] +
          additionalFlutterArgs,
      workingDirectory,
      device.flutterRunEnvironment,
      "🚀  Running Flutter app",
      null,
      verbose: verbose,
    );

    // Cleanup
    await watcherStream?.cancel();
    EasyDebounce.cancelAll();
  }

  void hotRestart(
    WatchEvent event,
    List<String> swiftBuildArgs,
    String artifactsDir,
    Device device,
    File nextSoFile,
    File pidFile,
    String mode,
  ) {
    // TODO: find a reasonable way to delete and unload previous libs

    // Ignore anything coming from the `.build` folder
    if (event.path.contains(".build")) {
      return;
    }

    // Trigger a rebuild and hot restart
    Future.microtask(() async {
      try {
        logger.log(
            "🔥  ${previewing ? "Reloading preview" : "Hot restarting"} (${p.basename(event.path)} changed)  🔥");

        // Rebuild
        await buildSwiftApp(swiftBuildArgs, fatalFailure: false);

        // Find and move .so to a unique location
        var appLibrary = await findAppLibrary(artifactsDir);

        if (appLibrary == null) {
          fail("Unable to find built Swift app "
              "shared library inside '$libBuildDir' with mode '$mode' "
              "and target '${device.target()}'");
        }

        final destination = await renameBuiltApp(appLibrary, artifactsDir);

        // Write path to widgeteer_next_so
        await nextSoFile.writeAsString(destination);

        // Send `SIGUSR1` to trigger restart
        final pid = int.parse(await pidFile.readAsString());
        Process.killPid(pid, ProcessSignal.sigusr1);

        logger.log("🔥  ${previewing ? "Reload" : "Hot restart"} complete  🔥");
      } on BuildException {
        logger.log("❌  Build failed.");
      } catch (e) {
        logger.log("❌  An error occured while hot restarting: '$e'.");
      }
    });
  }

  Future<void> buildSwiftApp(List<String> buildArgs,
      {bool fatalFailure = true}) async {
    await runBuildTask("swift", buildArgs, libDir, {}, "🔨  Building Swift app",
        "Swift app built",
        fatalFailure: fatalFailure, verbose: verbose);
  }

  Future<String> renameBuiltApp(String appLibrary, String artifactsDir) async {
    final newName = "${DateTime.now().millisecondsSinceEpoch}.so";
    final destination = p.join(artifactsDir, newName);
    await File(appLibrary).rename(destination);
    return destination;
  }
}
