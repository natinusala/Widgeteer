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

import '../bindings_generator/code_unit.dart';
import '../bindings_generator/models/binding.dart';
import 'package:path/path.dart' as p;

import '../bindings_generator/models/type.dart';

/// Enums are bound using an integer (the value index inside the TOML binding).
/// Optionals use `-1` to mark a `nil` value.
class EnumBinding extends Binding {
  final BindingContext context;

  final String enumName;
  final String enumLocation;
  final String tomlPath;
  final String? prefix;
  final List<String> cases;

  EnumBinding({
    required this.context,
    required this.enumLocation,
    required this.enumName,
    required this.cases,
    required this.tomlPath,
    required this.prefix,
  });

  factory EnumBinding.fromTOML(
      String tomlPath, String fileStem, Map toml, BindingContext context) {
    return EnumBinding(
      context: context,
      enumLocation: toml["enum"]["location"],
      enumName: fileStem,
      cases: (toml["enum"]["cases"] as List).cast<String>(),
      prefix: toml["enum"]["prefix"],
      tomlPath: tomlPath,
    );
  }

  @override
  String get name => enumName;

  @override
  String get origin => p.relative(tomlPath);

  @override
  List<BoundType> get types => [EnumType(this), OptionalEnumType(this)];

  @override
  CodeUnit get swiftBody {
    // Swift enum
    final swiftEnum = CodeUnit.empty();

    swiftEnum.enterScope("public enum $enumName: Int {");

    cases
        .mapIndexed(
            (index, element) => swiftEnum.appendLine("case $element = $index"))
        .toList();

    swiftEnum.exitScope("}");

    return swiftEnum;
  }

  /// The Dart "prefix" to access the enum cases.
  /// Either the enum name itself or another enum if the binding is an alias
  /// or a class if the type isn't really an enum.
  /// The name "prefix" is intentionnaly vague and nondescript to allow
  /// using any Dart expression.
  String get enumPrefix => prefix ?? name;
}

class EnumType extends BoundType {
  final EnumBinding binding;

  EnumType(this.binding);

  @override
  CType get cType => CEnum(this);

  @override
  DartType get dartType => DartEnum(this);

  @override
  String get name => binding.name;

  @override
  SwiftType get swiftType => SwiftEnum(this);
}

class CEnum extends CType {
  final EnumType type;

  CEnum(this.type);

  @override
  String get dartFfiMapping => "int";

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    return CodeUnit([
      "let ${destination}Value = $source.rawValue",
    ]);
  }

  @override
  String get name => "int";

  @override
  String get swiftCInteropMapping => "Int";

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class DartEnum extends DartType {
  final EnumType type;

  DartEnum(this.type);

  @override
  CodeUnit fromCValue(String source, String destination) {
    final unit = CodeUnit.empty();

    unit.appendLine("late final ${type.dartType.name} ${destination}Value;");
    unit.enterScope("switch ($source) {");

    type.binding.cases
        .mapIndexed((index, element) => unit.appendLine(
            "case $index: ${destination}Value = ${type.binding.enumPrefix}.$element; break;"))
        .toList();
    unit.appendLine(
        "default: throw \"Received invalid index '\$$source' for value of enum '${type.name}'\";");

    unit.exitScope("}");

    return unit;
  }

  @override
  String get name => type.name;
}

class SwiftEnum extends SwiftType {
  final EnumType type;

  SwiftEnum(this.type);

  @override
  String get name => type.name;

  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class OptionalEnumType extends BoundType {
  final EnumBinding binding;

  OptionalEnumType(this.binding);

  @override
  CType get cType => OptionalCEnum(this);

  @override
  DartType get dartType => OptionalDartEnum(this);

  @override
  String get name => "${binding.name}?";

  @override
  SwiftType get swiftType => OptionalSwiftEnum(this);
}

class OptionalDartEnum extends DartType {
  final OptionalEnumType type;

  OptionalDartEnum(this.type);

  @override
  CodeUnit fromCValue(String source, String destination) {
    final unit = CodeUnit.empty();

    unit.appendLine("late final $name ${destination}Value;");
    unit.enterScope("switch ($source) {");

    unit.appendLine("case -1: ${destination}Value = null; break;");

    type.binding.cases.mapIndexed((index, element) {
      unit.appendLine(
          "case $index: ${destination}Value = ${type.binding.enumPrefix}.$element; break;");
    }).toList();
    unit.appendLine(
        "default: throw \"Received invalid index '\$$source' for value of enum '${type.name}'\";");

    unit.exitScope("}");

    return unit;
  }

  @override
  String get name => type.name;
}

class OptionalCEnum extends CType {
  final OptionalEnumType type;

  OptionalCEnum(this.type);

  @override
  String get dartFfiMapping => "int";

  @override
  CodeUnit fromSwiftValue(String source, String destination) {
    return CodeUnit([
      "let ${destination}Value = $source?.rawValue ?? -1",
    ]);
  }

  @override
  String get name => "int";

  @override
  String get swiftCInteropMapping => "Int";

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class OptionalSwiftEnum extends SwiftType {
  final OptionalEnumType type;

  OptionalSwiftEnum(this.type);

  @override
  String get name => type.name;

  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }
}
