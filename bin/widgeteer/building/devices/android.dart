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

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../../logger.dart';
import '../device.dart';

const _sdkEnvPrefix = "WIDGETEER_ANDROID_SDK_";

class AndroidDevice extends Device {
  late final Directory sdkPath;
  late final File destinationJson;
  late final String _target;
  late final String androidArch;
  late final String libsDir;

  /// Path to `widgeteer` directory somewhere inside `.build`.
  Directory? buildDir;

  AndroidDevice(
      {required super.id,
      required super.name,
      required super.platform,
      required super.version}) {
    final architecture = platform.split("-").last;

    switch (architecture) {
      case "arm64":
        androidArch = "arm64-v8a";
        libsDir = "aarch64-linux-android";
        break;
      default:
        fail("Unknown or unsupported Android architecture '$architecture'");
    }

    // Try to find the path to the SDK
    final sdkEnv = "$_sdkEnvPrefix${architecture.toUpperCase()}";

    final sdkPath = Platform.environment[sdkEnv];

    if (sdkPath == null) {
      fail("Cannot find Android SDK for $architecture: '$sdkEnv' is not set");
    }

    this.sdkPath = Directory(sdkPath);

    if (!this.sdkPath.existsSync()) {
      fail(
          "Cannot find Android SDK for $architecture: '$sdkPath' does not exist");
    }

    // Ensure the destination json file is here
    final destinationJsonPath = p.join(sdkPath, "$platform.json");
    destinationJson = File(destinationJsonPath);

    if (!destinationJson.existsSync()) {
      fail(
          "Cannot find Android SDK for $architecture: '$destinationJsonPath' does not exist");
    }

    // Read the destination JSON file to get the target
    final parsedDestination = jsonDecode(destinationJson.readAsStringSync());
    _target = parsedDestination["target"];
  }

  @override
  Future<void> build(
      String swiftBuildDir, String artifactsDir, String mode) async {
    // Gradle wants .so files to be placed neatly in a JNI folder with one folder
    // per architecture so use the Swift .build directory to store it.

    final widgeteerDir =
        Directory(p.join(swiftBuildDir, _target, mode, "widgeteer"));
    buildDir = widgeteerDir;

    final archDir = Directory(p.join(widgeteerDir.absolute.path, androidArch));

    // Only copy toolchain libs once when creating the folder
    if (!await archDir.exists()) {
      await archDir.create(recursive: true);

      // Copy all .so files from Swift stdlib
      // Except for FoundationXML and FoundationNetworking that have unresolved dependencies in libcurl and libxml2
      // TODO: since Swift 5.8 Swift libs and toolchain libs are in the same directory: change to a list of files to copy instead of copying every found .so (see .kt for the list)
      final skippedSwiftStdlib = [
        "libFoundationNetworking.so",
        "libFoundationXML.so",
        "libXCTest.so",
        "libswiftDistributed.so",
      ];

      final swiftStdlib =
          Directory(p.join(sdkPath.absolute.path, "usr", "lib", libsDir));

      if (!await swiftStdlib.exists()) {
        throw "Could not find Swift SDK shared libraries at '${swiftStdlib.path}'";
      }

      logger.debug(
          "Copying Swift SDK shared libraries from '${swiftStdlib.path}'");

      await for (var entity in swiftStdlib.list()) {
        final basename = p.basename(entity.path);
        if (skippedSwiftStdlib.contains(basename) ||
            !basename.endsWith(".so")) {
          continue;
        }

        final file = File(entity.absolute.path);
        await file.copy(p.join(archDir.absolute.path, basename));
      }

      // Copy some .so files from toolchain stdlib
      final includedToolchainStdlib = [
        "libandroid-spawn.so",
        "libc++_shared.so",
        "libicudata.so",
        "libicui18n.so",
        "libicuuc.so",
      ];

      final toolchainStdlib = swiftStdlib;

      await for (var entity in toolchainStdlib.list()) {
        final basename = p.basename(entity.path);
        if (!includedToolchainStdlib.contains(basename)) {
          continue;
        }

        final file = File(entity.absolute.path);
        await file.copy(p.join(archDir.absolute.path, basename));
      }
    }

    // Copy every built .so every time to update them
    final artifactsDirectory = Directory(artifactsDir);

    await for (var entity in artifactsDirectory.list()) {
      final basename = p.basename(entity.path);
      if (!basename.endsWith(".so")) {
        continue;
      }

      final file = File(entity.absolute.path);
      await file.copy(p.join(archDir.absolute.path, basename));
    }
  }

  @override
  String operatingSystem() {
    return "android";
  }

  @override
  String target() {
    return _target;
  }

  @override
  List<String> get swiftBuildArgs => [
        "--destination",
        destinationJson.absolute.path,
      ];

  @override
  Map<String, String> get flutterRunEnvironment {
    return {
      "WIDGETEER_LIBS_PATH": buildDir!.absolute.path,
    };
  }

  @override
  String? get unavailability {
    // Android is only available on Linux for now
    if (Platform.isLinux) {
      return null;
    }

    return "Android cross-compilation is only available on Linux for now";
  }
}
