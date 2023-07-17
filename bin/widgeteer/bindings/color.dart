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

import '../bindings_generator/code_unit.dart';
import '../bindings_generator/models/binding.dart';
import '../bindings_generator/models/type.dart';

/// Binding for the color struct.
class ColorBinding extends Binding {
  @override
  String get name => "Color";

  @override
  String get origin => "built in";

  @override
  List<BoundType> get types => [ColorType(), OptionalColorType()];
}

class OptionalColorType extends BoundType {
  @override
  CType get cType => COptionalColor();

  @override
  DartType get dartType => DartOptionalColor();

  @override
  String get name => "Color?";

  @override
  SwiftType get swiftType => SwiftOptionalColor();
}

class SwiftOptionalColor extends SwiftType {
  @override
  String get name => "Color?";

  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    return CodeUnit([
      "let ${variableName}Value: Color? = $sourceFfiValue == -1 ? nil : Color($sourceFfiValue)",
    ]);
  }
}

class DartOptionalColor extends DartType {
  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    return CodeUnit([
      "late final Color? ${variableName}Value;",
      "if ($variableName == -1) { ${variableName}Value = null; }",
      "else { ${sourceFfiValue}Value = Color($variableName); }",
    ]);
  }

  @override
  String get name => "Color?";
}

class COptionalColor extends CType {
  @override
  String get dartFfiMapping => "int";

  @override
  CodeUnit fromSwiftValue(String sourceValue, String variableName) {
    return CodeUnit([
      "let ${variableName}Value = $sourceValue?.value ?? -1",
    ]);
  }

  @override
  String get name => "int";

  @override
  String get swiftCInteropMapping => "Int";

  @override
  CodeUnit fromDartValue(String sourceValue, String variableName) {
    return CodeUnit([
      "final ${variableName}Value = $sourceValue?.value ?? -1;",
    ]);
  }

  @override
  String? get exceptionalReturnValue => "_minusOne";
}

class ColorType extends BoundType {
  @override
  CType get cType => CColor();

  @override
  DartType get dartType => DartColor();

  @override
  String get name => "Color";

  @override
  SwiftType get swiftType => SwiftColor();
}

class SwiftColor extends SwiftType {
  @override
  String get name => "Color";

  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    return CodeUnit([
      "let ${variableName}Value = Color($sourceFfiValue)",
    ]);
  }
}

class DartColor extends DartType {
  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    return CodeUnit([
      "final ${sourceFfiValue}Value = Color($variableName);",
    ]);
  }

  @override
  String get name => "Color";
}

class CColor extends CType {
  @override
  String get dartFfiMapping => "int";

  @override
  CodeUnit fromSwiftValue(String sourceValue, String variableName) {
    return CodeUnit([
      "let ${variableName}Value = $sourceValue.value",
    ]);
  }

  @override
  String get name => "int";

  @override
  String get swiftCInteropMapping => "Int";

  @override
  CodeUnit fromDartValue(String sourceValue, String variableName) {
    return CodeUnit([
      "final ${variableName}Value = $sourceValue.value;",
    ]);
  }

  @override
  String? get exceptionalReturnValue => "_minusOne";
}
