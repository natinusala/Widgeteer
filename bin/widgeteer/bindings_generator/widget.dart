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

import 'binding.dart';

import 'package:path/path.dart' as p;

import 'code_unit.dart';
import 'parameter.dart';

class WidgetBinding extends Binding {
  final BindingContext context;

  final String widgetName;
  final String tomlPath;
  final ParametersList parameters;

  /// Dart import to use to make the widget class accessible.
  final String widgetLocation;

  WidgetBinding({
    required this.context,
    required this.widgetName,
    required this.widgetLocation,
    required this.tomlPath,
    required this.parameters,
  });

  factory WidgetBinding.fromTOML(
      String tomlPath, String fileStem, Map toml, BindingContext context) {
    final parameters = ParametersList.fromTOML(toml["parameter"], context);

    // Insert the "key" parameter at the beginning of parameters of all widgets
    parameters.insert(
        0,
        Parameter(
          name: "key",
          type: "WidgetKey",
          swiftLabel: null,
          dartNamed: true,
        ));

    // Widget
    return WidgetBinding(
      context: context,
      widgetName: fileStem,
      tomlPath: tomlPath,
      widgetLocation: toml["widget"]["location"],
      parameters: parameters,
    );
  }

  @override
  String get name => widgetName;

  @override
  CType get cType => throw UnimplementedError();

  @override
  DartType get dartType => DartWidget(this);

  @override
  SwiftType get swiftType => SwiftWidget(this);

  @override
  String get origin => p.relative(tomlPath);
}

class DartWidget extends DartType {
  final WidgetBinding binding;

  DartWidget(this.binding);

  @override
  String get name => binding.name;

  @override
  CodeUnit? get body {
    var body = CodeUnit();

    // Imports
    body.append("import '${binding.widgetLocation}';");
    body.append("import 'dart:ffi';");
    body.append("import 'package:ffi/ffi.dart';");

    // "new" outlet implementation
    body.appendAll(newOutletImpl);

    return body;
  }

  CodeUnit get newOutletImpl {
    final functionName = "new$name";

    // Function body
    var body = CodeUnit();

    // C -> Dart parameters conversion
    for (final parameter in binding.parameters) {
      final type = binding.context.resolveBinding(parameter.type);
      body.appendAll(type.dartType.fromCValue(parameter.name, parameter.name));
    }

    // Return statement
    body.append("return $name(${binding.parameters.dartArguments});");

    // Function signature
    var function = CodeUnit();

    function.append(
        "Object $functionName(${binding.parameters.dartFFIParameters}) {");
    function.appendAll(body, indent: 4);
    function.append("}");
    return function;
  }

  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    return CodeUnit(
        content: "final ${variableName}Value = $sourceFfiValue as Widget;");
  }
}

class SwiftWidget extends SwiftType {
  final WidgetBinding binding;

  SwiftWidget(this.binding);

  @override
  String get name => binding.name;

  @override
  CodeUnit? get body {
    var body = CodeUnit();
    return body;
  }
}
