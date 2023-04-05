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

import '../bindings_generator/binding.dart';
import '../bindings_generator/code_unit.dart';

class StringBinding extends Binding {
  @override
  String get name => "String";

  @override
  SwiftType get swiftType => SwiftString();

  @override
  DartType get dartType => DartString();

  @override
  CType get cType => CString();

  @override
  String get origin => "built in";
}

class SwiftString extends SwiftType {
  @override
  String get name => "String";
}

class DartString extends DartType {
  @override
  String get name => "String";

  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) => CodeUnit(
      content:
          "final ${variableName}Value = $sourceFfiValue.cast<Utf8>().toDartString();");
}

class CString extends CType {
  @override
  String get name => "char*";

  @override
  String get cInteropMapping => "UnsafePointer<CChar>?";

  @override
  String get dartFfiMapping => "Pointer<Char>";
}
