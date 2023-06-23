// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:77
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:45
import 'package:widgeteer/generated/Bindings/Callback/VoidCallback.dart';
// 🍞 bin/widgeteer/bindings/widget.dart:140
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:57
import 'package:flutter/widgets.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:widgeteer/generated/lib_widgeteer.dart';
import 'package:widgeteer/swift.dart';
import 'package:flutter/foundation.dart';
// 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:89
Object newColumnImpl(Pointer<Char> key, int mainAxisAlignment, int mainAxisSize, int crossAxisAlignment, handles_list children) {
    // 🍞 bin/widgeteer/bindings_generator/models/dart_function.dart:79
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:142
    // 🍞 bin/widgeteer/bindings/widget_key.dart:43
    final keyString = key.cast<Utf8>().toDartString();
    final keyValue = ValueKey(keyString);
    // 🍞 bin/widgeteer/bindings/enum.dart:137
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
    // 🍞 bin/widgeteer/bindings/enum.dart:137
    late final MainAxisSize mainAxisSizeValue;
    switch (mainAxisSize) {
        case 0: mainAxisSizeValue = MainAxisSize.min; break;
        case 1: mainAxisSizeValue = MainAxisSize.max; break;
        default: throw "Received invalid index '$mainAxisSize' for value of enum 'MainAxisSize'";
    }
    // 🍞 bin/widgeteer/bindings/enum.dart:137
    late final CrossAxisAlignment crossAxisAlignmentValue;
    switch (crossAxisAlignment) {
        case 0: crossAxisAlignmentValue = CrossAxisAlignment.start; break;
        case 1: crossAxisAlignmentValue = CrossAxisAlignment.end; break;
        case 2: crossAxisAlignmentValue = CrossAxisAlignment.center; break;
        case 3: crossAxisAlignmentValue = CrossAxisAlignment.stretch; break;
        case 4: crossAxisAlignmentValue = CrossAxisAlignment.baseline; break;
        default: throw "Received invalid index '$crossAxisAlignment' for value of enum 'CrossAxisAlignment'";
    }
    // 🍞 bin/widgeteer/bindings/widget.dart:565
    final childrenValue = consumeHandlesList<Widget>(children);
    
    return Column(key: keyValue, mainAxisAlignment: mainAxisAlignmentValue, mainAxisSize: mainAxisSizeValue, crossAxisAlignment: crossAxisAlignmentValue, children: childrenValue);
}