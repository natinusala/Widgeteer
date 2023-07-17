// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:81
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:45
import 'package:flutter/widgets.dart';
import 'package:widgeteer/dylib.dart';
import 'package:flutter/material.dart';
import 'package:widgeteer/generated/Bindings/Callback/VoidCallback.dart';
// 🍞 bin/widgeteer/bindings/widget.dart:148
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:59
import 'package:flutter/widgets.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:widgeteer/generated/lib_widgeteer.dart';
import 'package:widgeteer/swift.dart';
import 'package:flutter/foundation.dart';
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:95
Object newRowImpl(Pointer<Char> key, int mainAxisAlignment, handles_list children) {
    // 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:81
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:143
    // 🍞 bin/widgeteer/bindings/widget_key.dart:43
    final keyString = key.cast<Utf8>().toDartString();
    final keyValue = ValueKey(keyString);
    // 🍞 bin/widgeteer/bindings/enum.dart:143
    late final MainAxisAlignment mainAxisAlignmentValue;
    switch (mainAxisAlignment) {
        case 0: mainAxisAlignmentValue = MainAxisAlignment.start; break;
        case 1: mainAxisAlignmentValue = MainAxisAlignment.end; break;
        case 2: mainAxisAlignmentValue = MainAxisAlignment.center; break;
        case 3: mainAxisAlignmentValue = MainAxisAlignment.spaceBetween; break;
        case 4: mainAxisAlignmentValue = MainAxisAlignment.spaceAround; break;
        case 5: mainAxisAlignmentValue = MainAxisAlignment.spaceEvenly; break;
        default: throw "Received invalid index '$mainAxisAlignment' for value of enum 'MainAxisAlignment'";
    }
    // 🍞 bin/widgeteer/bindings/widget.dart:615
    final childrenValue = consumeHandlesList<Widget>(children);
    
    return Row(key: keyValue, mainAxisAlignment: mainAxisAlignmentValue, children: childrenValue);
}