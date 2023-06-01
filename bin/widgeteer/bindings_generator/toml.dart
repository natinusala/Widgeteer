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

import 'dart:io';

import '../config.dart';
import 'models/binding.dart';

import 'package:toml/toml.dart';
import 'package:path/path.dart' as p;

import 'models/type.dart';

Future<Binding> parseTomlFile(String path, BindingContext context) async {
  final toml = (await TomlDocument.load(path)).toMap();
  final stem = p.basenameWithoutExtension(path);

  for (BindingType type in tomlTypes) {
    if (toml.containsKey(type.name)) {
      return type.makeBinding(path, stem, toml, context);
    }
  }

  throw "Unsupported binding type in '$path' - supported types are: ${tomlTypes.map((e) => e.name)}";
}

class BindingType {
  final String name;
  final Binding Function(String, String, Map, BindingContext) makeBinding;

  BindingType(this.name, this.makeBinding);
}

/// Parse and gather all bindings from TOML files.
/// All returned bindings will be bound to the same [BindingContext].
Future<List<ParsedBinding>> parseBindings(String workingDirectory) async {
  final context = BindingContext();
  List<ParsedBinding> bindings = [];

  // Register all built-in types
  bindings.addAll(builtinBindings.map((e) => ParsedBinding(e, "Builtin")));

  final bindingsRoot = Directory(p.join(workingDirectory, "Bindings"));

  await for (final entity in bindingsRoot.list(recursive: true)) {
    if (entity is! File) {
      continue;
    }

    if (!entity.path.endsWith(".toml")) {
      throw "Unsupported file type '${entity.path}'";
    }

    final binding = await parseTomlFile(entity.path, context);
    final relativePath = File(p.relative(entity.path)).parent.path;

    bindings.add(ParsedBinding(binding, relativePath));
  }

  List<BoundType> types = [];
  for (final binding in bindings) {
    for (final type in binding.binding.types) {
      if (types.any((element) => element.name == type.name)) {
        throw "Duplicate type '${type.name}'";
      }

      types.add(type);
    }
  }

  context.types = types;
  return bindings;
}

class ParsedBinding {
  final Binding binding;

  /// Path to the binding relative to working directory.
  /// Used so that generated code follows the same hierarchy as TOML files.
  final String relativePath;

  ParsedBinding(this.binding, this.relativePath);

  /// Path to the "Dart body" file for this binding.
  /// The file is not guaranteed to exist, especially if there is no Dart body.
  /// Used when some generated Dart files need to be imported for
  /// other bindings to work.
  String dartBodyPath(String dartRoot) {
    return p.join(dartRoot, relativePath, "${binding.name}.dart");
  }
}
