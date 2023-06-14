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
import 'binding.dart';
import 'outlet.dart';
import 'parameter.dart';

/// A Dart function that can be called from Swift using an outlet.
class DartFunction {
  final BindingContext context;

  /// Name of the original Dart function to call in the outlet.
  final String name;

  /// Name of the generated outlet.
  final String outletName;

  /// What Dart file to import to make the function visible.
  final String location;

  /// Return type of the original function.
  /// Must be a known bound type.
  final String returnType;

  final ParametersList parameters;

  DartFunction({
    required this.outletName,
    required this.context,
    required this.name,
    required this.location,
    required this.returnType,
    required this.parameters,
  });

  String get outletImplementationName => "${outletName}Impl";

  /// Dart code containing some imports and the implementation function
  /// for the outlet.
  CodeUnit get outletImplementation {
    final outlet = CodeUnit();

    // Imports
    outlet.appendLines([
      "import '$location';",
      "import 'dart:ffi';",
      "import 'package:ffi/ffi.dart';",
      "import 'package:widgeteer/generated/lib_widgeteer.dart';",
      "import 'package:widgeteer/swift.dart';",
      "import 'package:flutter/foundation.dart';",
    ]);

    // Function
    outlet.appendUnit(_outletFunction);

    return outlet;
  }

  CodeUnit get _outletFunction {
    final returnType = context.resolveType(this.returnType);

    // Function body
    final body = CodeUnit();

    // C -> Dart parameters conversion
    body.appendUnit(parameters.dartValuesFromFFI(context));

    // Return statement
    body.appendEmptyLine();
    body.appendLine("return $name(${parameters.dartArguments});");

    // Function signature
    final function = CodeUnit();

    function.appendLine(
        "${returnType.cType.dartFfiMapping} $outletImplementationName(${parameters.dartFFIParameters}) {");
    function.appendUnit(body, indentedBy: 4);
    function.appendLine("}");
    return function;
  }

  /// An outlet that calls that function.
  Outlet get callingOutlet => Outlet(
        context: context,
        name: outletName.pascalCase,
        returnType: returnType,
        implementationName: outletImplementationName,
        parameters: parameters,
      );
}
