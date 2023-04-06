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
import 'package:stack_trace/stack_trace.dart' as stacktrace;

/// A unit of generated source code in any language,
/// whether it's a whole file, a class or the body of a function.
class CodeUnit {
  List<String> lines = [];

  CodeUnit({String? content, List<String>? initialLines, bool stamp = true}) {
    // Add the breadcrumb
    if (stamp) {
      final caller = stacktrace.Frame.caller(1);
      final fileName = p.relative(caller.uri.toFilePath());
      final line = caller.line;

      lines.add("// 🍞 $fileName:$line");
    }

    // Add content
    if (content != null) {
      lines.add(content);
    }

    if (initialLines != null) {
      lines.addAll(initialLines);
    }
  }

  void appendLine(String line) {
    lines.add(line);
  }

  void appendLines(List<String> lines) {
    this.lines.addAll(lines);
  }

  void appendUnit(CodeUnit unit, {int indentedBy = 0}) {
    for (final line in unit.lines) {
      final indentation = " " * indentedBy;
      lines.add("$indentation$line");
    }
  }

  Future<void> writeToFile(String path) async {
    final string = lines.join("\n");
    final file = File(path);
    await Directory(file.parent.path).create(recursive: true);

    await file.writeAsString(string);
  }
}
