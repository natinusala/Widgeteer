// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:133
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
import 'dart:ffi';
import 'lib_widgeteer.dart';
import 'package:ffi/ffi.dart';

import 'package:widgeteer/generated/Bindings/Widgets/Text.dart';
import 'package:widgeteer/generated/Bindings/Widgets/Column.dart';
import 'package:widgeteer/generated/Bindings/Widgets/RunApp.dart';
import 'package:widgeteer/generated/Bindings/Widgets/Directionality.dart';
import 'package:widgeteer/generated/Bindings/Widgets/Center.dart';
import 'package:widgeteer/generated/Bindings/Material/MaterialApp.dart';
import 'package:widgeteer/generated/Bindings/Material/ThemeData.dart';
import 'package:widgeteer/generated/Bindings/Material/TextButton.dart';
import 'package:widgeteer/generated/Bindings/Material/AppBar.dart';
import 'package:widgeteer/generated/Bindings/Bridging/StatelessUserWidget.dart';
import 'package:widgeteer/generated/Bindings/Callback/VoidCallback.dart';

void registerOutlets(LibWidgeteer widgeteer) {
    // Outlet emitted by 'Text' binding (Instance of 'WidgetBinding')
    // 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:74
    widgeteer.register_new_text(Pointer.fromFunction(newTextImpl));
    // Outlet emitted by 'Column' binding (Instance of 'WidgetBinding')
    // 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:74
    widgeteer.register_new_column(Pointer.fromFunction(newColumnImpl));
    // Outlet emitted by 'RunApp' binding (Instance of 'FunctionBinding')
    // 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:74
    widgeteer.register_run_app(Pointer.fromFunction(runAppImpl));
    // Outlet emitted by 'Directionality' binding (Instance of 'WidgetBinding')
    // 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:74
    widgeteer.register_new_directionality(Pointer.fromFunction(newDirectionalityImpl));
    // Outlet emitted by 'Center' binding (Instance of 'WidgetBinding')
    // 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:74
    widgeteer.register_new_center(Pointer.fromFunction(newCenterImpl));
    // Outlet emitted by 'MaterialApp' binding (Instance of 'WidgetBinding')
    // 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:74
    widgeteer.register_new_material_app(Pointer.fromFunction(newMaterialAppImpl));
    // Outlet emitted by 'ThemeData' binding (Instance of 'PersistentObjectBinding')
    // 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:74
    widgeteer.register_new_theme_data(Pointer.fromFunction(newThemeDataImpl));
    // Outlet emitted by 'TextButton' binding (Instance of 'WidgetBinding')
    // 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:74
    widgeteer.register_new_text_button(Pointer.fromFunction(newTextButtonImpl));
    // Outlet emitted by 'AppBar' binding (Instance of 'WidgetBinding')
    // 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:74
    widgeteer.register_new_app_bar(Pointer.fromFunction(newAppBarImpl));
    // Outlet emitted by 'StatelessUserWidget' binding (Instance of 'WidgetBinding')
    // 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:74
    widgeteer.register_new_stateless_user_widget(Pointer.fromFunction(newStatelessUserWidgetImpl));
}