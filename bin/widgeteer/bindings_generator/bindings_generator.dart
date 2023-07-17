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

  final bindings = await parseBindings(workingDirectory);

  // Prepare a list of imports to blindly give to every generated Dart file
  final imports = CodeUnit([
    "import 'package:flutter/widgets.dart';",
    "import 'package:widgeteer/dylib.dart';",
    "import 'package:flutter/material.dart';"
  ]);
  for (final binding in bindings) {
    if (!binding.binding.importBody) {
      continue;
    }

    final dartBody = binding.binding.dartBody;
    if (dartBody != null) {
      final relPath =
          p.relative(binding.dartBodyPath(dartRoot), from: dartLibRoot);
      imports.appendLine("import 'package:widgeteer/$relPath';");
    }
  }

  // Walk through all bindings, generate the code and collect outlets
  List<EmittedOutlet> outlets = [];
  List<String> generatedDartFiles = [];
  List<CodeUnit> cDeclarations = [];
  for (final binding in bindings) {
    // Collect outlets
    outlets.addAll(
        binding.binding.outlets.map((e) => EmittedOutlet(binding.binding, e)));

    // Dart file
    final dartBody = binding.binding.dartBody;
    if (dartBody != null) {
      final dartFile = binding.dartBodyPath(dartRoot);

      generatedDartFiles.add(dartFile);

      logger.log(
          "🖨️  Writing '${binding.binding.name}' Dart code to '$dartFile'");
      var fileUnit = CodeUnit.forNewFile()
        ..appendUnit(imports)
        ..appendUnit(dartBody);
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

    // C declarations
    final cDecls = binding.binding.cDeclarations;
    if (cDecls != null) {
      cDeclarations.add(cDecls);
    }
  }

  // Generate additional C declarations header
  var cDeclsHeader = CodeUnit.forNewFile();
  cDeclsHeader.appendLine('#import "../types.h"');
  cDeclsHeader.appendEmptyLine();

  for (final cDecl in cDeclarations) {
    cDeclsHeader.appendUnit(cDecl);
    cDeclsHeader.appendEmptyLine();
  }

  final cDeclsHeadersFile = p.join(includesRoot, "declarations.h");
  logger.log("🖨️  Writing additional C declarations to '$cDeclsHeadersFile'");
  await cDeclsHeader.writeToFile(cDeclsHeadersFile);

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
      "🖨️  Writing outlets registration functions to '$outletsHeadersFile'");
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

  // Constants for exceptional values
  registerOutletsFile.appendEmptyLine();
  registerOutletsFile.appendLine("const int _minusOne = -1;");

  registerOutletsFile.appendEmptyLine();
  registerOutletsFile
      .enterScope("void registerOutlets(LibWidgeteer widgeteer) {");

  for (final outlet in outlets) {
    registerOutletsFile.appendLine(
        "// Outlet emitted by '${outlet.binding.name}' binding (${outlet.binding})");
    registerOutletsFile.appendUnit(outlet.outlet.dartRegistrationCall);
  }

  registerOutletsFile.exitScope("}");

  final registerOutletsDestination = p.join(dartRoot, "register_outlets.dart");
  registerOutletsFile.writeToFile(registerOutletsDestination);
  logger.log(
      "🖨️  Writing outlets registration function to '$registerOutletsDestination'");

  // Write the outlets Swift file
  final outletsSwift = CodeUnit.forNewFile();
  outletsSwift.appendLine("import DartApiDl");
  outletsSwift.appendEmptyLine();

  for (final outlet in outlets) {
    outletsSwift.appendLine("// MARK: ${outlet.outlet.name}");
    outletsSwift.appendLine(
        "// Outlet emitted by '${outlet.binding.name}' binding (${outlet.binding})");
    outletsSwift.appendUnit(outlet.outlet.swiftRegistration);
  }

  final swiftOutletsDestination = p.join(swiftRoot, "Outlets.swift");
  outletsSwift.writeToFile(swiftOutletsDestination);
  logger.log("🖨️  Writing Swift outlets to '$swiftOutletsDestination'");

  // Setup the ffigen logger
  var ffigenError = false;
  final ffiLogger = logging.Logger("ffigen.ffigen");
  ffiLogger.onRecord.listen((event) {
    if (event.level >= logging.Level.SEVERE) {
      logger.log("❌  ffigen error: ${event.message}");
      ffigenError = true;
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

  if (ffigenError) {
    fail("ffigen emitted one or more errors, please fix them and retry");
  }

  logger.log("✔️  Done");
}
