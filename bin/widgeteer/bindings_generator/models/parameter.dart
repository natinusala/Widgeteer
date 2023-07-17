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

import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:recase/recase.dart';

import '../code_unit.dart';
import 'binding.dart';
import 'outlet.dart';

/// A parameter of a function call.
class Parameter {
  final BindingContext context;

  final String? swiftLabel;
  final String name;
  final String type;
  final String? initType;
  final bool dartNamed;

  /// Default value to use when having this parameter in
  /// a Swift initializer, making the parameter optional.
  final String? defaultValue;

  Parameter({
    required this.name,
    required this.type,
    required this.swiftLabel,
    required this.dartNamed,
    required this.defaultValue,
    required this.initType,
    required this.context,
  });

  factory Parameter.fromTOML(BindingContext context, Map toml) {
    return Parameter(
      name: toml["name"],
      swiftLabel: toml["swift_label"],
      type: toml["type"],
      dartNamed: toml["dart_named"] ?? false,
      defaultValue: toml["default_value"],
      initType: toml["init_type"],
      context: context,
    );
  }

  /// When the parameters is also a property, this outlet allows Swift to
  /// read its value from Dart.
  ///
  /// [containerType] is the name of the type containing the
  /// property, used to strongly type the target instance.
  Outlet getterOutlet(String containerType) => Outlet(
        context: context,
        implementationName: "${containerType.camelCase}Get${name.pascalCase}",
        parameters: ParametersList(context, [
          Parameter(
            context: context,
            dartNamed: false,
            defaultValue: null,
            initType: null,
            name: "instance",
            swiftLabel: "_",
            type: containerType,
          ),
        ]),
        name: "${containerType}Get${name.pascalCase}",
        returnType: type,
      );
}

class ParametersList with IterableMixin<Parameter> {
  final BindingContext context;
  final List<Parameter> parameters;

  ParametersList(this.context, this.parameters);

  factory ParametersList.fromTOML(
      List<Map<String, dynamic>> toml, BindingContext context) {
    return ParametersList(
        context, toml.map((e) => Parameter.fromTOML(context, e)).toList());
  }

  /// Parameters list as Dart function parameters (to be used in the function signature).
  String get dartParameters {
    var parameters = [];

    for (final parameter in this.parameters) {
      final type = context.resolveType(parameter.type);
      parameters.add("${type.name} ${parameter.name}");
    }

    return parameters.join(", ");
  }

  /// Parameters list as Dart FFI function parameters (to be used in the FFI function signature).
  String dartFFIParameters(bool isInit) {
    var parameters = [];

    for (final parameter in this.parameters) {
      final type = context.resolveType(
          isInit ? (parameter.initType ?? parameter.type) : parameter.type);
      parameters.add("${type.cType.dartFfiMapping} ${parameter.name}");
    }

    return parameters.join(", ");
  }

  /// Parameters list as Dart call arguments (to be used in the function call).
  /// Expects the variables to use the `${parameter.name}Value` convention.
  String get dartArguments {
    var parameters = [];

    for (final parameter in this.parameters) {
      if (parameter.dartNamed) {
        parameters.add("${parameter.name}: ${parameter.name}Value");
      } else {
        parameters.add("${parameter.name}Value");
      }
    }

    return parameters.join(", ");
  }

  /// Creates a list of `${parameter.name}Value` Dart declarations
  /// that takes the parameters in their FFI form and turn them into their
  /// final Dart values.
  CodeUnit dartValuesFromFFI(BindingContext context, bool isInit) {
    final values = CodeUnit.empty();

    for (final parameter in this) {
      final type = context.resolveType(
          isInit ? (parameter.initType ?? parameter.type) : parameter.type);
      values
          .appendUnit(type.dartType.fromCValue(parameter.name, parameter.name));
    }

    return values;
  }

  /// List of parameters to put in a C function declaration.
  String get cDeclaration => parameters
      .map((element) =>
          "${context.resolveType(element.type).cType.name} ${element.name}")
      .join(", ");

  /// List of parameters to put in a Swift `@_cdecl` function
  /// signature or a `@convention(c)` closure type.
  String get swiftCFunctionParameters => parameters.map((element) {
        final resolvedType = context.resolveType(element.type);
        return "_ ${element.name}: ${resolvedType.cType.swiftCInteropMapping}";
      }).join(", ");

  /// Swift discarded closure parameters.
  String get swiftClosureDiscardParameters =>
      parameters.map((element) => "_").join(", ");

  /// Swift named closure parameters.
  /// Parameters will be named `p0`, `p1`, `p2`...
  String get swiftClosureNamedParameters =>
      parameters.mapIndexed((index, element) => "p$index").join(", ");

  /// Swift initializer parameters.
  String get swiftInitParameters {
    List<String> parameters = [];

    for (final parameter in this) {
      final resolvedType =
          context.resolveType(parameter.initType ?? parameter.type);

      var str = "";

      for (final attribute in resolvedType.swiftType.initAttributes) {
        str += "$attribute ";
      }

      if (parameter.swiftLabel != null) {
        str += "${parameter.swiftLabel} ";
      }

      str += "${parameter.name}: ${resolvedType.swiftType.initType}";

      if (parameter.defaultValue != null) {
        str += " = ${parameter.defaultValue}";
      }

      parameters.add(str);
    }

    return parameters.join(", ");
  }

  /// Swift property declarations (`let` constants).
  CodeUnit get swiftProperties {
    final properties = CodeUnit.empty();

    for (final parameter in this) {
      final resolvedType = context.resolveType(parameter.type);
      properties
          .appendLine("let ${parameter.name}: ${resolvedType.swiftType.name}");
    }

    return properties;
  }

  /// Swift initializer that sets all properties.
  CodeUnit get swiftInitializer {
    final init = CodeUnit.empty();

    init.enterScope("public init($swiftInitParameters) {");

    for (final parameter in this) {
      final resolvedType = context.resolveType(parameter.type);

      init.appendLine(
          "self.${parameter.name} = ${resolvedType.swiftType.initSetterValue(parameter.name)}");
    }

    init.exitScope("}");

    return init;
  }

  void insert(int index, Parameter element) {
    parameters.insert(index, element);
  }

  ParametersList sublist(int start, [int? end]) {
    return ParametersList(context, parameters.toList().sublist(start, end));
  }

  @override
  Iterator<Parameter> get iterator => parameters.iterator;

  ParametersList operator +(ParametersList other) {
    return ParametersList(context, parameters + other.parameters);
  }
}
