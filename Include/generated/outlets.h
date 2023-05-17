// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:78
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
#import "../types.h"

// Outlet emitted by 'Text' binding (Instance of 'WidgetBinding')
extern void register_new_text(Dart_Handle (*outlet)(char* key, char* data));
// Outlet emitted by 'RunApp' binding (Instance of 'FunctionBinding')
extern void register_run_app(void (*outlet)(Dart_Handle app));
// Outlet emitted by 'Directionality' binding (Instance of 'WidgetBinding')
extern void register_new_directionality(Dart_Handle (*outlet)(char* key, int textDirection, Dart_Handle child));
// Outlet emitted by 'MaterialApp' binding (Instance of 'WidgetBinding')
extern void register_new_material_app(Dart_Handle (*outlet)(char* key, char* title, Dart_PersistentHandle theme, Dart_Handle home));
// Outlet emitted by 'ThemeData' binding (Instance of 'PersistentObjectBinding')
extern void register_new_theme_data(Dart_Handle (*outlet)(int primarySwatch));
// Outlet emitted by 'StatelessUserWidget' binding (Instance of 'WidgetBinding')
extern void register_new_stateless_user_widget(Dart_Handle (*outlet)(char* key, widgeteer_stateless_user_widget_proxy proxy, char* swiftWidgetName));