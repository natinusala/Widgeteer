// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:60
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/widget.dart:113
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:57
import 'package:flutter/material.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:widgeteer/generated/lib_widgeteer.dart';
import 'package:flutter/foundation.dart';
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:88
Object newMaterialAppImpl(Pointer<Char> key, Pointer<Char> title, Object home) {
    // 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:78
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:105
    // 🍞 bin/widgeteer/bindings/widget_key.dart:43
    final keyString = key.cast<Utf8>().toDartString();
    final keyValue = ValueKey(keyString);
    // 🍞 bin/widgeteer/bindings/string.dart:56
    final titleValue = title.cast<Utf8>().toDartString();
    // 🍞 bin/widgeteer/bindings/widget.dart:417
    final homeValue = home as Widget;
    
    return MaterialApp(key: keyValue, titleValue, home: homeValue);
}