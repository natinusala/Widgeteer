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

import '../code_unit.dart';
import 'outlet.dart';
import 'type.dart';

/// A binding can be a widget, a class, a function, a callback type
/// or any other Dart construct exposed to Swift and accessible through
/// outlets.
///
/// Bindings can emit any number of [BoundType]s and outlets. Additionnally,
/// each binding has a Swift file and a Dart file (called their "body").
abstract class Binding {
  /// Name of the binding,
  String get name;

  /// Where does the binding come from?
  /// Used for debugging purposes.
  String get origin;

  /// Outlets emitted by this binding.
  List<Outlet> get outlets => [];

  /// Bound types emitted by this binding.
  List<BoundType> get types => [];

  /// Body of the generated Dart file for this binding.
  CodeUnit? get dartBody => null;

  /// Body of the generated Swift file for this binding.
  CodeUnit? get swiftBody => null;

  /// If the binding needs additional C declarations, they have to be added
  /// here so that ffigen can generate the corresponding Dart bindings for them.
  /// They will be made available in `libWidgeteer` like all the others.
  CodeUnit? get cDeclarations => null;

  String get description {
    List<String> output = [];
    output.addAll(types.map((e) => e.name));

    if (output.isNotEmpty) {
      return "$name ($origin) => ${output.join(", ")}";
    } else {
      return "$name ($origin)";
    }
  }

  /// Does the "Dart body" for this binding need to be imported for other
  /// bindings to use its types?
  bool get importBody => false;
}

class BindingContext {
  List<BoundType>? types;

  BoundType resolveType(String name) {
    if (types == null) {
      throw "Binding context used too early; "
          "please wait for all bindings to be loaded before attempting a resolution.";
    }

    for (final type in types!) {
      if (type.name == name) {
        return type;
      }
    }

    throw "Type resolution failed: did not find a type named '$name'.";
  }
}
