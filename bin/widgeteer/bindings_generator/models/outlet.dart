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

  /// Name of the bound function as exposed to the Swift library.
  late String swiftFunctionName = "Flutter_$name";

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
  CodeUnit get dartRegistrationCall {
    final resolvedReturnType = context.resolveType(returnType);

    if (resolvedReturnType.cType.exceptionalReturnValue != null) {
      return CodeUnit([
        "widgeteer.$cRegistrationDeclarationName(Pointer.fromFunction($implementationName, ${resolvedReturnType.cType.exceptionalReturnValue}));",
      ]);
    } else {
      return CodeUnit([
        "widgeteer.$cRegistrationDeclarationName(Pointer.fromFunction($implementationName));",
      ]);
    }
  }

  /// Swift closure type aliases, registration function and function to call
  /// in the rest of the program.
  CodeUnit get swiftRegistration {
    final cFuncTypealias = "_${name}_CFunctionPointer";
    final resolvedReturnType = context.resolveType(returnType);
    final closureTypeAlias =
        "(${parameters.swiftCFunctionParameters}) -> ${resolvedReturnType.cType.swiftCInteropMapping}";

    final registration = CodeUnit.empty();

    // C Function Pointer typealias
    registration.appendLine(
        "public typealias $cFuncTypealias = @convention(c) $closureTypeAlias");

    // Swift typealias
    registration.appendLine("public typealias _$name = $closureTypeAlias");

    // Function pointer storage
    registration.appendEmptyLine();
    registration.appendLine(
        'public var $swiftFunctionName: _$name = { (${parameters.swiftClosureDiscardParameters}) in fatalError("\'$name\' called before it was registered") }');

    // Registration function
    registration.appendEmptyLine();
    registration.appendLine('@_cdecl("$cRegistrationDeclarationName")');
    registration
        .enterScope("public func _register$name(_ outlet: $cFuncTypealias) {");
    registration.appendLine("assertIsOnFlutterThread()");
    registration.appendLine('trace("Registering \'$name\'")');
    registration.appendLine(
        "$swiftFunctionName = { (${parameters.swiftClosureNamedParameters}) in assertIsOnFlutterThread(); return outlet(${parameters.swiftClosureNamedParameters}) }");
    registration.exitScope("}");

    return registration;
  }

  /// Generates a Swift call to the outlet, setting the result in [destination].
  /// TODO: use inside widgets reductionFunction too
  CodeUnit swiftCall(String destination) {
    final call = CodeUnit.empty();

    call.appendLine("assertIsOnFlutterThread()");
    call.appendEmptyLine();

    // Translate all properties from Swift to C
    for (final property in parameters) {
      final resolvedType =
          context.resolveType(property.initType ?? property.type);

      call.appendUnit(
          resolvedType.cType.fromSwiftValue(property.name, property.name));

      final cleanup = resolvedType.cType
          .fromSwiftValueCleanup(property.name, property.name);
      if (cleanup != null) {
        call.enterScope("defer {");
        call.appendUnit(cleanup);
        call.exitScope("}");
      }
    }

    // Call
    call.enterScope("let $destination = $swiftFunctionName(");
    call.appendLines(parameters
        .map((element) => "${element.name}Value")
        .join(",\n")
        .split("\n"));
    call.exitScope(")");

    return call;
  }
}

class EmittedOutlet {
  final Binding binding;
  final Outlet outlet;

  EmittedOutlet(this.binding, this.outlet);
}
