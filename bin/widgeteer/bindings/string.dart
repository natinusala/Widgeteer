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

import '../bindings_generator/models/binding.dart';
import '../bindings_generator/code_unit.dart';
import '../bindings_generator/models/type.dart';

class StringBinding extends Binding {
  @override
  String get name => "String";

  @override
  String get origin => "built in";

  @override
  List<BoundType> get types => [StringType()];
}

class StringType extends BoundType {
  @override
  String get name => "String";

  @override
  SwiftType get swiftType => SwiftString();

  @override
  DartType get dartType => DartString();

  @override
  CType get cType => CString();
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
  String get swiftCInteropMapping => "UnsafePointer<CChar>?";

  @override
  String get dartFfiMapping => "Pointer<Char>";

  @override
  CodeUnit fromSwiftValue(String sourceValue, String variableName) {
    // Use Swift implicit conversion from String to CChar* in function calls
    return CodeUnit(content: "let ${variableName}Value = $sourceValue");
  }
}
