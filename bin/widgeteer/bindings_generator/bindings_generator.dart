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
import 'package:ffigen/ffigen.dart' as ffigen;
import 'package:path/path.dart' as p;
import 'package:logging/logging.dart' as logging;

import '../logger.dart';
import 'code_unit.dart';
import '../config.dart';
import 'models/outlet.dart';
import 'toml.dart';

Future<void> generateBindings(String workingDirectory) async {
  final dartRoot = p.join(workingDirectory, generatedDartRoot);
  final swiftRoot = p.join(workingDirectory, generatedSwiftRoot);
  final includesRoot = p.join(workingDirectory, generatedIncludesRoot);

  // Clear everything before regenerating
  for (final generatedDir in [dartRoot, swiftRoot, includesRoot]) {
    final dir = Directory(generatedDir);
    if (await dir.exists()) {
      logger.info("🧹  Deleting '${dir.path}'");
      await dir.delete(recursive: true);
    }
  }

  // Walk through all bindings, generate the code and collect outlets
  List<EmittedOutlet> outlets = [];
  List<String> generatedDartFiles = [];
  for (final binding in await parseBindings(workingDirectory)) {
    // Collect outlets
    outlets.addAll(
        binding.binding.outlets.map((e) => EmittedOutlet(binding.binding, e)));

    // Dart file
    final dartBody = binding.binding.dartBody;
    if (dartBody != null) {
      final dartFile = p.join(
          dartRoot, binding.relativePath, "${binding.binding.name}.dart");

      generatedDartFiles.add(dartFile);

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
    outletsHeader.appendLine(
        "// Outlet emitted by '${outlet.binding.name}' binding (${outlet.binding})");
    outletsHeader.appendLine(outlet.outlet.registrationCDeclaration);
  }

  final outletsHeadersFile = p.join(includesRoot, "outlets.h");
  logger.log(
      "🖨️  Writing outlets registration headers to '$outletsHeadersFile'");
  await outletsHeader.writeToFile(outletsHeadersFile);

  // Generate outlets registration function
  final registerOutletsFile = CodeUnit.forNewFile();

  registerOutletsFile.appendLine("import 'dart:ffi';");
  registerOutletsFile.appendLine("import 'lib_widgeteer.dart';");
  registerOutletsFile.appendLine("import 'package:ffi/ffi.dart';");

  registerOutletsFile.appendEmptyLine();
  for (final dartFile in generatedDartFiles) {
    final relativePath =
        p.relative(dartFile, from: p.join(workingDirectory, "lib"));
    registerOutletsFile.appendLine("import 'package:widgeteer/$relativePath';");
  }

  registerOutletsFile.appendEmptyLine();
  registerOutletsFile
      .appendLine("void registerOutlets(LibWidgeteer widgeteer) {");

  for (final outlet in outlets) {
    registerOutletsFile.appendLine(
        "// Outlet emitted by '${outlet.binding.name}' binding (${outlet.binding})",
        indentedBy: 4);
    registerOutletsFile.appendUnit(outlet.outlet.dartRegistrationCall,
        indentedBy: 4);
  }

  registerOutletsFile.appendLine("}");

  final registerOutletsDestination = p.join(dartRoot, "register_outlets.dart");
  registerOutletsFile.writeToFile(registerOutletsDestination);
  logger.log(
      "🖨️  Writing outlets registration function to '$registerOutletsDestination'");

  // Setup the ffigen logger
  final ffiLogger = logging.Logger("ffigen.ffigen");
  ffiLogger.onRecord.listen((event) {
    if (event.level >= logging.Level.SEVERE) {
      logger.log("❌  ffigen error: ${event.message}");
    } else if (event.level >= logging.Level.WARNING) {
      logger.log("⚠️  ffigen warning: ${event.message}");
    }
  });

  // Run ffigen
  for (final nativeLib in nativeLibraries) {
    final config = nativeLib.config(workingDirectory);
    final output = File(nativeLib.output(workingDirectory));

    logger.log("🖨️  Writing '${nativeLib.name}' bindings to '${output.path}'");
    final library = ffigen.parse(config);

    library.generateFile(output);
  }
}
