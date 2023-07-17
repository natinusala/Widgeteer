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

import 'package:collection/collection.dart';
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

  /// The Dart super class of this widget. If nothing is specified
  /// it will be assumed to be `Widget`.
  final String? superClass;

  /// Dart import to use to make the widget class accessible.
  final String widgetLocation;

  /// Name of the wrapper function for that widget, if any.
  /// The widget must have at least one content property to use a wrapper.
  ///
  /// If set, a `WidgetWraper` will be generated for this widget as well
  /// as the function to wrap another widget inside (the name of the function is
  /// stored in this property).
  ///
  /// The naming convention for wrappers and modifiers is to consider them as
  /// properties of the wrapped widgets.
  /// For `Center`, that would be `center` and not `centered` since we consider it
  /// as `center: true`.
  /// For `ColoredBox`, it would be `backgroundColor` since ultimately that's what
  /// it does to the wrapped widget. It's considered as `backgroundColor: blue`.
  final String? wrapperFunction;

  WidgetBinding({
    required this.context,
    required this.widgetName,
    required this.widgetLocation,
    required this.tomlPath,
    required this.parameters,
    required this.content,
    required this.superClass,
    required this.wrapperFunction,
  });

  factory WidgetBinding.fromTOML(
      String tomlPath, String fileStem, Map toml, BindingContext context) {
    final parameters =
        ParametersList.fromTOML(toml["parameter"] ?? [], context);

    // Insert the "key" parameter at the beginning of parameters of all widgets
    parameters.insert(
        0,
        Parameter(
          name: "key",
          type: "WidgetKey",
          swiftLabel: null,
          dartNamed: true,
          defaultValue: null,
          initType: null,
          context: context,
        ));

    // Parse content
    final List<WidgetContentType> contentList = [];

    for (int i = 0; i < (toml["content"] ?? {}).length; i++) {
      final Map<String, dynamic> content = toml["content"][i];
      contentList
          .add(WidgetContentType.fromTOML(context, fileStem, content, i));
    }

    // Create binding
    return WidgetBinding(
      context: context,
      widgetName: fileStem,
      tomlPath: tomlPath,
      widgetLocation: toml["widget"]["location"],
      parameters: parameters,
      content: contentList,
      superClass: toml["widget"]["super_class"],
      wrapperFunction: toml["widget"]["wrapper"],
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
        ParametersList(
            context,
            content
                .map((e) => e.parameter)
                .toList()
                .sorted(sortContentProperties)),
    returnType: 'Object',
  );

  @override
  CodeUnit? get dartBody {
    final body = CodeUnit.empty();

    // Both normal and optional types use the same creation outlet
    body.appendUnit(newFunction.outletImplementation(true));

    return body;
  }

  /// Generic parameters clause of the Swift struct.
  String get swiftGenericParameters {
    if (!hasContent) {
      return "";
    }

    return "<${content.map((e) => "${e.swiftGenericParameter}: ${e.swiftGenericConstraint()}").join(", ")}>";
  }

  @override
  CodeUnit? get swiftBody {
    final body = CodeUnit.empty();

    // Swift struct
    body.appendUnit(swiftStruct);

    // Wrapper, if any
    if (wrapperFunction != null) {
      body.appendEmptyLine();
      body.appendUnit(swiftWrapper);
    }

    return body;
  }

  /// The Swift widget wrapper to surround any widget in this one.
  CodeUnit get swiftWrapper {
    // Ensure the widget has at least one content property
    if (content.isEmpty) {
      throw "Cannot generate a wrapper for '$name': it has no content property.";
    }

    final wrapper = CodeUnit.empty();

    wrapper.appendUnit(swiftWrapperStruct);
    wrapper.appendEmptyLine();
    wrapper.appendUnit(swiftWrapperFunction);

    return wrapper;
  }

  String get wrapperStructName => "${name}Wrapper";

  CodeUnit get swiftWrapperStruct {
    final struct = CodeUnit.empty();

    struct.enterScope("struct $wrapperStructName: WidgetWrapper {");

    struct.enterScope("public func body(content: Content) -> $name<Content> {");

    struct.appendLine("return $name() { content }");

    struct.exitScope("}");

    struct.exitScope("}");

    return struct;
  }

  CodeUnit get swiftWrapperFunction {
    final function = CodeUnit.empty();

    function.enterScope("public extension Widget {");

    function.enterScope("func $wrapperFunction() -> some Widget {");

    function.appendLine("return self.wrapped(in: $wrapperStructName())");

    function.exitScope("}");

    function.exitScope("}");

    return function;
  }

  int sortContentProperties(Parameter a, Parameter b) {
    // We want the init to have the following order to match SwiftUI's design:
    //   - all parameters
    //   - body content
    //   - other content by order of apparition in TOML
    // The intended usage is with multi trailing closures:
    // Widget(params) { multi content } singleContent1: { ... } singleContent2: { ... }

    final aType = context.resolveType(a.type) as WidgetContentType;
    final bType = context.resolveType(b.type) as WidgetContentType;

    if (aType.body) {
      return -1;
    }

    if (bType.body) {
      return 1;
    }

    return aType.position - bType.position;
  }

  /// The Swift struct properties.
  /// Remove the first parameter that's always the key as it is computed
  /// during reduction and is invisible to the user
  ParametersList get swiftProperties {
    final parametersProperties =
        parameters.isNotEmpty ? parameters.sublist(1) : parameters;

    final contentProperties = ParametersList(context,
        content.map((e) => e.parameter).toList().sorted(sortContentProperties));

    return parametersProperties + contentProperties;
  }

  CodeUnit get swiftStruct {
    final struct = CodeUnit.empty();

    final protocol = superClass ?? "DartWidget";

    struct.enterScope(
        "public struct $widgetName$swiftGenericParameters: $protocol {");

    // Properties
    struct.appendUnit(swiftProperties.swiftProperties);

    // Initializer
    struct.appendEmptyLine();
    struct.appendUnit(swiftProperties.swiftInitializer);

    // Reduction function
    struct.appendEmptyLine();
    struct.appendUnit(reductionFunction);

    struct.exitScope("}");
    return struct;
  }

  CodeUnit get reductionFunction {
    final reduce = CodeUnit.empty();

    reduce.enterScope(
        "public func reduce(parentKey: WidgetKey) -> ReducedWidget {");

    // Translate all properties from Swift to C
    for (final property in swiftProperties) {
      final resolvedType = context.resolveType(property.type);

      reduce.appendUnit(resolvedType.cType
          .fromSwiftValue("self.${property.name}", property.name));
    }

    reduce.appendLine(
        "let localHandle = ${newFunction.callingOutlet.swiftFunctionName}(");

    // Key
    reduce.appendLine("parentKey.joined(String(describing: Self.self)),");

    reduce.appendLines(swiftProperties
        .map((element) => "${element.name}Value")
        .join(",\n")
        .split("\n"));

    reduce.appendLine(")");

    reduce.appendLine("let reducedWidget = ReducedWidget(handle: localHandle)");

    for (final property in swiftProperties) {
      final resolvedType = context.resolveType(property.type);

      final cleanup = resolvedType.cType
          .fromSwiftValueCleanup("self.${property.name}", property.name);
      if (cleanup != null) {
        reduce.appendUnit(cleanup);
      }
    }

    reduce.appendLine("return reducedWidget");

    reduce.exitScope("}");

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
  CodeUnit fromCValue(String source, String destination) {
    return CodeUnit([
      "final ${destination}Value = $source as $name;",
    ]);
  }
}

class SwiftWidget extends SwiftType {
  final WidgetType type;

  SwiftWidget(this.type);

  @override
  String get name => type.name;

  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class CWidget extends CType {
  @override
  String get dartFfiMapping => "Object";

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    return CodeUnit([
      "let ${destination}Value = $source.reduce(parentKey: parentKey.joined(\"$destination\")).handle",
    ]);
  }

  @override
  String get name => "Dart_Handle";

  @override
  String get swiftCInteropMapping => "Dart_Handle";

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }
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
  CodeUnit fromCValue(String source, String destination) {
    return CodeUnit([
      "final ${destination}Value = $source as $name;",
    ]);
  }
}

class OptionalSwiftWidget extends SwiftType {
  final OptionalWidgetType type;

  OptionalSwiftWidget(this.type);

  @override
  String get name => "${type.name}?";

  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class OptionalCWidget extends CType {
  @override
  String get dartFfiMapping => "Object?";

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    return CodeUnit([
      "let ${destination}Value = $source?.reduce(parentKey: parentKey.joined(\"$destination\")).handle",
    ]);
  }

  @override
  String get name => "Dart_Handle";

  @override
  String get swiftCInteropMapping => "Dart_Handle?";

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }
}

/// Content of a widget.
class WidgetContentType extends BoundType {
  final BindingContext context;

  /// Index of the content inside the source TOML.
  /// Used for ordering generated properties and parameters.
  final int position;

  final String widgetName;

  /// Camel case name of the content property.
  final String contentName;

  /// What widget subclass to accept as content.
  /// Defaults to `Widget`.
  final String? constraint;

  final bool multi;
  final bool dartNamed;

  final bool optional;

  /// Each widget can have one (or zero) "body" content property, which
  /// is considered the "main content" of the widget.
  ///
  /// The body will have a discard label ("_") in the initializer and will
  /// be placed last in the parameters list.
  ///
  /// All other content properties will require a label at the call site,
  /// preferably using the multiple trailing closures syntax.
  final bool body;

  WidgetContentType({
    required this.context,
    required this.contentName,
    required this.dartNamed,
    required this.multi,
    required this.widgetName,
    required this.optional,
    required this.body,
    required this.constraint,
    required this.position,
  });

  factory WidgetContentType.fromTOML(
      BindingContext context, String widgetName, Map toml, int position) {
    return WidgetContentType(
      context: context,
      contentName: toml["name"],
      dartNamed: toml["dart_named"],
      multi: toml["multi"],
      widgetName: widgetName,
      optional: toml["optional"] ?? false,
      body: toml["body"] ?? false,
      constraint: toml["constraint"],
      position: position,
    );
  }

  /// Name of the Swift generic parameter.
  String get swiftGenericParameter => contentName.pascalCase;

  /// Name of the Swift generic parameter contraint.
  String swiftGenericConstraint() {
    if (constraint != null) {
      return constraint!;
    }

    return multi
        ? "MultiWidget"
        : (optional ? "OptionalSingleWidget" : "SingleWidget");
  }

  String dartClass() {
    final className = constraint ?? "Widget";
    return optional ? "$className?" : className;
  }

  @override
  String get name => "$widgetName/$swiftGenericParameter";

  @override
  CType get cType => multi ? MultiCWidgetContent(this) : CWidgetContent(this);

  @override
  DartType get dartType =>
      multi ? MultiDartWidgetContent(this) : DartWidgetContent(this);

  @override
  SwiftType get swiftType =>
      multi ? MultiSwiftWidgetContent(this) : SwiftWidgetContent(this);

  /// Parameter to use this content in the widget.
  Parameter get parameter {
    return Parameter(
      name: contentName,
      type: name,
      swiftLabel: body ? "_" : null,
      dartNamed: dartNamed,
      defaultValue: null,
      initType: null,
      context: context,
    );
  }
}

class MultiSwiftWidgetContent extends SwiftType {
  final WidgetContentType type;

  MultiSwiftWidgetContent(this.type);

  @override
  String get name =>
      type.swiftGenericParameter; // should already conform to `MultiWidget`

  @override
  String get initType => "() -> Children";

  @override
  List<String> get initAttributes => ["@MultiWidgetBuilder"];

  @override
  String initSetterValue(String source) {
    return "$source()";
  }

  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class MultiDartWidgetContent extends DartType {
  final WidgetContentType type;

  MultiDartWidgetContent(this.type);

  @override
  CodeUnit fromCValue(String source, String destination) {
    return CodeUnit([
      "final ${destination}Value = consumeHandlesList<${type.dartClass()}>($source);",
    ]);
  }

  @override
  String get name => "List<${type.dartClass()}>";
}

class MultiCWidgetContent extends CType {
  final WidgetContentType type;

  MultiCWidgetContent(this.type);

  @override
  String get dartFfiMapping => "handles_list";

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    return CodeUnit([
      "let ${destination}List = HandlesList(handles: $source.reduce(parentKey: parentKey.joined(\"$destination\")).map(\\.handle))",
      "let ${destination}Unmanaged = Unmanaged<HandlesList>.passRetained(${destination}List)",
      "let ${destination}Value = ${destination}Unmanaged.toOpaque()",
    ]);
  }

  @override
  CodeUnit? fromSwiftValueCleanup(String source, String destination) {
    return CodeUnit([
      "${destination}Unmanaged.release()",
    ]);
  }

  @override
  String get name => "widgeteer_handles_list";

  @override
  String get swiftCInteropMapping => "UnsafeRawPointer";

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class SwiftWidgetContent extends SwiftType {
  final WidgetContentType type;

  SwiftWidgetContent(this.type);

  @override
  String get name => type.swiftGenericParameter;

  @override
  String get initType => type.optional
      ? "(() -> ${type.swiftGenericParameter}) = { EmptyWidget() }"
      : "() -> ${type.swiftGenericParameter}";

  @override
  String initSetterValue(String source) {
    return "$source()";
  }

  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class DartWidgetContent extends DartType {
  final WidgetContentType type;

  DartWidgetContent(this.type);

  @override
  CodeUnit fromCValue(String source, String destination) => CodeUnit([
        "final ${destination}Value = $source as ${type.dartClass()};",
      ]);

  @override
  String get name => type.dartClass();
}

class CWidgetContent extends CType {
  final WidgetContentType type;

  CWidgetContent(this.type);

  @override
  String get dartFfiMapping => type.optional ? "Object?" : "Object";

  @override
  CodeUnit fromSwiftValue(String source, String destination) => CodeUnit([
        "let ${destination}Value = $source.reduce(parentKey: parentKey.joined(\"$destination\")).handle",
      ]);

  @override
  String get name => "Dart_Handle";

  @override
  String get swiftCInteropMapping => "Dart_Handle";

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }
}
