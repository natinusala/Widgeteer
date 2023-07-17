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
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }

  @override
  String get name => "Double?";
}

class DartOptionalDouble extends DartType {
  @override
  CodeUnit fromCValue(String source, String destination) {
    return CodeUnit([
      "late final double? ${destination}Value;",
      "if (libWidgeteer.optional_value_is_set($source)) {",
      "    ${destination}Value = libWidgeteer.optional_value_get_double($source);",
      "} else {",
      "    ${destination}Value = null;",
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
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    return CodeUnit([
      "let ${destination}Unmanaged = Unmanaged<OptionalValue>.passRetained(OptionalValue(double: $source))",
      "let ${destination}Value = ${destination}Unmanaged.toOpaque()",
    ]);
  }

  @override
  CodeUnit? fromSwiftValueCleanup(String source, String destination) {
    return CodeUnit([
      "${destination}Unmanaged.release()",
    ]);
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
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class DartDouble extends DartType {
  @override
  CodeUnit fromCValue(String source, String destination) {
    return CodeUnit([
      "final ${destination}Value = $source;",
    ]);
  }

  @override
  String get name => "double";
}

class CDouble extends CType {
  @override
  String get dartFfiMapping => "double";

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    return CodeUnit([
      "let ${destination}Value = $source",
    ]);
  }

  @override
  String get name => "double";

  @override
  String get swiftCInteropMapping => "Double";

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }
}
