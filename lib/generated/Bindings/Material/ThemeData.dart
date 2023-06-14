// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:77
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:45
import 'package:widgeteer/generated/Bindings/Callback/VoidCallback.dart';
// 🍞 bin/widgeteer/bindings/persistent_object.dart:156
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:57
import 'package:flutter/material.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:widgeteer/generated/lib_widgeteer.dart';
import 'package:widgeteer/swift.dart';
import 'package:flutter/foundation.dart';
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:89
Object newThemeDataImpl(int primarySwatch) {
    // 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:79
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:105
    // 🍞 bin/widgeteer/bindings/enum.dart:194
    late final MaterialColor? primarySwatchValue;
    switch (primarySwatch) {
        case -1: primarySwatchValue = null; break;
        case 0: primarySwatchValue = Colors.blue; break;
        case 1: primarySwatchValue = Colors.green; break;
        default: throw "Received invalid index '$primarySwatch' for value of enum 'MaterialColor?'";
    }
    
    return ThemeData(primarySwatch: primarySwatchValue);
}