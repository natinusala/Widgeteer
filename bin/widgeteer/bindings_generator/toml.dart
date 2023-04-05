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

import 'package:toml/toml.dart';
import 'package:path/path.dart' as p;

import 'widget.dart';

final types = [BindingType("widget", WidgetBinding.fromTOML)];

Future<Binding> parseTomlFile(String path, BindingContext context) async {
  final toml = (await TomlDocument.load(path)).toMap();
  final stem = p.basenameWithoutExtension(path);

  for (BindingType type in types) {
    if (toml.containsKey(type.name)) {
      return type.makeBinding(path, stem, toml, context);
    }
  }

  throw "Unsupported binding type in '$path' - supported types are: ${types.map((e) => e.name)}";
}

class BindingType {
  final String name;
  final Binding Function(String, String, Map, BindingContext) makeBinding;

  BindingType(this.name, this.makeBinding);
}
