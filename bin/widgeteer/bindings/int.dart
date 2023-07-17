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

class IntBinding extends Binding {
  @override
  String get name => "Int";

  @override
  String get origin => "built in";

  @override
  List<BoundType> get types => [IntType()];
}

class IntType extends BoundType {
  @override
  CType get cType => CInt();

  @override
  DartType get dartType => DartInt();

  @override
  String get name => "Int";

  @override
  SwiftType get swiftType => SwiftInt();
}

class SwiftInt extends SwiftType {
  @override
  String get name => "Int";

  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class DartInt extends DartType {
  @override
  CodeUnit fromCValue(String source, String destination) {
    return CodeUnit([
      "final ${destination}Value = $source;",
    ]);
  }

  @override
  String get name => "int";
}

class CInt extends CType {
  @override
  String get dartFfiMapping => "int";

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    return CodeUnit([
      "let ${destination}Value = $source",
    ]);
  }

  @override
  String get name => "int";

  @override
  String get swiftCInteropMapping => "Int";

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }
}
