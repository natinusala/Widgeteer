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

class WidgetParameter {
  final String name;
  final String label;
  final String type;

  WidgetParameter({
    required this.name,
    required this.label,
    required this.type,
  });

  factory WidgetParameter.fromTOML(Map toml) {
    return WidgetParameter(
      name: toml["name"],
      label: toml["label"] ?? "_",
      type: toml["type"],
    );
  }
}

class WidgetBinding extends Binding {
  final String widgetName;
  final String tomlPath;
  final List<WidgetParameter> parameters;

  /// Dart import to use to make the widget class accessible.
  final String widgetLocation;

  WidgetBinding({
    required this.widgetName,
    required this.widgetLocation,
    required this.tomlPath,
    required this.parameters,
  });

  factory WidgetBinding.fromTOML(String tomlPath, String fileStem, Map toml) {
    final List<Map<String, dynamic>> parameters = toml["parameter"] ?? [];

    // Widget
    return WidgetBinding(
      widgetName: fileStem,
      tomlPath: tomlPath,
      widgetLocation: toml["widget"]["location"],
      parameters: parameters.map((e) => WidgetParameter.fromTOML(e)).toList(),
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
    var unit = CodeUnit();
    return unit;
  }
}

class SwiftWidget extends SwiftType {
  final WidgetBinding binding;

  SwiftWidget(this.binding);

  @override
  String get name => binding.name;

  @override
  CodeUnit? get body {
    var unit = CodeUnit();
    return unit;
  }
}
