// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:60
// GENERATED BY `widgeteer bindings generate` - DO NOT EDIT
// 🍞 bin/widgeteer/bindings/widget.dart:113
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:57
import 'package:flutter/widgets.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:87
Object newTextImpl(Pointer<Char> key, Pointer<Char> data) {
    // 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:77
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:105
    // 🍞 bin/widgeteer/bindings/widget_key.dart:43
    final keyString = key.cast<Utf8>().toDartString();
    final keyValue = ValueKey(keyString);
    // 🍞 bin/widgeteer/bindings/string.dart:56
    final dataValue = data.cast<Utf8>().toDartString();
    
    return Text(key: keyValue, dataValue);
}