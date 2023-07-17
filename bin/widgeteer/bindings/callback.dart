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
    final body = CodeUnit.empty();

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
    final proxy = CodeUnit.empty();

    proxy.enterScope("class $proxyName {");
    proxy.appendLine("let closure: $name");
    proxy.appendEmptyLine();

    proxy.enterScope("init(_ closure: @escaping $name) {");

    proxy.appendLine("self.closure = closure");

    proxy.exitScope("}");

    proxy.exitScope("}");

    return proxy;
  }

  /// Swift functions to call the proxy, exposed to C.
  CodeUnit get swiftCFunctions {
    final functions = CodeUnit.empty();

    // Call
    functions.appendLine("@_cdecl(\"$callCFunction\")");
    functions.enterScope(
        "public func _${proxyName.camelCase}Call(_ proxy: UnsafeRawPointer) {");

    functions.appendLine(
        "let proxy = Unmanaged<$proxyName>.fromOpaque(proxy).takeUnretainedValue()");
    functions.appendLine("proxy.closure()");

    functions.exitScope("}");
    functions.appendEmptyLine();

    // Release
    functions.appendLine("@_cdecl(\"$releaseCFunction\")");
    functions.enterScope(
        "public func _${proxyName.camelCase}Release(_ proxy: UnsafeRawPointer) {");

    functions.appendLine("Unmanaged<$proxyName>.fromOpaque(proxy).release()");

    functions.exitScope("}");

    return functions;
  }

  @override
  CodeUnit get dartBody {
    final body = CodeUnit.empty();

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
    final proxy = CodeUnit.empty();

    proxy.enterScope("class $proxyName implements Finalizable {");

    // Finalizer
    proxy.appendLine(
        "static final _finalizer = NativeFinalizer(libWidgeteer.addresses.$releaseDartBinding);");
    proxy.appendEmptyLine();

    // C proxy handle
    proxy.appendLine("final $snakeProxyName proxy;");
    proxy.appendEmptyLine();

    // Constructor
    proxy.enterScope("$proxyName(this.proxy) {");
    proxy.appendLine("_finalizer.attach(this, proxy, detach: this);");
    proxy.exitScope("}");

    // call method
    proxy.enterScope("void call() {");
    proxy.appendLine("libWidgeteer.enter_scope();");
    proxy.appendLine("libWidgeteer.$callDartBinding(proxy);");
    proxy.appendLine("libWidgeteer.exit_scope();");
    proxy.exitScope("}");

    proxy.exitScope("}");

    return proxy;
  }

  @override
  CodeUnit get cDeclarations {
    final headers = CodeUnit.empty();

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
  CodeUnit fromSwiftValue(String source, String destination) {
    final transformer = CodeUnit.empty();

    transformer.appendLine("let ${destination}Value: UnsafeMutableRawPointer?");
    transformer.enterScope("if let ${destination}Closure = $source {");
    transformer.appendLine(
        "${destination}Value = Unmanaged<${type.binding.proxyName}>.passRetained(${type.binding.proxyName}(${destination}Closure)).toOpaque()");
    transformer.exitAndEnterScope("} else {");
    transformer.appendLine("${destination}Value = nil");
    transformer.exitScope("}");

    return transformer;
  }

  @override
  String get name => "void*";

  @override
  String get swiftCInteropMapping => "UnsafeRawPointer?";

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class OptionalDartCallback extends DartType {
  final OptionalCallbackType type;

  OptionalDartCallback(this.type);

  @override
  CodeUnit fromCValue(String source, String destination) {
    final transformer = CodeUnit.empty();

    transformer.appendLine("late ${type.name} ${destination}Value;");
    transformer.enterScope("if ($source == nullptr) {");
    transformer.appendLine("${destination}Value = null;");
    transformer.exitAndEnterScope("} else {");
    transformer.appendLines([
      "final ${destination}Proxy = ${type.binding.proxyName}($source);",
      "${destination}Value = () { return ${destination}Proxy.call(); };",
    ]);
    transformer.exitScope("}");

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

  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }
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
  CodeUnit fromSwiftValue(String source, String destination) {
    return CodeUnit([
      "let ${destination}Value = Unmanaged<${type.binding.proxyName}>.passRetained(${type.binding.proxyName}($source)).toOpaque()",
    ]);
  }

  @override
  String get name => "void*";

  @override
  String get swiftCInteropMapping => "UnsafeRawPointer";

  @override
  CodeUnit fromDartValue(String source, String destination) {
    throw UnimplementedError();
  }
}

class DartCallback extends DartType {
  final CallbackType type;

  DartCallback(this.type);

  @override
  CodeUnit fromCValue(String source, String destination) {
    // The Dart proxy holds the Swift proxy (through GC and native finalizer)
    // and the Dart closure holds the Dart proxy through capture for as long as Flutter
    // deems it necessary
    return CodeUnit([
      "final ${destination}Proxy = ${type.binding.proxyName}($source);",
      "final ${destination}Value = () { return ${destination}Proxy.call(); };",
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

  @override
  CodeUnit fromCValue(String source, String destination) {
    throw UnimplementedError();
  }
}
