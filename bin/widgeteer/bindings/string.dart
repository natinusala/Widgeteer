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
  List<BoundType> get types => [StringType(), OptionalStringType()];
}

class OptionalStringType extends BoundType {
  @override
  CType get cType => COptionalString();

  @override
  DartType get dartType => DartOptionalString();

  @override
  String get name => "String?";

  @override
  SwiftType get swiftType => SwiftOptionalString();
}

class COptionalString extends CType {
  @override
  String get dartFfiMapping => "optional_value";

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    return CodeUnit([
      "let ${destination}Unmanaged = Unmanaged<OptionalValue>.passRetained(OptionalValue(string: $source))",
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

class SwiftOptionalString extends SwiftType {
  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }

  @override
  String get name => "String?";
}

class DartOptionalString extends DartType {
  @override
  CodeUnit fromCValue(String source, String destination) {
    return CodeUnit([
      "late final String? ${destination}Value;",
      "if (libWidgeteer.optional_value_is_set($source)) {",
      "    ${destination}Value = libWidgeteer.optional_value_get_string($source).cast<Utf8>().toDartString();",
      "} else {",
      "    ${destination}Value = null;",
      "}",
    ]);
  }

  @override
  String get name => "String?";
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

  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class DartString extends DartType {
  @override
  String get name => "String";

  @override
  CodeUnit fromCValue(String source, String destination) => CodeUnit([
        "final ${destination}Value = $source.cast<Utf8>().toDartString();",
      ]);
}

class CString extends CType {
  @override
  String get name => "char*";

  @override
  String get swiftCInteropMapping => "UnsafePointer<CChar>?";

  @override
  String get dartFfiMapping => "Pointer<Char>";

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    // Use Swift implicit conversion from String to CChar* in function calls
    return CodeUnit([
      "let ${destination}Value = $source",
    ]);
  }

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }
}
