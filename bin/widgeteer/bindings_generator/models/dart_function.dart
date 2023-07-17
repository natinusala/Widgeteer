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
  /// If `isInit` is specified, the outlet will be considered an "init" outlet
  /// and the generated implementation will use `initType` when possible.
  CodeUnit outletImplementation(bool isInit) {
    final outlet = CodeUnit.empty();

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
    outlet.appendUnit(outletFunction(isInit));

    return outlet;
  }

  CodeUnit outletFunction(bool isInit) {
    final resolvedType = context.resolveType(returnType);

    // Function body
    final body = CodeUnit.empty();

    // C -> Dart parameters conversion
    body.appendUnit(parameters.dartValuesFromFFI(context, isInit));

    // Return statement
    body.appendEmptyLine();
    if (returnType == "Void") {
      body.appendLine("$name(${parameters.dartArguments});");
    } else {
      body.appendLine("return $name(${parameters.dartArguments});");
    }

    // Function signature
    final function = CodeUnit.empty();

    function.enterScope(
        "${resolvedType.cType.dartFfiMapping} $outletImplementationName(${parameters.dartFFIParameters(isInit)}) {");
    function.appendUnit(body);
    function.exitScope("}");
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
