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

class VoidBinding extends Binding {
  @override
  String get name => "Void";

  @override
  String get origin => "built in";

  @override
  List<BoundType> get types => [VoidType()];
}

class VoidType extends BoundType {
  @override
  CType get cType => CVoid();

  @override
  DartType get dartType => DartVoid();

  @override
  String get name => "Void";

  @override
  SwiftType get swiftType => SwiftVoid();
}

class SwiftVoid extends SwiftType {
  @override
  String get name => "Void";

  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class DartVoid extends DartType {
  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }

  @override
  String get name => "void";
}

class CVoid extends CType {
  @override
  String get swiftCInteropMapping => "Void";

  @override
  String get dartFfiMapping => "void";

  @override
  String get name => "void";

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    throw UnimplementedError();
  }

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }
}
