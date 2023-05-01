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

import 'package:path/path.dart' as p;

import '../bindings_generator/code_unit.dart';
import '../bindings_generator/models/binding.dart';
import '../bindings_generator/models/type.dart';

/// A binding to any Dart object to be persisted in Swift.
/// Called "class" in bindings for simplicity but can be used on any Dart type
/// that's an object and supports method calls.
///
/// On bridging, the handle is turned into a "persistent" handle and given to a Swift class instance.
/// The persistent handle is then freed when the Swift instance is collected by ARC.
class PersistentObjectBinding extends Binding {
  final String className;
  final String classLocation;
  final String tomlPath;

  PersistentObjectBinding({
    required this.className,
    required this.classLocation,
    required this.tomlPath,
  });

  factory PersistentObjectBinding.fromTOML(
      String tomlPath, String fileStem, Map toml, BindingContext context) {
    return PersistentObjectBinding(
      className: fileStem,
      classLocation: toml["class"]["location"],
      tomlPath: tomlPath,
    );
  }

  @override
  String get name => className;

  @override
  String get origin => p.relative(tomlPath);

  @override
  List<BoundType> get types =>
      [PersistentObjectType(this)]; // TODO: add optional support

  @override
  CodeUnit get swiftBody {
    final body = CodeUnit();
    return body;
  }
}

class PersistentObjectType extends BoundType {
  final PersistentObjectBinding binding;

  PersistentObjectType(this.binding);

  @override
  CType get cType => throw UnimplementedError();

  @override
  DartType get dartType => throw UnimplementedError();

  @override
  String get name => binding.className;

  @override
  SwiftType get swiftType => throw UnimplementedError();
}
