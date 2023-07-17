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

/// Binding for all Flutter "bridging" types such as widgets proxies, built in types...
class FlutterBridgingBinding extends Binding {
  @override
  String get name => "Bridging";

  @override
  String get origin => "built in";

  @override
  List<BoundType> get types => [
        StatelessUserWidgetProxyType(),
        StatefulUserWidgetProxyType(),
        BuildContextType(),
      ];
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
    return CodeUnit([
      "final ${variableName}Value = StatelessUserWidgetProxy($sourceFfiValue);",
    ]);
  }

  @override
  String get name => "StatelessUserWidgetProxy";
}

class CStatelessUserWidgetProxy extends CType {
  @override
  String get dartFfiMapping => "stateless_user_widget_proxy";

  @override
  CodeUnit fromSwiftValue(String sourceValue, String variableName) {
    return CodeUnit([
      "let ${variableName}Value = Unmanaged<StatelessUserWidgetProxy>.passRetained($sourceValue).toOpaque()",
    ]);
  }

  @override
  String get name => "widgeteer_stateless_user_widget_proxy";

  @override
  String get swiftCInteropMapping => "UnsafeRawPointer";

  @override
  CodeUnit fromDartValue(String sourceValue, String variableName) {
    throw UnimplementedError();
  }
}

class SwiftStatelessUserWidgetProxy extends SwiftType {
  @override
  String get name => "StatelessUserWidgetProxy";

  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    throw UnimplementedError();
  }
}

class StatefulUserWidgetProxyType extends BoundType {
  @override
  CType get cType => CStatefulUserWidgetProxy();

  @override
  DartType get dartType => DartStatefulUserWidgetProxy();

  @override
  String get name => "StatefulUserWidgetProxy";

  @override
  SwiftType get swiftType => SwiftStatefulUserWidgetProxy();
}

class DartStatefulUserWidgetProxy extends DartType {
  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    return CodeUnit([
      "final ${variableName}Value = StatefulUserWidgetProxy($sourceFfiValue);",
    ]);
  }

  @override
  String get name => "StatefulUserWidgetProxy";
}

class CStatefulUserWidgetProxy extends CType {
  @override
  String get dartFfiMapping => "stateful_user_widget_proxy";

  @override
  CodeUnit fromSwiftValue(String sourceValue, String variableName) {
    return CodeUnit([
      "let ${variableName}Value = Unmanaged<StatefulUserWidgetProxy>.passRetained($sourceValue).toOpaque()",
    ]);
  }

  @override
  String get name => "widgeteer_stateful_user_widget_proxy";

  @override
  String get swiftCInteropMapping => "UnsafeRawPointer";

  @override
  CodeUnit fromDartValue(String sourceValue, String variableName) {
    throw UnimplementedError();
  }
}

class SwiftStatefulUserWidgetProxy extends SwiftType {
  @override
  String get name => "StatefulUserWidgetProxy";

  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    throw UnimplementedError();
  }
}

class BuildContextType extends BoundType {
  @override
  CType get cType => CBuildContext();

  @override
  DartType get dartType => DartBuildContext();

  @override
  String get name => "BuildContext";

  @override
  SwiftType get swiftType => SwiftBuildContext();
}

class CBuildContext extends CType {
  @override
  String get dartFfiMapping => "Object";

  @override
  CodeUnit fromSwiftValue(String sourceValue, String variableName) {
    // `BuildContext` is an alias to `Dart_Handle` in Swift
    return CodeUnit([
      "let ${variableName}Value = $sourceValue",
    ]);
  }

  @override
  String get name => "Dart_Handle";

  @override
  String get swiftCInteropMapping => "Dart_Handle";

  @override
  CodeUnit fromDartValue(String sourceValue, String variableName) {
    throw UnimplementedError();
  }
}

class DartBuildContext extends DartType {
  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    return CodeUnit([
      "final ${variableName}Value = $sourceFfiValue as BuildContext;",
    ]);
  }

  @override
  String get name => "BuildContext";
}

class SwiftBuildContext extends SwiftType {
  @override
  String get name => "BuildContext";

  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    throw UnimplementedError();
  }
}
