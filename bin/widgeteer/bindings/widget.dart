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
import '../bindings_generator/models/outlet.dart';
import '../bindings_generator/models/parameter.dart';
import '../bindings_generator/models/type.dart';
import 'object.dart';

/// Binding for a specific widget found in Flutter or an external library.
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

  late WidgetType widgetType = WidgetType(this);
  late OptionalWidgetType optionalWidgetType = OptionalWidgetType(this);

  @override
  List<BoundType> get types => [widgetType, optionalWidgetType];

  @override
  List<Outlet> get outlets => [newFunction.callingOutlet];

  @override
  String get origin => p.relative(tomlPath);

  @override
  String get name => widgetName;

  /// Function to create a new instance of the widget.
  late DartFunction newFunction = DartFunction(
    context: context,
    outletName: "new$name",
    location: widgetLocation,
    // widget constructor is just a function that has the widget name
    name: name,
    parameters: parameters,
    returnType: 'Object',
  );

  @override
  CodeUnit? get dartBody {
    final body = CodeUnit();

    // Both normal and optional types use the same creation outlet
    body.appendUnit(newFunction.outletImplementation);

    return body;
  }

  @override
  CodeUnit? get swiftBody {
    final body = CodeUnit();
    return body;
  }
}

class WidgetType extends BoundType {
  final WidgetBinding binding;

  WidgetType(this.binding);

  @override
  String get name => binding.widgetName;

  @override
  CType get cType => CObject();

  @override
  DartType get dartType => DartWidget(this);

  @override
  SwiftType get swiftType => SwiftWidget(this);
}

class DartWidget extends DartType {
  final WidgetType type;

  DartWidget(this.type);

  @override
  String get name => type.name;

  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    return CodeUnit(
        content: "final ${variableName}Value = $sourceFfiValue as $name;");
  }
}

class SwiftWidget extends SwiftType {
  final WidgetType type;

  SwiftWidget(this.type);

  @override
  String get name => type.name;
}

class OptionalWidgetType extends BoundType {
  final WidgetBinding binding;

  OptionalWidgetType(this.binding);

  @override
  String get name => "${binding.widgetName}?";

  @override
  CType get cType => OptionalCObject();

  @override
  DartType get dartType => OptionalDartWidget(this);

  @override
  SwiftType get swiftType => OptionalSwiftWidget(this);
}

class OptionalDartWidget extends DartType {
  final OptionalWidgetType type;

  OptionalDartWidget(this.type);

  @override
  String get name => "${type.name}?";

  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    return CodeUnit(
        content: "final ${variableName}Value = $sourceFfiValue as $name;");
  }
}

class OptionalSwiftWidget extends SwiftType {
  final OptionalWidgetType type;

  OptionalSwiftWidget(this.type);

  @override
  String get name => "${type.name}?";
}
