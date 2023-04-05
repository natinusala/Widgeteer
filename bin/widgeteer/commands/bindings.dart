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

import 'package:args/command_runner.dart';

import '../bindings_generator/bindings_generator.dart';
import '../logger.dart';

class BindingsCommand extends Command {
  BindingsCommand() {
    addSubcommand(GenerateBindingsCommand());
    addSubcommand(ListBindingsCommand());
  }

  @override
  String get description =>
      "Manage Flutter / Dart to Swift bindings for the whole library.";

  @override
  String get name => "bindings";
}

class GenerateBindingsCommand extends Command {
  @override
  String get description => "Regenerate all bindings.";

  @override
  String get name => "generate";

  @override
  void run() async {
    await generateBindings(Directory.current.path);
  }
}

class ListBindingsCommand extends Command {
  @override
  String get description => "List all available bindings.";

  @override
  String get name => "list";

  @override
  void run() async {
    final list = await parseBindings(Directory.current.path);

    logger.print(
        "List of all available bindings:\n${list.map((e) => e.binding).map((e) => "    - ${e.name} (${e.origin})").join("\n")}");
  }
}
