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
import 'package:stack_trace/stack_trace.dart';

import '../config.dart';

/// A unit of generated source code in any language,
/// whether it's a whole file, a class or the body of a function.
class CodeUnit {
  List<String> lines = [];

  /// Indentation level given by the current scope.
  int scopeLevel = 0;

  CodeUnit(List<String>? initialLines, {bool stamp = true}) {
    // Add the breadcrumb
    if (stamp) {
      // Find the first caller that's outside of the `CodeUnit` class
      Frame? caller;

      var level = 1;
      while (true) {
        final candidate = Frame.caller(level);
        final fileName = p.relative(candidate.uri.toFilePath());

        if (fileName.contains("code_unit.dart")) {
          level += 1;
          continue;
        }

        caller = candidate;
        break;
      }

      final fileName = p.relative(caller.uri.toFilePath());
      final line = caller.line;

      lines.add("// 🍞 $fileName:$line");
    }

    // Add content
    if (initialLines != null) {
      lines.addAll(initialLines);
    }
  }

  factory CodeUnit.forNewFile() {
    return CodeUnit([generatedHeader]);
  }

  factory CodeUnit.empty() {
    return CodeUnit([], stamp: true);
  }

  void appendLine(String line) {
    final indentation = " " * scopeLevel;
    lines.add("$indentation$line");
  }

  void appendEmptyLine() {
    lines.add("");
  }

  void appendLines(List<String> lines) {
    for (final line in lines) {
      appendLine(line);
    }
  }

  void appendUnit(CodeUnit unit) {
    assert(unit.scopeLevel == 0);

    for (final line in unit.lines) {
      appendLine(line);
    }
  }

  void enterScope(String line) {
    appendLine(line);
    scopeLevel += 4;
  }

  void exitScope(String line) {
    assert(scopeLevel > 0);

    scopeLevel -= 4;
    appendLine(line);
  }

  void exitAndEnterScope(String line) {
    assert(scopeLevel > 0);

    scopeLevel -= 4;
    appendLine(line);
    scopeLevel += 4;
  }

  Future<void> writeToFile(String path) async {
    assert(scopeLevel == 0);

    final string = lines.join("\n");
    final file = File(path);
    await Directory(file.parent.path).create(recursive: true);

    await file.writeAsString(string);
  }
}
