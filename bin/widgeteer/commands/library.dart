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

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:args/command_runner.dart';

import '../bindings_generator/bindings_generator.dart';
import '../bindings_generator/toml.dart';
import '../building/build_task.dart';
import '../building/device.dart';
import '../logger.dart';

class LibraryCommand extends Command {
  LibraryCommand() {
    addSubcommand(BuildLibraryCommand());
    addSubcommand(CleanLibraryCommand());
    addSubcommand(GenerateBindingsCommand());
    addSubcommand(ListBindingsCommand());
  }

  @override
  String get description =>
      "Widgeteer library management. To be used inside the library repository, not inside your app project.";

  @override
  String get name => "library";
}

class CleanLibraryCommand extends Command {
  CleanLibraryCommand() {
    argParser.addOption(
      "device",
      abbr: "d",
      help:
          "The device id or name to clean the library for (prefixes allowed).",
      defaultsTo: null,
    );

    argParser.addFlag(
      "verbose",
      abbr: "v",
      defaultsTo: false,
    );
  }
  @override
  String get description =>
      "Clean the Swift library previously built with 'build'.";

  @override
  String get name => "clean";

  @override
  void run() async {
    final device = getTargetDevice(argResults!["device"]);
    final bool verbose = argResults!["verbose"];

    logger.log("Cleaning Swift library for ${device.name}");

    // Clean Swift library
    final directory = p.join(Directory.current.path, "Widgeteer");

    final swiftBuildArgs = ["package", "clean"] + device.swiftBuildArgs;
    await runBuildTask("swift", swiftBuildArgs, directory, {},
        "🔨  Building library", "Library built",
        fatalFailure: true, verbose: verbose);
  }
}

class BuildLibraryCommand extends Command {
  BuildLibraryCommand() {
    argParser.addOption(
      "device",
      abbr: "d",
      help:
          "The device id or name to build the library for (prefixes allowed).",
      defaultsTo: null,
    );

    argParser.addFlag(
      "release",
      help: "Build a release version of the library.",
      defaultsTo: false,
    );

    argParser.addFlag(
      "verbose",
      abbr: "v",
      defaultsTo: false,
    );
  }
  @override
  String get description =>
      "Build the Swift library on its own to make sure it compiles properly.";

  @override
  String get name => "build";

  @override
  void run() async {
    final device = getTargetDevice(argResults!["device"]);
    final bool release = argResults!["release"];
    final bool verbose = argResults!["verbose"];
    final mode = release ? "release" : "debug";

    logger.log("Building Swift library for ${device.name} "
        "in $mode mode...");

    // Build Swift library
    final directory = p.join(Directory.current.path, "Widgeteer");

    final swiftBuildArgs = ["build", "-c", mode] + device.swiftBuildArgs;
    await runBuildTask("swift", swiftBuildArgs, directory, {},
        "🔨  Building library", "Library built",
        fatalFailure: true, verbose: verbose);
  }
}

class GenerateBindingsCommand extends Command {
  @override
  String get description => "Regenerate all bindings.";

  @override
  String get name => "generate-bindings";

  @override
  void run() async {
    await generateBindings(Directory.current.path);
  }
}

class ListBindingsCommand extends Command {
  @override
  String get description => "List all available bindings.";

  @override
  String get name => "list-bindings";

  @override
  void run() async {
    final list = await parseBindings(Directory.current.path);

    logger.log(
        "List of all available bindings and the types they emit:\n${list.map((e) => e.binding).map((e) => "    - ${e.description}").join("\n")}");
  }
}
