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
import 'code_unit.dart';
import 'config.dart';
import 'models/outlet.dart';
import 'toml.dart';

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
  List<EmittedOutlet> outlets = [];
  for (final binding in await parseBindings(workingDirectory)) {
    // Collect outlets
    outlets.addAll(
        binding.binding.outlets.map((e) => EmittedOutlet(binding.binding, e)));

    // Dart file
    final dartBody = binding.binding.dartBody;
    if (dartBody != null) {
      final dartFile = p.join(
          dartRoot, binding.relativePath, "${binding.binding.name}.dart");

      logger.log(
          "🖨️  Writing '${binding.binding.name}' Dart code to '$dartFile'");
      var fileUnit = CodeUnit.forNewFile()..appendUnit(dartBody);
      await fileUnit.writeToFile(dartFile);
    }

    // Swift file
    final swiftBody = binding.binding.swiftBody;
    if (swiftBody != null) {
      final swiftFile = p.join(
          swiftRoot, binding.relativePath, "${binding.binding.name}.swift");

      logger.log(
          "🖨️  Writing '${binding.binding.name}' Swift code to '$swiftFile'");
      var fileUnit = CodeUnit.forNewFile()..appendUnit(swiftBody);
      await fileUnit.writeToFile(swiftFile);
    }
  }

  // Generate outlets header file
  var outletsHeader = CodeUnit.forNewFile();
  outletsHeader.appendLine('#import "../types.h"');
  outletsHeader.appendEmptyLine();

  for (final outlet in outlets) {
    outletsHeader.appendLine("// Outlet emitted by '${outlet.binding.name}'");
    outletsHeader.appendLine(outlet.outlet.registrationCDeclaration);
  }

  final outletsHeadersFile = p.join(includesRoot, "generated", "outlets.h");
  logger.log(
      "🖨️  Writing outlets registration headers to '$outletsHeadersFile'");
  await outletsHeader.writeToFile(outletsHeadersFile);
}
