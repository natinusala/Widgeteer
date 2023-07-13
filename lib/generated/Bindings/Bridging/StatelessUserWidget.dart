// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:77
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:45
import 'package:flutter/widgets.dart';
import 'package:widgeteer/generated/Bindings/Callback/VoidCallback.dart';
// 🍞 bin/widgeteer/bindings/widget.dart:143
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:59
import 'package:widgeteer/widgets/stateless_user_widget.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:widgeteer/generated/lib_widgeteer.dart';
import 'package:widgeteer/swift.dart';
import 'package:flutter/foundation.dart';
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:91
Object newStatelessUserWidgetImpl(Pointer<Char> key, stateless_user_widget_proxy proxy, Pointer<Char> swiftWidgetName) {
    // 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:81
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:143
    // 🍞 bin/widgeteer/bindings/widget_key.dart:43
    final keyString = key.cast<Utf8>().toDartString();
    final keyValue = ValueKey(keyString);
    // 🍞 bin/widgeteer/bindings/bridging.dart:52
    final proxyValue = StatelessUserWidgetProxy(proxy);
    // 🍞 bin/widgeteer/bindings/string.dart:61
    final swiftWidgetNameValue = swiftWidgetName.cast<Utf8>().toDartString();
    
    return StatelessUserWidget(key: keyValue, proxy: proxyValue, swiftWidgetNameValue);
}