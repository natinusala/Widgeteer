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

class ObjectBinding extends Binding {
  @override
  String get origin => "built in";

  @override
  String get name => "Object";

  @override
  List<BoundType> get types => [ObjectType()];
}

class ObjectType extends BoundType {
  @override
  CType get cType => CObject();

  @override
  DartType get dartType => DartObject();

  @override
  String get name => "Object";

  @override
  SwiftType get swiftType => SwiftObject();
}

class CObject extends CType {
  @override
  String get name => "Dart_Handle";

  @override
  String get cInteropMapping => "Dart_Handle";

  @override
  String get dartFfiMapping => "Object";
}

class DartObject extends DartType {
  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    // No conversion required
    return CodeUnit(content: "final ${variableName}Value = sourceFfiValue;");
  }

  @override
  String get name => "Object";
}

class SwiftObject extends SwiftType {
  @override
  String get name => "Dart_Handle";
}

class OptionalCObject extends CType {
  @override
  String get name => "Dart_Handle";

  @override
  String get cInteropMapping => "Dart_Handle?";

  @override
  String get dartFfiMapping => "Object?";
}
