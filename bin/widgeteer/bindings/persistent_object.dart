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

import 'package:path/path.dart' as p;

import '../bindings_generator/code_unit.dart';
import '../bindings_generator/models/binding.dart';
import '../bindings_generator/models/dart_function.dart';
import '../bindings_generator/models/outlet.dart';
import '../bindings_generator/models/parameter.dart';
import '../bindings_generator/models/type.dart';

/// A binding to any Dart object to be persisted in Swift.
/// Called "class" in bindings for simplicity but can be used on any Dart type
/// that's an object and supports method calls.
///
/// On bridging, the handle is turned into a "persistent" handle and given to a Swift class instance.
/// The persistent handle is then freed when the Swift instance is collected by ARC.
class PersistentObjectBinding extends Binding {
  final BindingContext context;

  final String className;
  final String classLocation;
  final String tomlPath;

  /// Parameters are set in the generated initializer but are not
  /// accessible as properties. Use [properties] for that purpose instead.
  final ParametersList parameters;

  /// Properties are set in the generated initializer and can be
  /// get and set in the class as well.
  final ParametersList properties;

  PersistentObjectBinding({
    required this.context,
    required this.className,
    required this.classLocation,
    required this.tomlPath,
    required this.parameters,
    required this.properties,
  });

  factory PersistentObjectBinding.fromTOML(
      String tomlPath, String fileStem, Map toml, BindingContext context) {
    return PersistentObjectBinding(
      context: context,
      className: fileStem,
      classLocation: toml["class"]["location"],
      tomlPath: tomlPath,
      parameters: ParametersList.fromTOML(toml["parameter"] ?? [], context),
      properties: ParametersList.fromTOML(toml["property"] ?? [], context),
    );
  }

  @override
  String get name => className;

  @override
  String get origin => p.relative(tomlPath);

  @override
  List<BoundType> get types =>
      [PersistentObjectType(this), OptionalPersistentObjectType(this)];

  @override
  List<Outlet> get outlets =>
      [newFunction.callingOutlet] +
      properties.map((element) => element.getterOutlet(name)).toList();

  ParametersList get initializerParams => parameters + properties;

  /// Function to create a new instance of the object.
  late DartFunction newFunction = DartFunction(
    context: context,
    outletName: "new$className",
    location: classLocation,
    // constructor is just a function that has the widget name
    name: name,
    parameters: initializerParams,
    returnType: 'Object',
  );

  /// The Swift class initializer.
  CodeUnit get swiftInitializer {
    final initializer = CodeUnit.empty();

    initializer
        .enterScope("public init(${initializerParams.swiftInitParameters}) {");
    initializer.appendUnit(newFunction.callingOutlet.swiftCall("localHandle"));
    initializer
        .appendLine("self.handle = Dart_NewPersistentHandle_DL(localHandle)!");
    initializer.exitScope("}");

    initializer.appendEmptyLine();
    initializer
        .enterScope("public init(persisting localHandle: Dart_Handle) {");

    initializer
        .appendLine("self.handle = Dart_NewPersistentHandle_DL(localHandle)!");

    initializer.exitScope("}");

    return initializer;
  }

  CodeUnit get swiftDeinitializer {
    final deinit = CodeUnit.empty();
    deinit.enterScope("deinit {");
    deinit.enterScope("Flutter_Schedule(scoped: false) { [handle] _ in");
    deinit.appendLine("Dart_DeletePersistentHandle_DL(handle)");
    deinit.exitScope("}");
    deinit.exitScope("}");
    return deinit;
  }

  /// The Swift class holding the persistent handle to the object.
  CodeUnit get swiftClass {
    final swiftClass = CodeUnit.empty();

    swiftClass.enterScope("public class $className {");

    swiftClass.appendLine("/// Persistent handle to the Dart object.");
    swiftClass.appendLine("let handle: Dart_PersistentHandle");
    swiftClass.appendEmptyLine();

    swiftClass.appendUnit(swiftInitializer);

    swiftClass.appendEmptyLine();
    swiftClass.appendUnit(swiftDeinitializer);

    // Properties
    swiftClass.appendUnit(swiftProperties);

    swiftClass.exitScope("}");

    return swiftClass;
  }

  /// Properties bridged from the Dart class.
  CodeUnit get swiftProperties {
    final getters = CodeUnit.empty();

    for (final property in properties) {
      final resolvedType = context.resolveType(property.type);

      getters.enterScope(
          "public var ${property.name}: ${resolvedType.swiftType.name} {");

      getters
          .enterScope("return Flutter_BlockingSchedule(scoped: false) { _ in");

      getters.appendLine(
          "let localHandle = ${property.getterOutlet(name).swiftFunctionName}(self.handle)");
      getters
          .appendUnit(resolvedType.swiftType.fromCValue("localHandle", name));
      getters.appendLine("return ${name}Value");

      getters.exitScope("}");

      getters.exitScope("}");
      getters.appendEmptyLine();
    }

    return getters;
  }

  @override
  CodeUnit get swiftBody {
    final body = CodeUnit.empty();

    body.appendLine("import DartApiDl");
    body.appendEmptyLine();

    body.appendUnit(swiftClass);

    return body;
  }

  @override
  CodeUnit get dartBody {
    final body = CodeUnit.empty();

    // new function outlet implementation
    body.appendUnit(newFunction.outletImplementation(true));
    body.appendEmptyLine();

    // properties getters implementations
    for (final property in properties) {
      body.appendUnit(getterOutletImplementation(property));
      body.appendEmptyLine();
    }

    return body;
  }

  CodeUnit getterOutletImplementation(Parameter property) {
    final implementation = CodeUnit.empty();

    final resolvedType = context.resolveType(property.type);
    final outlet = property.getterOutlet(name);

    implementation.enterScope(
        "${resolvedType.cType.dartFfiMapping} ${outlet.implementationName}(Object target) {");
    implementation.appendLine("final typedTarget = target as $name;");
    implementation.appendLine("final value = typedTarget.${property.name};");

    implementation
        .appendUnit(resolvedType.cType.fromDartValue("value", "converted"));

    implementation.appendLine("return convertedValue;");

    implementation.exitScope("}");

    return implementation;
  }
}

class PersistentObjectType extends BoundType {
  final PersistentObjectBinding binding;

  PersistentObjectType(this.binding);

  @override
  CType get cType => CPersistentObject(this);

  @override
  DartType get dartType => DartPersistentObject(this);

  @override
  String get name => binding.className;

  @override
  SwiftType get swiftType => SwiftPersistentObject(this);
}

class SwiftPersistentObject extends SwiftType {
  final PersistentObjectType type;

  SwiftPersistentObject(this.type);

  @override
  String get name => type.name;

  @override
  CodeUnit fromCValue(String source, String destination) {
    return CodeUnit([
      "let ${destination}Value = $name(persisting: $source)",
    ]);
  }
}

class DartPersistentObject extends DartType {
  final PersistentObjectType type;

  DartPersistentObject(this.type);

  @override
  CodeUnit fromCValue(String source, String destination) {
    return CodeUnit([
      "final ${destination}Value = $source as $name;",
    ]);
  }

  @override
  String get name => type.name;
}

class CPersistentObject extends CType {
  final PersistentObjectType type;

  CPersistentObject(this.type);

  @override
  String get dartFfiMapping => "Object";

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    return CodeUnit([
      "let ${destination}Value = $source.handle",
    ]);
  }

  @override
  String get name => "Dart_PersistentHandle";

  @override
  String get swiftCInteropMapping => "Dart_PersistentHandle";

  @override
  CodeUnit fromDartValue(String source, String destination) {
    return CodeUnit([
      "final Object ${destination}Value = $source;",
    ]); // Object downcast is enough
  }
}

class OptionalPersistentObjectType extends BoundType {
  final PersistentObjectBinding binding;

  OptionalPersistentObjectType(this.binding);

  @override
  CType get cType => COptionalPersistentObject(this);

  @override
  DartType get dartType => DartOptionalPersistentObject(this);

  @override
  String get name => "${binding.className}?";

  @override
  SwiftType get swiftType => SwiftOptionalPersistentObject(this);
}

class SwiftOptionalPersistentObject extends SwiftType {
  final OptionalPersistentObjectType type;

  SwiftOptionalPersistentObject(this.type);

  @override
  String get name => type.name;

  @override
  CodeUnit fromCValue(String source, String destination) {
    return CodeUnit([
      "let ${destination}Value: $name = $source == Dart_Null ? nil : ${type.binding.className}(persisting: $source)",
    ]);
  }
}

class COptionalPersistentObject extends CType {
  final OptionalPersistentObjectType type;

  COptionalPersistentObject(this.type);

  @override
  String get dartFfiMapping => "Object?";

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    return CodeUnit([
      "let ${destination}Value = $source?.handle ?? Dart_Null",
    ]);
  }

  @override
  String get name => "Dart_PersistentHandle";

  @override
  String get swiftCInteropMapping => "Dart_PersistentHandle";

  @override
  CodeUnit fromDartValue(String source, String destination) {
    return CodeUnit([
      "final Object? ${destination}Value = $source;",
    ]); // Object? downcast is enough
  }
}

class DartOptionalPersistentObject extends DartType {
  final OptionalPersistentObjectType type;

  DartOptionalPersistentObject(this.type);

  @override
  CodeUnit fromCValue(String source, String destination) {
    // FFI gives us an `Object?` so we just need to cast it
    return CodeUnit([
      "final ${destination}Value = $source as $name;",
    ]);
  }

  @override
  String get name => type.name;
}
