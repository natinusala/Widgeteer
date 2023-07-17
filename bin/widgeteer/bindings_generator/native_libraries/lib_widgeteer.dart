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

import 'package:ffigen/src/config_provider/config.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

import '../../config.dart';
import '../models/native_library.dart';

/// The Swift Widgeteer runtime library itself, including bootstrapping functions.
class LibWidgeteer extends NativeLibrary {
  @override
  Config config(String workingDirectory) {
    Map<String, dynamic> map = {
      "output": output(workingDirectory),
      "name": name,
      "description": "Widgeteer runtime library",
      "headers": {
        "entry-points": [
          p.join(workingDirectory, generatedIncludesRoot, "outlets.h"),
          p.join(workingDirectory, generatedIncludesRoot, "declarations.h"),
          p.join(workingDirectory, includesRoot, "libwidgeteer.h"),
        ],
        "include-directives": [
          "**outlets.h",
          "**declarations.h",
          "**libwidgeteer.h",
        ],
      },
      "functions": {
        "rename": {"widgeteer_(.*)": "\$1"},
        "symbol-address": {
          "include": [
            "widgeteer_(.*)_release",
          ]
        }
      },
      "typedefs": {
        "rename": {"widgeteer_(.*)": "\$1"}
      }
    };

    return Config.fromYaml(YamlMap.wrap(map));
  }

  @override
  String output(String workingDirectory) {
    return p.join(workingDirectory, generatedDartRoot, "lib_widgeteer.dart");
  }

  @override
  String get name => "LibWidgeteer";
}
