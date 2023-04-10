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

/// Binding for `Widget`, `Widget?` and all abstract subclasses like
/// `PreferredSizeWidget`.
class AnyWidgetBinding extends Binding {
  @override
  String get name => "Widget";

  @override
  String get origin => "built in";

  @override
  List<BoundType> get types => [AnyWidgetType(), OptionalAnyWidgetType()];
}

class AnyWidgetType extends BoundType {
  @override
  CType get cType => CAnyWidget();

  @override
  DartType get dartType => DartAnyWidget();

  @override
  String get name => "Widget";

  @override
  SwiftType get swiftType => SwiftAnyWidget();
}

class OptionalAnyWidgetType extends BoundType {
  @override
  CType get cType => COptionalAnyWidget();

  @override
  DartType get dartType => DartOptionalAnyWidget();

  @override
  String get name => "Widget?";

  @override
  SwiftType get swiftType => SwiftOptionalAnyWidget();
}

class SwiftAnyWidget extends SwiftType {
  @override
  String get name => "any Widget";
}

class SwiftOptionalAnyWidget extends SwiftType {
  @override
  String get name => "(any Widget)?";
}

class DartAnyWidget extends DartType {
  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) => CodeUnit(
      content: "final ${variableName}Value = $sourceFfiValue as Widget;");

  @override
  String get name => "Widget";
}

class DartOptionalAnyWidget extends DartType {
  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) => CodeUnit(
      content: "final ${variableName}Value = $sourceFfiValue as Widget?;");

  @override
  String get name => "Widget?";
}

class CAnyWidget extends CType {
  @override
  String get dartFfiMapping => "Object";

  @override
  String get name => "Dart_Handle";

  @override
  String get swiftCInteropMapping => "Dart_Handle";
}

class COptionalAnyWidget extends CType {
  @override
  String get dartFfiMapping => "Object?";

  @override
  String get name =>
      "Dart_Handle"; // handles already are pointers and FFI converts C `NULL` to Dart `null`

  @override
  String get swiftCInteropMapping => "Dart_Handle?";
}
