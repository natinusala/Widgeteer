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

import 'package:recase/recase.dart';

import '../code_unit.dart';
import '../extensions/String+Extensions.dart';
import 'binding.dart';
import 'parameter.dart';

/// A Swift to Dart function call that goes through a special
/// registration process during the bootstrap sequence.
///
/// This registration allows Swift to call any Dart function from anywhere
/// as long as it's on the main Flutter thread.
class Outlet {
  BindingContext context;

  /// Pascal case name of the outlet.
  final String name;

  /// Name of the Dart implementation to call.
  final String implementationName;

  /// What Dart file to import to make the implementation to call
  /// visible.
  final String? implementationLocation;

  final String returnType;

  /// Parameters of the outlet.
  final ParametersList parameters;

  late String cRegistrationDeclarationName = "register_${name.snakeCase}";

  Outlet({
    required this.context,
    required this.implementationName,
    required this.parameters,
    required this.name,
    required this.returnType,
    this.implementationLocation,
  }) {
    if (!name.isPascalCase) {
      throw "Outlet names must be pascal case, '$name' is not pascal case.";
    }
  }

  /// C declaration of the registration function.
  String get registrationCDeclaration {
    final resolvedReturnType = context.resolveType(returnType);

    return "extern void $cRegistrationDeclarationName(${resolvedReturnType.cType.name} (*outlet)(${parameters.cDeclaration}));";
  }

  /// Dart code to call to register the outlet to Swift.
  /// Assuming the library binding is available under the `widgeteer` name.
  CodeUnit get dartRegistrationCall => CodeUnit(
      content:
          "widgeteer.$cRegistrationDeclarationName(Pointer.fromFunction($implementationName));");
}

class EmittedOutlet {
  final Binding binding;
  final Outlet outlet;

  EmittedOutlet(this.binding, this.outlet);
}
