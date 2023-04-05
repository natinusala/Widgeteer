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

import '../logger.dart';
import 'binding.dart';
import 'code_unit.dart';
import 'config.dart';
import 'toml.dart';

class ParsedBinding {
  final Binding binding;

  /// Path to the binding relative to working directory.
  /// Used so that generated code follows the same hierarchy as TOML files.
  final String relativePath;

  ParsedBinding(this.binding, this.relativePath);
}

/// Parse and gather all bindings from TOML files.
/// All returned bindings will be bound to the same [BindingContext].
Future<List<ParsedBinding>> parseBindings(String workingDirectory) async {
  final context = BindingContext();
  List<ParsedBinding> bindings = [];

  // Register all built-in types
  bindings.addAll(builtinBindings.map((e) => ParsedBinding(e, "Builtin")));

  final bindingsRoot = Directory(p.join(workingDirectory, "Bindings"));

  await for (final entity in bindingsRoot.list(recursive: true)) {
    if (entity is! File) {
      continue;
    }

    if (!entity.path.endsWith(".toml")) {
      throw "Unsupported file type '${entity.path}'";
    }

    final binding = await parseTomlFile(entity.path, context);
    final relativePath = File(p.relative(entity.path)).parent.path;

    bindings.add(ParsedBinding(binding, relativePath));
  }

  context.bindings = bindings.map((e) => e.binding).toList();
  return bindings;
}

Future<void> generateBindings(String workingDirectory) async {
  final dartRoot = p.join(workingDirectory, generatedDartRoot);
  final swiftRoot = p.join(workingDirectory, generatedSwiftRoot);
  final includesRoot = p.join(workingDirectory, generatedIncludesRoot);

  // Clear everything before regenerating
  logger.debug("🧹  Cleaning up previous generation");
  for (final generatedDir in [dartRoot, swiftRoot, includesRoot]) {
    final dir = Directory(generatedDir);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  // Walk through all bindings, generate the code and collect outlets
  for (final binding in await parseBindings(workingDirectory)) {
    // Dart file
    final dartBody = binding.binding.dartType.body;
    if (dartBody != null) {
      final dartFile = p.join(
          dartRoot, binding.relativePath, "${binding.binding.name}.dart");

      logger.log(
          "🖨️  Writing '${binding.binding.name}' Dart code to '$dartFile'");
      var fileUnit = CodeUnit(content: generatedHeader, stamp: false)
        ..appendAll(dartBody);
      await fileUnit.writeToFile(dartFile);
    }

    // Swift file
    final swiftBody = binding.binding.swiftType.body;
    if (swiftBody != null) {
      final swiftFile = p.join(
          swiftRoot, binding.relativePath, "${binding.binding.name}.swift");

      logger.log(
          "🖨️  Writing '${binding.binding.name}' Swift code to '$swiftFile'");
      var fileUnit = CodeUnit(content: generatedHeader, stamp: false)
        ..appendAll(swiftBody);
      await fileUnit.writeToFile(swiftFile);
    }
  }
}
