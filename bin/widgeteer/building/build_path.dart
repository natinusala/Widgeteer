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

final workingDirectory = Directory.current.path;
final libDir = p.join(workingDirectory, "lib");
final testDir = p.join(workingDirectory, "test");

final packageSwift = p.join(libDir, "Package.swift");
final libBuildDir = p.join(libDir, ".build");

final testPackageSwift = p.join(testDir, "Package.swift");
final testBuildDir = p.join(testDir, ".build");

/// Ensure the current project is a Widgeteer project.
void ensureWidgeteerProject() {
  if (!File(packageSwift).existsSync()) {
    fail("'Package.swift' was not found in '$libDir', "
        "have you used 'widgeteer init' after creating the Flutter project?");
  }
}

/// Attempt to find the app library inside the build folder.
Future<String?> findAppLibrary(String searchRoot) async {
  String? soPath;
  await for (var entity
      in Directory(searchRoot).list(recursive: true, followLinks: false)) {
    final basename = p.basename(entity.path);
    if (basename.startsWith("lib") &&
        basename.endsWith(".so") &&
        basename != "libWidgeteer.so" &&
        !basename.contains("UnitTests")) {
      soPath = entity.path;
      break;
    }
  }

  return soPath;
}
