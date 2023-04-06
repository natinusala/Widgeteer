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

import '../bindings_generator/models/binding.dart';

import 'package:path/path.dart' as p;

import '../bindings_generator/code_unit.dart';
import '../bindings_generator/models/dart_function.dart';
import '../bindings_generator/models/parameter.dart';
import 'object.dart';

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

  /// Function to create a new instance of the widget.
  DartFunction get newFunction => DartFunction(
        context: context,
        outletName: "new$name",
        location: widgetLocation,
        // widget constructor is just a function that has the widget name
        name: name,
        parameters: parameters,
        returnType: 'Object',
      );

  @override
  String get name => widgetName;

  @override
  CType get cType => CObject();

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

    // "new" outlet
    body.appendUnit(binding.newFunction.outletImplementation);

    return body;
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
