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

class DoubleBinding extends Binding {
  @override
  String get name => "Double";

  @override
  String get origin => "built in";

  @override
  List<BoundType> get types => [DoubleType(), OptionalDoubleType()];
}

class OptionalDoubleType extends BoundType {
  @override
  CType get cType => COptionalDouble();

  @override
  DartType get dartType => DartOptionalDouble();

  @override
  String get name => "Double?";

  @override
  SwiftType get swiftType => SwiftOptionalDouble();
}

class SwiftOptionalDouble extends SwiftType {
  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    throw UnimplementedError();
  }

  @override
  String get name => "Double?";
}

class DartOptionalDouble extends DartType {
  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    return CodeUnit(initialLines: [
      "late final double? ${variableName}Value;",
      "if (libWidgeteer.optional_value_is_set($sourceFfiValue)) {",
      "    ${variableName}Value = libWidgeteer.optional_value_get_double($sourceFfiValue);",
      "} else {",
      "    ${variableName}Value = null;",
      "}",
    ]);
  }

  @override
  String get name => "double?";
}

class COptionalDouble extends CType {
  @override
  String get dartFfiMapping => "optional_value";

  @override
  CodeUnit fromDartValue(String sourceValue, String variableName) {
    throw UnimplementedError();
  }

  @override
  CodeUnit fromSwiftValue(String sourceValue, String variableName) {
    return CodeUnit(initialLines: [
      "let ${variableName}Unmanaged = Unmanaged<OptionalValue>.passRetained(OptionalValue(value: .double($sourceValue)))",
      "let ${variableName}Value = ${variableName}Unmanaged.toOpaque()",
    ]);
  }

  @override
  CodeUnit? fromSwiftValueCleanup(String sourceValue, String variableName) {
    return CodeUnit(content: "${variableName}Unmanaged.release()");
  }

  @override
  String get name => "widgeteer_optional_value";

  @override
  String get swiftCInteropMapping => "UnsafeRawPointer";
}

class DoubleType extends BoundType {
  @override
  CType get cType => CDouble();

  @override
  DartType get dartType => DartDouble();

  @override
  String get name => "Double";

  @override
  SwiftType get swiftType => SwiftDouble();
}

class SwiftDouble extends SwiftType {
  @override
  String get name => "Double";

  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    throw UnimplementedError();
  }
}

class DartDouble extends DartType {
  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    return CodeUnit(content: "final ${variableName}Value = $sourceFfiValue;");
  }

  @override
  String get name => "double";
}

class CDouble extends CType {
  @override
  String get dartFfiMapping => "double";

  @override
  CodeUnit fromSwiftValue(String sourceValue, String variableName) {
    return CodeUnit(content: "let ${variableName}Value = $sourceValue");
  }

  @override
  String get name => "double";

  @override
  String get swiftCInteropMapping => "Double";

  @override
  CodeUnit fromDartValue(String sourceValue, String variableName) {
    throw UnimplementedError();
  }
}
