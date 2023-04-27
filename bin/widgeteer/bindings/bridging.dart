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
import '../bindings_generator/models/binding.dart';
import '../bindings_generator/models/type.dart';

/// Binding for all "bridging" types such as widgets proxies, lists, wrappers...
class BridgingBinding extends Binding {
  @override
  String get name => "Bridging";

  @override
  String get origin => "built in";

  @override
  List<BoundType> get types => [StatelessUserWidgetProxyType()];
}

class StatelessUserWidgetProxyType extends BoundType {
  @override
  CType get cType => CStatelessUserWidgetProxy();

  @override
  DartType get dartType => DartStatelessUserWidgetProxy();

  @override
  String get name => "StatelessUserWidgetProxy";

  @override
  SwiftType get swiftType => SwiftStatelessUserWidgetProxy();
}

class DartStatelessUserWidgetProxy extends DartType {
  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    return CodeUnit(
        content:
            "final ${variableName}Value = StatelessUserWidgetProxy($sourceFfiValue);");
  }

  @override
  String get name => "StatelessUserWidgetProxy";
}

class CStatelessUserWidgetProxy extends CType {
  @override
  String get dartFfiMapping => "stateless_user_widget_proxy";

  @override
  CodeUnit fromSwiftValue(String sourceValue, String variableName) {
    return CodeUnit(
        content:
            "let ${variableName}Value = Unmanaged<StatelessUserWidgetProxy>.passRetained($sourceValue).toOpaque()");
  }

  @override
  String get name => "widgeteer_stateless_user_widget_proxy";

  @override
  String get swiftCInteropMapping => "UnsafeRawPointer";
}

class SwiftStatelessUserWidgetProxy extends SwiftType {
  @override
  String get name => "StatelessUserWidgetProxy";
}
