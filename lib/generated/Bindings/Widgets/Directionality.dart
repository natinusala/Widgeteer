// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:60
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/widget.dart:113
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:57
import 'package:flutter/widgets.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:widgeteer/generated/lib_widgeteer.dart';
import 'package:flutter/foundation.dart';
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:88
Object newDirectionalityImpl(Pointer<Char> key, int textDirection, Object child) {
    // 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:78
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:105
    // 🍞 bin/widgeteer/bindings/widget_key.dart:43
    final keyString = key.cast<Utf8>().toDartString();
    final keyValue = ValueKey(keyString);
    // 🍞 bin/widgeteer/bindings/enum.dart:137
    late final TextDirection textDirectionValue;
    switch (textDirection) {
        case 0: textDirectionValue = TextDirection.rtl; break;
        case 1: textDirectionValue = TextDirection.ltr; break;
        default: throw "Received invalid index '$textDirection' for value of enum 'TextDirection'";
    }
    // 🍞 bin/widgeteer/bindings/widget.dart:417
    final childValue = child as Widget;
    
    return Directionality(key: keyValue, textDirection: textDirectionValue, child: childValue);
}