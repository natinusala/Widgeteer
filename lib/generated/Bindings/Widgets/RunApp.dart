// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:81
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:45
import 'package:flutter/widgets.dart';
import 'package:widgeteer/dylib.dart';
import 'package:flutter/material.dart';
import 'package:widgeteer/generated/Bindings/Callback/VoidCallback.dart';
// 🍞 bin/widgeteer/bindings/function.dart:80
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:59
import 'package:flutter/widgets.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:widgeteer/generated/lib_widgeteer.dart';
import 'package:widgeteer/swift.dart';
import 'package:flutter/foundation.dart';
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:91
void runAppImpl(Object app) {
    // 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:81
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:143
    // 🍞 bin/widgeteer/bindings/any_widget.dart:83
    final appValue = app as Widget;
    
    return runApp(appValue);
}