// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:117
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
#import "../types.h"

// Outlet emitted by 'Text' binding (Instance of 'WidgetBinding')
extern void register_new_text(Dart_Handle (*outlet)(char* key, char* data, Dart_PersistentHandle style));
// Outlet emitted by 'Column' binding (Instance of 'WidgetBinding')
extern void register_new_column(Dart_Handle (*outlet)(char* key, int mainAxisAlignment, int mainAxisSize, int crossAxisAlignment, widgeteer_handles_list children));
// Outlet emitted by 'RunApp' binding (Instance of 'FunctionBinding')
extern void register_run_app(void (*outlet)(Dart_Handle app));
// Outlet emitted by 'Directionality' binding (Instance of 'WidgetBinding')
extern void register_new_directionality(Dart_Handle (*outlet)(char* key, int textDirection, Dart_Handle child));
// Outlet emitted by 'Row' binding (Instance of 'WidgetBinding')
extern void register_new_row(Dart_Handle (*outlet)(char* key, int mainAxisAlignment, widgeteer_handles_list children));
// Outlet emitted by 'Center' binding (Instance of 'WidgetBinding')
extern void register_new_center(Dart_Handle (*outlet)(char* key, Dart_Handle child));
// Outlet emitted by 'MaterialApp' binding (Instance of 'WidgetBinding')
extern void register_new_material_app(Dart_Handle (*outlet)(char* key, char* title, Dart_PersistentHandle theme, Dart_Handle home));
// Outlet emitted by 'ThemeOf' binding (Instance of 'FunctionBinding')
extern void register_theme_of(Dart_PersistentHandle (*outlet)(Dart_Handle buildContext));
// Outlet emitted by 'Scaffold' binding (Instance of 'WidgetBinding')
extern void register_new_scaffold(Dart_Handle (*outlet)(char* key, Dart_Handle body, Dart_Handle appBar, Dart_Handle floatingActionButton));
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
extern void register_new_text_theme(Dart_Handle (*outlet)(Dart_PersistentHandle headlineLarge, Dart_PersistentHandle headlineMedium, Dart_PersistentHandle headlineSmall, Dart_PersistentHandle titleLarge, Dart_PersistentHandle titleMedium, Dart_PersistentHandle titleSmall, Dart_PersistentHandle labelLarge, Dart_PersistentHandle labelMedium, Dart_PersistentHandle labelSmall, Dart_PersistentHandle bodyLarge, Dart_PersistentHandle bodyMedium, Dart_PersistentHandle bodySmall));
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
extern void register_text_theme_get_headline_large(Dart_PersistentHandle (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
extern void register_text_theme_get_headline_medium(Dart_PersistentHandle (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
extern void register_text_theme_get_headline_small(Dart_PersistentHandle (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
extern void register_text_theme_get_title_large(Dart_PersistentHandle (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
extern void register_text_theme_get_title_medium(Dart_PersistentHandle (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
extern void register_text_theme_get_title_small(Dart_PersistentHandle (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
extern void register_text_theme_get_label_large(Dart_PersistentHandle (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
extern void register_text_theme_get_label_medium(Dart_PersistentHandle (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
extern void register_text_theme_get_label_small(Dart_PersistentHandle (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
extern void register_text_theme_get_body_large(Dart_PersistentHandle (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
extern void register_text_theme_get_body_medium(Dart_PersistentHandle (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
extern void register_text_theme_get_body_small(Dart_PersistentHandle (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'ThemeData' binding (Instance of 'PersistentObjectBinding')
extern void register_new_theme_data(Dart_Handle (*outlet)(int primarySwatch, Dart_PersistentHandle textTheme, int scaffoldBackgroundColor, int hintColor, Dart_PersistentHandle primaryTextTheme));
// Outlet emitted by 'ThemeData' binding (Instance of 'PersistentObjectBinding')
extern void register_theme_data_get_text_theme(Dart_PersistentHandle (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'ThemeData' binding (Instance of 'PersistentObjectBinding')
extern void register_theme_data_get_scaffold_background_color(int (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'ThemeData' binding (Instance of 'PersistentObjectBinding')
extern void register_theme_data_get_hint_color(int (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'ThemeData' binding (Instance of 'PersistentObjectBinding')
extern void register_theme_data_get_primary_text_theme(Dart_PersistentHandle (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'TextButton' binding (Instance of 'WidgetBinding')
extern void register_new_text_button(Dart_Handle (*outlet)(char* key, void* onPressed, Dart_Handle child));
// Outlet emitted by 'AppBar' binding (Instance of 'WidgetBinding')
extern void register_new_app_bar(Dart_Handle (*outlet)(char* key, Dart_Handle title));
// Outlet emitted by 'TextStyle' binding (Instance of 'PersistentObjectBinding')
extern void register_new_text_style(Dart_Handle (*outlet)(int color));
// Outlet emitted by 'TextStyle' binding (Instance of 'PersistentObjectBinding')
extern void register_text_style_get_color(int (*outlet)(Dart_PersistentHandle instance));
// Outlet emitted by 'StatelessUserWidget' binding (Instance of 'WidgetBinding')
extern void register_new_stateless_user_widget(Dart_Handle (*outlet)(char* key, widgeteer_stateless_user_widget_proxy proxy, char* swiftWidgetName));