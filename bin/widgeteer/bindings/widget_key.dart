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

import '../bindings_generator/code_unit.dart';
import '../bindings_generator/models/type.dart';
import 'string.dart';

class WidgetKeyBinding extends StringBinding {
  @override
  String get name => "WidgetKey";

  @override
  List<BoundType> get types => [WidgetKeyType()];
}

class WidgetKeyType extends StringType {
  @override
  String get name => "WidgetKey";

  @override
  DartType get dartType => DartWidgetKey();
}

class DartWidgetKey extends DartType {
  @override
  String get name => "ValueKey";

  @override
  CodeUnit fromCValue(String source, String destination) => CodeUnit([
        "final ${destination}String = $source.cast<Utf8>().toDartString();",
        "final ${destination}Value = ValueKey(${destination}String);",
      ]);
}
