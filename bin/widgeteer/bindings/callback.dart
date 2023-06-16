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
import 'package:recase/recase.dart';

import '../bindings_generator/code_unit.dart';
import '../bindings_generator/models/binding.dart';
import '../bindings_generator/models/type.dart';

/// A binding for an UI callback (to execute Swift code from UI events).
class CallbackBinding extends Binding {
  final String callbackName;
  final String tomlPath;

  CallbackBinding({
    required this.callbackName,
    required this.tomlPath,
  });

  factory CallbackBinding.fromTOML(
      String tomlPath, String fileStem, Map toml, BindingContext context) {
    return CallbackBinding(
      callbackName: fileStem,
      tomlPath: tomlPath,
    );
  }

  /// Name of the Swift proxy class holding the closure, that
  /// Dart can call through a C function.
  String get proxyName => "${name}Proxy";

  String get snakeProxyName => proxyName.snakeCase;
  String get cProxyType => "widgeteer_$snakeProxyName";

  String get releaseCFunction => "widgeteer_$releaseDartBinding";
  String get callCFunction => "widgeteer_$callDartBinding";

  String get releaseDartBinding => "${snakeProxyName}_release";
  String get callDartBinding => "${snakeProxyName}_call";

  @override
  CodeUnit? get swiftBody {
    final body = CodeUnit();

    // typealias
    body.appendLine("public typealias $name = () -> Void");
    body.appendEmptyLine();

    // Proxy
    body.appendUnit(swiftProxy);
    body.appendEmptyLine();

    // C functions
    body.appendUnit(swiftCFunctions);

    return body;
  }

  /// Swift proxy class that holds the closure.
  CodeUnit get swiftProxy {
    final proxy = CodeUnit();

    proxy.appendLine("class $proxyName {");
    proxy.appendLine("let closure: $name", indentedBy: 4);
    proxy.appendEmptyLine();

    proxy.appendLine("init(_ closure: @escaping $name) {", indentedBy: 4);

    proxy.appendLine("self.closure = closure", indentedBy: 8);

    proxy.appendLine("}", indentedBy: 4);

    proxy.appendLine("}");

    return proxy;
  }

  /// Swift functions to call the proxy, exposed to C.
  CodeUnit get swiftCFunctions {
    final functions = CodeUnit();

    // Call
    functions.appendLine("@_cdecl(\"$callCFunction\")");
    functions.appendLine(
        "public func _${proxyName.camelCase}Call(_ proxy: UnsafeRawPointer) {");

    functions.appendLine(
        "let proxy = Unmanaged<$proxyName>.fromOpaque(proxy).takeUnretainedValue()",
        indentedBy: 4);
    functions.appendLine("proxy.closure()", indentedBy: 4);

    functions.appendLine("}");
    functions.appendEmptyLine();

    // Release
    functions.appendLine("@_cdecl(\"$releaseCFunction\")");
    functions.appendLine(
        "public func _${proxyName.camelCase}Release(_ proxy: UnsafeRawPointer) {");

    functions.appendLine("Unmanaged<$proxyName>.fromOpaque(proxy).release()",
        indentedBy: 4);

    functions.appendLine("}");

    return functions;
  }

  @override
  CodeUnit get dartBody {
    final body = CodeUnit();

    body.appendLines([
      "import 'dart:ffi';",
      "import 'package:widgeteer/dylib.dart';",
      "import 'package:widgeteer/generated/lib_widgeteer.dart';",
    ]);
    body.appendEmptyLine();

    // Proxy
    body.appendUnit(dartProxy);

    return body;
  }

  /// Dart class holding the Swift proxy.
  CodeUnit get dartProxy {
    final proxy = CodeUnit();

    proxy.appendLine("class $proxyName implements Finalizable {");

    // Finalizer
    proxy.appendLine(
        "static final _finalizer = NativeFinalizer(libWidgeteer.addresses.$releaseDartBinding);",
        indentedBy: 4);
    proxy.appendEmptyLine();

    // C proxy handle
    proxy.appendLine("final $snakeProxyName proxy;", indentedBy: 4);
    proxy.appendEmptyLine();

    // Constructor
    proxy.appendLine("$proxyName(this.proxy) {", indentedBy: 4);
    proxy.appendLine("_finalizer.attach(this, proxy, detach: this);",
        indentedBy: 8);
    proxy.appendLine("}", indentedBy: 4);

    // call method
    proxy.appendLine("void call() {", indentedBy: 4);
    proxy.appendLine("libWidgeteer.enter_scope();", indentedBy: 8);
    proxy.appendLine("libWidgeteer.$callDartBinding(proxy);", indentedBy: 8);
    proxy.appendLine("libWidgeteer.exit_scope();", indentedBy: 8);
    proxy.appendLine("}", indentedBy: 4);

    proxy.appendLine("}");

    return proxy;
  }

  @override
  CodeUnit get cDeclarations {
    final headers = CodeUnit();

    // type alias
    headers.appendLine("typedef void* $cProxyType;");

    // Functions
    headers.appendLine("void $releaseCFunction($cProxyType proxy);");
    headers.appendLine("void $callCFunction($cProxyType proxy);");

    return headers;
  }

  @override
  String get name => callbackName;

  @override
  String get origin => p.relative(tomlPath);

  @override
  List<BoundType> get types => [CallbackType(this), OptionalCallbackType(this)];

  @override
  bool get importBody => true;
}

class OptionalCallbackType extends BoundType {
  final CallbackBinding binding;

  OptionalCallbackType(this.binding);

  @override
  String get name => "${binding.name}?";

  @override
  CType get cType => OptionalCCallback(this);

  @override
  DartType get dartType => OptionalDartCallback(this);

  @override
  SwiftType get swiftType => OptionalSwiftCallback(this);
}

class OptionalCCallback extends CType {
  final OptionalCallbackType type;

  OptionalCCallback(this.type);

  @override
  String get dartFfiMapping => "Pointer<Void>"; // opaque proxy handle

  @override
  CodeUnit fromSwiftValue(String sourceValue, String variableName) {
    final transformer = CodeUnit();

    transformer
        .appendLine("let ${variableName}Value: UnsafeMutableRawPointer?");
    transformer.appendLine("if let ${variableName}Closure = $sourceValue {");
    transformer.appendLine(
        "${variableName}Value = Unmanaged<${type.binding.proxyName}>.passRetained(${type.binding.proxyName}(${variableName}Closure)).toOpaque()",
        indentedBy: 4);
    transformer.appendLine("} else {");
    transformer.appendLine("${variableName}Value = nil", indentedBy: 4);
    transformer.appendLine("}");

    return transformer;
  }

  @override
  String get name => "void*";

  @override
  String get swiftCInteropMapping => "UnsafeRawPointer?";
}

class OptionalDartCallback extends DartType {
  final OptionalCallbackType type;

  OptionalDartCallback(this.type);

  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    final transformer = CodeUnit();

    transformer.appendLine("late ${type.name} ${variableName}Value;");
    transformer.appendLine("if ($sourceFfiValue == nullptr) {");
    transformer.appendLine("${variableName}Value = null;", indentedBy: 4);
    transformer.appendLine("} else {");
    transformer.appendLines([
      "final ${variableName}Proxy = ${type.binding.proxyName}($sourceFfiValue);",
      "${variableName}Value = () { return ${variableName}Proxy.call(); };",
    ], indentedBy: 4);
    transformer.appendLine("}");

    return transformer;
  }

  @override
  String get name => type.name;
}

class OptionalSwiftCallback extends SwiftType {
  final OptionalCallbackType type;

  OptionalSwiftCallback(this.type);

  @override
  String get name => type.name;

  @override
  String get initType =>
      "$name = nil"; // closure is already escaping in optional type argument
}

class CallbackType extends BoundType {
  final CallbackBinding binding;

  CallbackType(this.binding);

  @override
  String get name => binding.name;

  @override
  CType get cType => CCallback(this);

  @override
  DartType get dartType => DartCallback(this);

  @override
  SwiftType get swiftType => SwiftCallback(this);
}

class CCallback extends CType {
  final CallbackType type;

  CCallback(this.type);

  @override
  String get dartFfiMapping => "Pointer<Void>"; // opaque proxy handle

  @override
  CodeUnit fromSwiftValue(String sourceValue, String variableName) {
    return CodeUnit(
        content:
            "let ${variableName}Value = Unmanaged<${type.binding.proxyName}>.passRetained(${type.binding.proxyName}($sourceValue)).toOpaque()");
  }

  @override
  String get name => "void*";

  @override
  String get swiftCInteropMapping => "UnsafeRawPointer";
}

class DartCallback extends DartType {
  final CallbackType type;

  DartCallback(this.type);

  @override
  CodeUnit fromCValue(String sourceFfiValue, String variableName) {
    // The Dart proxy holds the Swift proxy (through GC and native finalizer)
    // and the Dart closure holds the Dart proxy through capture for as long as Flutter
    // deems it necessary
    return CodeUnit(initialLines: [
      "final ${variableName}Proxy = ${type.binding.proxyName}($sourceFfiValue);",
      "final ${variableName}Value = () { return ${variableName}Proxy.call(); };",
    ]);
  }

  @override
  String get name => type.name;
}

class SwiftCallback extends SwiftType {
  final CallbackType type;

  SwiftCallback(this.type);

  @override
  String get name => type.name;

  @override
  String get initType => "@escaping $name";
}