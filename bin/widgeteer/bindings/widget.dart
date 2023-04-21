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

import '../bindings_generator/models/binding.dart';

import 'package:path/path.dart' as p;

import '../bindings_generator/code_unit.dart';
import '../bindings_generator/models/dart_function.dart';
import '../bindings_generator/models/outlet.dart';
import '../bindings_generator/models/parameter.dart';
import '../bindings_generator/models/type.dart';

/// Binding for a specific widget found in Flutter or an external library.
class WidgetBinding extends Binding {
  final BindingContext context;

  final String widgetName;
  final String tomlPath;
  final ParametersList parameters;
  final List<WidgetContentType> content;

  /// Dart import to use to make the widget class accessible.
  final String widgetLocation;

  WidgetBinding({
    required this.context,
    required this.widgetName,
    required this.widgetLocation,
    required this.tomlPath,
    required this.parameters,
    required this.content,
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

    // Parse content
    final List<WidgetContentType> contentList = [];

    for (final Map<String, dynamic> content in toml["content"] ?? {}) {
      contentList.add(WidgetContentType.fromTOML(fileStem, content));
    }

    // Create binding
    return WidgetBinding(
      context: context,
      widgetName: fileStem,
      tomlPath: tomlPath,
      widgetLocation: toml["widget"]["location"],
      parameters: parameters,
      content: contentList,
    );
  }

  late WidgetType widgetType = WidgetType(this);
  late OptionalWidgetType optionalWidgetType = OptionalWidgetType(this);

  @override
  List<BoundType> get types => [widgetType, optionalWidgetType] + content;

  @override
  List<Outlet> get outlets => [newFunction.callingOutlet];

  @override
  String get origin => p.relative(tomlPath);

  @override
  String get name => widgetName;

  bool get hasContent => content.isNotEmpty;

  /// Function to create a new instance of the widget.
  late DartFunction newFunction = DartFunction(
    context: context,
    outletName: "new$name",
    location: widgetLocation,
    // widget constructor is just a function that has the widget name
    name: name,
    parameters: parameters +
        ParametersList(context, content.map((e) => e.parameter).toList()),
    returnType: 'Object',
  );

  @override
  CodeUnit? get dartBody {
    final body = CodeUnit();

    // Both normal and optional types use the same creation outlet
    body.appendUnit(newFunction.outletImplementation);

    return body;
  }

  /// Generic parameters clause of the Swift struct.
  String get swiftGenericParameters {
    if (!hasContent) {
      return "";
    }

    return "<${content.map((e) => "${e.swiftGenericParameter}: ${e.swiftGenericConstraint}").join(", ")}>";
  }

  @override
  CodeUnit? get swiftBody {
    final body = CodeUnit();

    // Swift struct
    body.appendUnit(swiftStruct);

    return body;
  }

  /// The Swift struct properties.
  /// Remove the first parameter that's always the key as it is computed
  /// during reduction and is invisible to the user
  ParametersList get swiftProperties {
    final parametersProperties =
        parameters.isNotEmpty ? parameters.sublist(1) : parameters;

    // TODO: sort content
    final contentProperties =
        ParametersList(context, content.map((e) => e.parameter).toList());

    return parametersProperties + contentProperties;
  }

  CodeUnit get swiftStruct {
    final struct = CodeUnit();

    struct.appendLine(
        "public struct $widgetName$swiftGenericParameters: BuiltinWidget {");

    // Properties
    struct.appendUnit(swiftProperties.swiftProperties, indentedBy: 4);

    // Initializer
    struct.appendEmptyLine();
    struct.appendUnit(swiftProperties.swiftInitializer, indentedBy: 4);

    // Reduction function
    struct.appendEmptyLine();
    struct.appendUnit(reductionFunction, indentedBy: 4);

    struct.appendLine("}");
    return struct;
  }

  CodeUnit get reductionFunction {
    final reduce = CodeUnit();

    reduce.appendLine(
        "public func reduce(parentKey: WidgetKey) -> ReducedWidget {");

    // Translate all properties from Swift to C
    for (final property in swiftProperties) {
      final resolvedType = context.resolveType(property.type);

      reduce.appendUnit(
          resolvedType.cType
              .fromSwiftValue("self.${property.name}", property.name),
          indentedBy: 4);
    }

    reduce.appendLine(
        "let localHandle = ${newFunction.callingOutlet.swiftFunctionName}(",
        indentedBy: 4);

    // Key
    reduce.appendLine("parentKey.joined(String(describing: Self.self)),",
        indentedBy: 8);

    reduce.appendLines(
        swiftProperties
            .map((element) => "${element.name}Value")
            .join(",\n")
            .split("\n"),
        indentedBy: 8);

    reduce.appendLine(")", indentedBy: 4);

    reduce.appendLine("return ReducedWidget(handle: localHandle)",
        indentedBy: 4);

    reduce.appendLine("}");

    return reduce;
  }
}

class WidgetType extends BoundType {
  final WidgetBinding binding;

  WidgetType(this.binding);

  @override
  String get name => binding.widgetName;

  @override
  CType get cType => CWidget();

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

class CWidget extends CType {
  @override
  String get dartFfiMapping => "Object";

  @override
  CodeUnit fromSwiftValue(String sourceValue, String variableName) {
    return CodeUnit(
        content:
            "let ${variableName}Value = $sourceValue.reduce(parentKey: parentKey.joined(\"$variableName\")).handle");
  }

  @override
  String get name => "Dart_Handle";

  @override
  String get swiftCInteropMapping => "Dart_Handle";
}

class OptionalWidgetType extends BoundType {
  final WidgetBinding binding;

  OptionalWidgetType(this.binding);

  @override
  String get name => "${binding.widgetName}?";

  @override
  CType get cType => OptionalCWidget();

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

class OptionalCWidget extends CType {
  @override
  String get dartFfiMapping => "Object?";

  @override
  CodeUnit fromSwiftValue(String sourceValue, String variableName) {
    return CodeUnit(
        content:
            "let ${variableName}Value = $sourceValue?.reduce(parentKey: parentKey.joined(\"$variableName\")).handle");
  }

  @override
  String get name => "Dart_Handle";

  @override
  String get swiftCInteropMapping => "Dart_Handle?";
}

/// Content of a widget.
class WidgetContentType extends BoundType {
  final String widgetName;

  /// Camel case name of the content property.
  final String contentName;

  final bool multi;
  final bool dartNamed;

  WidgetContentType({
    required this.contentName,
    required this.dartNamed,
    required this.multi,
    required this.widgetName,
  });

  factory WidgetContentType.fromTOML(String widgetName, Map toml) {
    return WidgetContentType(
      contentName: toml["name"],
      dartNamed: toml["dart_named"],
      multi: toml["multi"],
      widgetName: widgetName,
    );
  }

  /// Name of the Swift generic parameter.
  String get swiftGenericParameter => contentName.pascalCase;

  /// Name of the Swift generic parameter contraint.
  String get swiftGenericConstraint => multi ? "MultiWidget" : "SingleWidget";

  String get dartClass => "Widget";

  @override
  CType get cType => CWidgetContent(this);

  @override
  DartType get dartType => DartWidgetContent(this);

  @override
  String get name => "$widgetName/$swiftGenericParameter";

  @override
  SwiftType get swiftType => SwiftWidgetContent(this);

  /// Parameter to use this content in the widget.
  Parameter get parameter {
    return Parameter(
      name: contentName,
      type: name,
      swiftLabel: null,
      dartNamed: dartNamed,
    );
  }
}

class SwiftWidgetContent extends SwiftType {
  final WidgetContentType type;

  SwiftWidgetContent(this.type);

  @override
  String get name => type.swiftGenericParameter;

  @override
  String get initType => "() -> $name";

  @override
  String initSetterValue(String source) {
    return "$source()";
  }
}

class DartWidgetContent extends DartType {
  final WidgetContentType type;

  DartWidgetContent(this.type);

  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) => CodeUnit(
      content:
          "final ${variableName}Value = $sourceFfiValue as ${type.dartClass};");

  @override
  String get name => type.dartClass;
}

class CWidgetContent extends CType {
  final WidgetContentType type;

  CWidgetContent(this.type);

  @override
  String get dartFfiMapping => "Object";

  @override
  CodeUnit fromSwiftValue(String sourceValue, String variableName) => CodeUnit(
      content:
          "let ${variableName}Value = $sourceValue.reduce(parentKey: parentKey.joined(\"$variableName\")).handle");

  @override
  String get name => "Dart_Handle";

  @override
  String get swiftCInteropMapping => "Dart_Handle";
}
