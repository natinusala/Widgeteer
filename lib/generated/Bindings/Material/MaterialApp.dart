// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:77
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:45
import 'package:widgeteer/generated/Bindings/Callback/VoidCallback.dart';
// 🍞 bin/widgeteer/bindings/widget.dart:139
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:57
import 'package:flutter/material.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:widgeteer/generated/lib_widgeteer.dart';
import 'package:widgeteer/swift.dart';
import 'package:flutter/foundation.dart';
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:89
Object newMaterialAppImpl(Pointer<Char> key, Pointer<Char> title, Object? theme, Object home) {
    // 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:79
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:113
    // 🍞 bin/widgeteer/bindings/widget_key.dart:43
    final keyString = key.cast<Utf8>().toDartString();
    final keyValue = ValueKey(keyString);
    // 🍞 bin/widgeteer/bindings/string.dart:56
    final titleValue = title.cast<Utf8>().toDartString();
    // 🍞 bin/widgeteer/bindings/persistent_object.dart:293
    final themeValue = theme as ThemeData?;
    // 🍞 bin/widgeteer/bindings/widget.dart:606
    final homeValue = home as Widget;
    
    return MaterialApp(key: keyValue, title: titleValue, theme: themeValue, home: homeValue);
}