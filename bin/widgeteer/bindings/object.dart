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
  List<BoundType> get types => [ObjectType(), OptionalObjectType()];
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
  String get swiftCInteropMapping => "Dart_Handle";

  @override
  String get dartFfiMapping => "Object";

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    throw UnimplementedError();
  }

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class DartObject extends DartType {
  @override
  CodeUnit fromCValue(String source, String destination) {
    // No conversion required
    return CodeUnit([
      "final ${destination}Value = $source;",
    ]);
  }

  @override
  String get name => "Object";
}

class SwiftObject extends SwiftType {
  @override
  String get name => "Dart_Handle";

  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class OptionalObjectType extends BoundType {
  @override
  CType get cType => OptionalCObject();

  @override
  DartType get dartType => OptionalDartObject();

  @override
  String get name => "Object?";

  @override
  SwiftType get swiftType => OptionalSwiftObject();
}

class OptionalDartObject extends DartType {
  @override
  CodeUnit fromCValue(String source, String destination) {
    // No conversion required
    return CodeUnit([
      "final ${destination}Value = sourceFfiValue;",
    ]);
  }

  @override
  String get name => "Object?";
}

class OptionalSwiftObject extends SwiftType {
  @override
  String get name => "Dart_Handle?";

  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class OptionalCObject extends CType {
  @override
  String get name => "Dart_Handle";

  @override
  String get swiftCInteropMapping => "Dart_Handle?";

  @override
  String get dartFfiMapping => "Object?";

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    throw UnimplementedError();
  }

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }
}
