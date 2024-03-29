// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:172
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
import DartApiDl

// MARK: NewText
// Outlet emitted by 'Text' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewText_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ data: UnsafePointer<CChar>?, _ style: Dart_PersistentHandle) -> Dart_Handle
public typealias _NewText = (_ key: UnsafePointer<CChar>?, _ data: UnsafePointer<CChar>?, _ style: Dart_PersistentHandle) -> Dart_Handle

public var Flutter_NewText: _NewText = { (_, _, _) in fatalError("'NewText' called before it was registered") }

@_cdecl("register_new_text")
public func _registerNewText(_ outlet: _NewText_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewText'")
    Flutter_NewText = { (p0, p1, p2) in assertIsOnFlutterThread(); return outlet(p0, p1, p2) }
}
// MARK: NewColumn
// Outlet emitted by 'Column' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewColumn_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ mainAxisAlignment: Int, _ mainAxisSize: Int, _ crossAxisAlignment: Int, _ children: UnsafeRawPointer) -> Dart_Handle
public typealias _NewColumn = (_ key: UnsafePointer<CChar>?, _ mainAxisAlignment: Int, _ mainAxisSize: Int, _ crossAxisAlignment: Int, _ children: UnsafeRawPointer) -> Dart_Handle

public var Flutter_NewColumn: _NewColumn = { (_, _, _, _, _) in fatalError("'NewColumn' called before it was registered") }

@_cdecl("register_new_column")
public func _registerNewColumn(_ outlet: _NewColumn_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewColumn'")
    Flutter_NewColumn = { (p0, p1, p2, p3, p4) in assertIsOnFlutterThread(); return outlet(p0, p1, p2, p3, p4) }
}
// MARK: NewIcon
// Outlet emitted by 'Icon' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewIcon_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ icon: Int, _ size: UnsafeRawPointer) -> Dart_Handle
public typealias _NewIcon = (_ key: UnsafePointer<CChar>?, _ icon: Int, _ size: UnsafeRawPointer) -> Dart_Handle

public var Flutter_NewIcon: _NewIcon = { (_, _, _) in fatalError("'NewIcon' called before it was registered") }

@_cdecl("register_new_icon")
public func _registerNewIcon(_ outlet: _NewIcon_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewIcon'")
    Flutter_NewIcon = { (p0, p1, p2) in assertIsOnFlutterThread(); return outlet(p0, p1, p2) }
}
// MARK: RunApp
// Outlet emitted by 'RunApp' binding (Instance of 'FunctionBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _RunApp_CFunctionPointer = @convention(c) (_ app: Dart_Handle) -> Void
public typealias _RunApp = (_ app: Dart_Handle) -> Void

public var Flutter_RunApp: _RunApp = { (_) in fatalError("'RunApp' called before it was registered") }

@_cdecl("register_run_app")
public func _registerRunApp(_ outlet: _RunApp_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'RunApp'")
    Flutter_RunApp = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: NewDirectionality
// Outlet emitted by 'Directionality' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewDirectionality_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ textDirection: Int, _ child: Dart_Handle) -> Dart_Handle
public typealias _NewDirectionality = (_ key: UnsafePointer<CChar>?, _ textDirection: Int, _ child: Dart_Handle) -> Dart_Handle

public var Flutter_NewDirectionality: _NewDirectionality = { (_, _, _) in fatalError("'NewDirectionality' called before it was registered") }

@_cdecl("register_new_directionality")
public func _registerNewDirectionality(_ outlet: _NewDirectionality_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewDirectionality'")
    Flutter_NewDirectionality = { (p0, p1, p2) in assertIsOnFlutterThread(); return outlet(p0, p1, p2) }
}
// MARK: NewRow
// Outlet emitted by 'Row' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewRow_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ mainAxisAlignment: Int, _ children: UnsafeRawPointer) -> Dart_Handle
public typealias _NewRow = (_ key: UnsafePointer<CChar>?, _ mainAxisAlignment: Int, _ children: UnsafeRawPointer) -> Dart_Handle

public var Flutter_NewRow: _NewRow = { (_, _, _) in fatalError("'NewRow' called before it was registered") }

@_cdecl("register_new_row")
public func _registerNewRow(_ outlet: _NewRow_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewRow'")
    Flutter_NewRow = { (p0, p1, p2) in assertIsOnFlutterThread(); return outlet(p0, p1, p2) }
}
// MARK: NewCenter
// Outlet emitted by 'Center' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewCenter_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ child: Dart_Handle) -> Dart_Handle
public typealias _NewCenter = (_ key: UnsafePointer<CChar>?, _ child: Dart_Handle) -> Dart_Handle

public var Flutter_NewCenter: _NewCenter = { (_, _) in fatalError("'NewCenter' called before it was registered") }

@_cdecl("register_new_center")
public func _registerNewCenter(_ outlet: _NewCenter_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewCenter'")
    Flutter_NewCenter = { (p0, p1) in assertIsOnFlutterThread(); return outlet(p0, p1) }
}
// MARK: NewMaterialApp
// Outlet emitted by 'MaterialApp' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewMaterialApp_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ title: UnsafePointer<CChar>?, _ theme: Dart_PersistentHandle, _ home: Dart_Handle) -> Dart_Handle
public typealias _NewMaterialApp = (_ key: UnsafePointer<CChar>?, _ title: UnsafePointer<CChar>?, _ theme: Dart_PersistentHandle, _ home: Dart_Handle) -> Dart_Handle

public var Flutter_NewMaterialApp: _NewMaterialApp = { (_, _, _, _) in fatalError("'NewMaterialApp' called before it was registered") }

@_cdecl("register_new_material_app")
public func _registerNewMaterialApp(_ outlet: _NewMaterialApp_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewMaterialApp'")
    Flutter_NewMaterialApp = { (p0, p1, p2, p3) in assertIsOnFlutterThread(); return outlet(p0, p1, p2, p3) }
}
// MARK: ThemeOf
// Outlet emitted by 'ThemeOf' binding (Instance of 'FunctionBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _ThemeOf_CFunctionPointer = @convention(c) (_ buildContext: Dart_Handle) -> Dart_PersistentHandle
public typealias _ThemeOf = (_ buildContext: Dart_Handle) -> Dart_PersistentHandle

public var Flutter_ThemeOf: _ThemeOf = { (_) in fatalError("'ThemeOf' called before it was registered") }

@_cdecl("register_theme_of")
public func _registerThemeOf(_ outlet: _ThemeOf_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'ThemeOf'")
    Flutter_ThemeOf = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: NewScaffold
// Outlet emitted by 'Scaffold' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewScaffold_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ body: Dart_Handle, _ appBar: Dart_Handle, _ floatingActionButton: Dart_Handle) -> Dart_Handle
public typealias _NewScaffold = (_ key: UnsafePointer<CChar>?, _ body: Dart_Handle, _ appBar: Dart_Handle, _ floatingActionButton: Dart_Handle) -> Dart_Handle

public var Flutter_NewScaffold: _NewScaffold = { (_, _, _, _) in fatalError("'NewScaffold' called before it was registered") }

@_cdecl("register_new_scaffold")
public func _registerNewScaffold(_ outlet: _NewScaffold_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewScaffold'")
    Flutter_NewScaffold = { (p0, p1, p2, p3) in assertIsOnFlutterThread(); return outlet(p0, p1, p2, p3) }
}
// MARK: NewTextTheme
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewTextTheme_CFunctionPointer = @convention(c) (_ headlineLarge: Dart_PersistentHandle, _ headlineMedium: Dart_PersistentHandle, _ headlineSmall: Dart_PersistentHandle, _ titleLarge: Dart_PersistentHandle, _ titleMedium: Dart_PersistentHandle, _ titleSmall: Dart_PersistentHandle, _ labelLarge: Dart_PersistentHandle, _ labelMedium: Dart_PersistentHandle, _ labelSmall: Dart_PersistentHandle, _ bodyLarge: Dart_PersistentHandle, _ bodyMedium: Dart_PersistentHandle, _ bodySmall: Dart_PersistentHandle) -> Dart_Handle
public typealias _NewTextTheme = (_ headlineLarge: Dart_PersistentHandle, _ headlineMedium: Dart_PersistentHandle, _ headlineSmall: Dart_PersistentHandle, _ titleLarge: Dart_PersistentHandle, _ titleMedium: Dart_PersistentHandle, _ titleSmall: Dart_PersistentHandle, _ labelLarge: Dart_PersistentHandle, _ labelMedium: Dart_PersistentHandle, _ labelSmall: Dart_PersistentHandle, _ bodyLarge: Dart_PersistentHandle, _ bodyMedium: Dart_PersistentHandle, _ bodySmall: Dart_PersistentHandle) -> Dart_Handle

public var Flutter_NewTextTheme: _NewTextTheme = { (_, _, _, _, _, _, _, _, _, _, _, _) in fatalError("'NewTextTheme' called before it was registered") }

@_cdecl("register_new_text_theme")
public func _registerNewTextTheme(_ outlet: _NewTextTheme_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewTextTheme'")
    Flutter_NewTextTheme = { (p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) in assertIsOnFlutterThread(); return outlet(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) }
}
// MARK: TextThemeGetHeadlineLarge
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _TextThemeGetHeadlineLarge_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle
public typealias _TextThemeGetHeadlineLarge = (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle

public var Flutter_TextThemeGetHeadlineLarge: _TextThemeGetHeadlineLarge = { (_) in fatalError("'TextThemeGetHeadlineLarge' called before it was registered") }

@_cdecl("register_text_theme_get_headline_large")
public func _registerTextThemeGetHeadlineLarge(_ outlet: _TextThemeGetHeadlineLarge_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'TextThemeGetHeadlineLarge'")
    Flutter_TextThemeGetHeadlineLarge = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: TextThemeGetHeadlineMedium
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _TextThemeGetHeadlineMedium_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle
public typealias _TextThemeGetHeadlineMedium = (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle

public var Flutter_TextThemeGetHeadlineMedium: _TextThemeGetHeadlineMedium = { (_) in fatalError("'TextThemeGetHeadlineMedium' called before it was registered") }

@_cdecl("register_text_theme_get_headline_medium")
public func _registerTextThemeGetHeadlineMedium(_ outlet: _TextThemeGetHeadlineMedium_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'TextThemeGetHeadlineMedium'")
    Flutter_TextThemeGetHeadlineMedium = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: TextThemeGetHeadlineSmall
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _TextThemeGetHeadlineSmall_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle
public typealias _TextThemeGetHeadlineSmall = (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle

public var Flutter_TextThemeGetHeadlineSmall: _TextThemeGetHeadlineSmall = { (_) in fatalError("'TextThemeGetHeadlineSmall' called before it was registered") }

@_cdecl("register_text_theme_get_headline_small")
public func _registerTextThemeGetHeadlineSmall(_ outlet: _TextThemeGetHeadlineSmall_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'TextThemeGetHeadlineSmall'")
    Flutter_TextThemeGetHeadlineSmall = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: TextThemeGetTitleLarge
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _TextThemeGetTitleLarge_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle
public typealias _TextThemeGetTitleLarge = (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle

public var Flutter_TextThemeGetTitleLarge: _TextThemeGetTitleLarge = { (_) in fatalError("'TextThemeGetTitleLarge' called before it was registered") }

@_cdecl("register_text_theme_get_title_large")
public func _registerTextThemeGetTitleLarge(_ outlet: _TextThemeGetTitleLarge_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'TextThemeGetTitleLarge'")
    Flutter_TextThemeGetTitleLarge = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: TextThemeGetTitleMedium
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _TextThemeGetTitleMedium_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle
public typealias _TextThemeGetTitleMedium = (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle

public var Flutter_TextThemeGetTitleMedium: _TextThemeGetTitleMedium = { (_) in fatalError("'TextThemeGetTitleMedium' called before it was registered") }

@_cdecl("register_text_theme_get_title_medium")
public func _registerTextThemeGetTitleMedium(_ outlet: _TextThemeGetTitleMedium_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'TextThemeGetTitleMedium'")
    Flutter_TextThemeGetTitleMedium = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: TextThemeGetTitleSmall
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _TextThemeGetTitleSmall_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle
public typealias _TextThemeGetTitleSmall = (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle

public var Flutter_TextThemeGetTitleSmall: _TextThemeGetTitleSmall = { (_) in fatalError("'TextThemeGetTitleSmall' called before it was registered") }

@_cdecl("register_text_theme_get_title_small")
public func _registerTextThemeGetTitleSmall(_ outlet: _TextThemeGetTitleSmall_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'TextThemeGetTitleSmall'")
    Flutter_TextThemeGetTitleSmall = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: TextThemeGetLabelLarge
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _TextThemeGetLabelLarge_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle
public typealias _TextThemeGetLabelLarge = (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle

public var Flutter_TextThemeGetLabelLarge: _TextThemeGetLabelLarge = { (_) in fatalError("'TextThemeGetLabelLarge' called before it was registered") }

@_cdecl("register_text_theme_get_label_large")
public func _registerTextThemeGetLabelLarge(_ outlet: _TextThemeGetLabelLarge_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'TextThemeGetLabelLarge'")
    Flutter_TextThemeGetLabelLarge = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: TextThemeGetLabelMedium
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _TextThemeGetLabelMedium_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle
public typealias _TextThemeGetLabelMedium = (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle

public var Flutter_TextThemeGetLabelMedium: _TextThemeGetLabelMedium = { (_) in fatalError("'TextThemeGetLabelMedium' called before it was registered") }

@_cdecl("register_text_theme_get_label_medium")
public func _registerTextThemeGetLabelMedium(_ outlet: _TextThemeGetLabelMedium_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'TextThemeGetLabelMedium'")
    Flutter_TextThemeGetLabelMedium = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: TextThemeGetLabelSmall
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _TextThemeGetLabelSmall_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle
public typealias _TextThemeGetLabelSmall = (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle

public var Flutter_TextThemeGetLabelSmall: _TextThemeGetLabelSmall = { (_) in fatalError("'TextThemeGetLabelSmall' called before it was registered") }

@_cdecl("register_text_theme_get_label_small")
public func _registerTextThemeGetLabelSmall(_ outlet: _TextThemeGetLabelSmall_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'TextThemeGetLabelSmall'")
    Flutter_TextThemeGetLabelSmall = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: TextThemeGetBodyLarge
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _TextThemeGetBodyLarge_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle
public typealias _TextThemeGetBodyLarge = (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle

public var Flutter_TextThemeGetBodyLarge: _TextThemeGetBodyLarge = { (_) in fatalError("'TextThemeGetBodyLarge' called before it was registered") }

@_cdecl("register_text_theme_get_body_large")
public func _registerTextThemeGetBodyLarge(_ outlet: _TextThemeGetBodyLarge_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'TextThemeGetBodyLarge'")
    Flutter_TextThemeGetBodyLarge = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: TextThemeGetBodyMedium
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _TextThemeGetBodyMedium_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle
public typealias _TextThemeGetBodyMedium = (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle

public var Flutter_TextThemeGetBodyMedium: _TextThemeGetBodyMedium = { (_) in fatalError("'TextThemeGetBodyMedium' called before it was registered") }

@_cdecl("register_text_theme_get_body_medium")
public func _registerTextThemeGetBodyMedium(_ outlet: _TextThemeGetBodyMedium_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'TextThemeGetBodyMedium'")
    Flutter_TextThemeGetBodyMedium = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: TextThemeGetBodySmall
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _TextThemeGetBodySmall_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle
public typealias _TextThemeGetBodySmall = (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle

public var Flutter_TextThemeGetBodySmall: _TextThemeGetBodySmall = { (_) in fatalError("'TextThemeGetBodySmall' called before it was registered") }

@_cdecl("register_text_theme_get_body_small")
public func _registerTextThemeGetBodySmall(_ outlet: _TextThemeGetBodySmall_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'TextThemeGetBodySmall'")
    Flutter_TextThemeGetBodySmall = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: NewThemeData
// Outlet emitted by 'ThemeData' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewThemeData_CFunctionPointer = @convention(c) (_ primarySwatch: Int, _ textTheme: Dart_PersistentHandle, _ scaffoldBackgroundColor: Int, _ hintColor: Int, _ primaryTextTheme: Dart_PersistentHandle) -> Dart_Handle
public typealias _NewThemeData = (_ primarySwatch: Int, _ textTheme: Dart_PersistentHandle, _ scaffoldBackgroundColor: Int, _ hintColor: Int, _ primaryTextTheme: Dart_PersistentHandle) -> Dart_Handle

public var Flutter_NewThemeData: _NewThemeData = { (_, _, _, _, _) in fatalError("'NewThemeData' called before it was registered") }

@_cdecl("register_new_theme_data")
public func _registerNewThemeData(_ outlet: _NewThemeData_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewThemeData'")
    Flutter_NewThemeData = { (p0, p1, p2, p3, p4) in assertIsOnFlutterThread(); return outlet(p0, p1, p2, p3, p4) }
}
// MARK: ThemeDataGetTextTheme
// Outlet emitted by 'ThemeData' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _ThemeDataGetTextTheme_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle
public typealias _ThemeDataGetTextTheme = (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle

public var Flutter_ThemeDataGetTextTheme: _ThemeDataGetTextTheme = { (_) in fatalError("'ThemeDataGetTextTheme' called before it was registered") }

@_cdecl("register_theme_data_get_text_theme")
public func _registerThemeDataGetTextTheme(_ outlet: _ThemeDataGetTextTheme_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'ThemeDataGetTextTheme'")
    Flutter_ThemeDataGetTextTheme = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: ThemeDataGetScaffoldBackgroundColor
// Outlet emitted by 'ThemeData' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _ThemeDataGetScaffoldBackgroundColor_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Int
public typealias _ThemeDataGetScaffoldBackgroundColor = (_ instance: Dart_PersistentHandle) -> Int

public var Flutter_ThemeDataGetScaffoldBackgroundColor: _ThemeDataGetScaffoldBackgroundColor = { (_) in fatalError("'ThemeDataGetScaffoldBackgroundColor' called before it was registered") }

@_cdecl("register_theme_data_get_scaffold_background_color")
public func _registerThemeDataGetScaffoldBackgroundColor(_ outlet: _ThemeDataGetScaffoldBackgroundColor_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'ThemeDataGetScaffoldBackgroundColor'")
    Flutter_ThemeDataGetScaffoldBackgroundColor = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: ThemeDataGetHintColor
// Outlet emitted by 'ThemeData' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _ThemeDataGetHintColor_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Int
public typealias _ThemeDataGetHintColor = (_ instance: Dart_PersistentHandle) -> Int

public var Flutter_ThemeDataGetHintColor: _ThemeDataGetHintColor = { (_) in fatalError("'ThemeDataGetHintColor' called before it was registered") }

@_cdecl("register_theme_data_get_hint_color")
public func _registerThemeDataGetHintColor(_ outlet: _ThemeDataGetHintColor_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'ThemeDataGetHintColor'")
    Flutter_ThemeDataGetHintColor = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: ThemeDataGetPrimaryTextTheme
// Outlet emitted by 'ThemeData' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _ThemeDataGetPrimaryTextTheme_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle
public typealias _ThemeDataGetPrimaryTextTheme = (_ instance: Dart_PersistentHandle) -> Dart_PersistentHandle

public var Flutter_ThemeDataGetPrimaryTextTheme: _ThemeDataGetPrimaryTextTheme = { (_) in fatalError("'ThemeDataGetPrimaryTextTheme' called before it was registered") }

@_cdecl("register_theme_data_get_primary_text_theme")
public func _registerThemeDataGetPrimaryTextTheme(_ outlet: _ThemeDataGetPrimaryTextTheme_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'ThemeDataGetPrimaryTextTheme'")
    Flutter_ThemeDataGetPrimaryTextTheme = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: NewTextButton
// Outlet emitted by 'TextButton' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewTextButton_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ onPressed: UnsafeRawPointer?, _ child: Dart_Handle) -> Dart_Handle
public typealias _NewTextButton = (_ key: UnsafePointer<CChar>?, _ onPressed: UnsafeRawPointer?, _ child: Dart_Handle) -> Dart_Handle

public var Flutter_NewTextButton: _NewTextButton = { (_, _, _) in fatalError("'NewTextButton' called before it was registered") }

@_cdecl("register_new_text_button")
public func _registerNewTextButton(_ outlet: _NewTextButton_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewTextButton'")
    Flutter_NewTextButton = { (p0, p1, p2) in assertIsOnFlutterThread(); return outlet(p0, p1, p2) }
}
// MARK: NewAppBar
// Outlet emitted by 'AppBar' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewAppBar_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ title: Dart_Handle) -> Dart_Handle
public typealias _NewAppBar = (_ key: UnsafePointer<CChar>?, _ title: Dart_Handle) -> Dart_Handle

public var Flutter_NewAppBar: _NewAppBar = { (_, _) in fatalError("'NewAppBar' called before it was registered") }

@_cdecl("register_new_app_bar")
public func _registerNewAppBar(_ outlet: _NewAppBar_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewAppBar'")
    Flutter_NewAppBar = { (p0, p1) in assertIsOnFlutterThread(); return outlet(p0, p1) }
}
// MARK: NewFloatingActionButton
// Outlet emitted by 'FloatingActionButton' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewFloatingActionButton_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ onPressed: UnsafeRawPointer?, _ tooltip: UnsafeRawPointer, _ child: Dart_Handle) -> Dart_Handle
public typealias _NewFloatingActionButton = (_ key: UnsafePointer<CChar>?, _ onPressed: UnsafeRawPointer?, _ tooltip: UnsafeRawPointer, _ child: Dart_Handle) -> Dart_Handle

public var Flutter_NewFloatingActionButton: _NewFloatingActionButton = { (_, _, _, _) in fatalError("'NewFloatingActionButton' called before it was registered") }

@_cdecl("register_new_floating_action_button")
public func _registerNewFloatingActionButton(_ outlet: _NewFloatingActionButton_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewFloatingActionButton'")
    Flutter_NewFloatingActionButton = { (p0, p1, p2, p3) in assertIsOnFlutterThread(); return outlet(p0, p1, p2, p3) }
}
// MARK: NewTextStyle
// Outlet emitted by 'TextStyle' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewTextStyle_CFunctionPointer = @convention(c) (_ color: Int) -> Dart_Handle
public typealias _NewTextStyle = (_ color: Int) -> Dart_Handle

public var Flutter_NewTextStyle: _NewTextStyle = { (_) in fatalError("'NewTextStyle' called before it was registered") }

@_cdecl("register_new_text_style")
public func _registerNewTextStyle(_ outlet: _NewTextStyle_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewTextStyle'")
    Flutter_NewTextStyle = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: TextStyleGetColor
// Outlet emitted by 'TextStyle' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _TextStyleGetColor_CFunctionPointer = @convention(c) (_ instance: Dart_PersistentHandle) -> Int
public typealias _TextStyleGetColor = (_ instance: Dart_PersistentHandle) -> Int

public var Flutter_TextStyleGetColor: _TextStyleGetColor = { (_) in fatalError("'TextStyleGetColor' called before it was registered") }

@_cdecl("register_text_style_get_color")
public func _registerTextStyleGetColor(_ outlet: _TextStyleGetColor_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'TextStyleGetColor'")
    Flutter_TextStyleGetColor = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: NewStatefulUserWidget
// Outlet emitted by 'StatefulUserWidget' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewStatefulUserWidget_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ proxy: UnsafeRawPointer, _ swiftWidgetName: UnsafePointer<CChar>?) -> Dart_Handle
public typealias _NewStatefulUserWidget = (_ key: UnsafePointer<CChar>?, _ proxy: UnsafeRawPointer, _ swiftWidgetName: UnsafePointer<CChar>?) -> Dart_Handle

public var Flutter_NewStatefulUserWidget: _NewStatefulUserWidget = { (_, _, _) in fatalError("'NewStatefulUserWidget' called before it was registered") }

@_cdecl("register_new_stateful_user_widget")
public func _registerNewStatefulUserWidget(_ outlet: _NewStatefulUserWidget_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewStatefulUserWidget'")
    Flutter_NewStatefulUserWidget = { (p0, p1, p2) in assertIsOnFlutterThread(); return outlet(p0, p1, p2) }
}
// MARK: TouchState
// Outlet emitted by 'TouchState' binding (Instance of 'FunctionBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _TouchState_CFunctionPointer = @convention(c) (_ state: Dart_Handle) -> Void
public typealias _TouchState = (_ state: Dart_Handle) -> Void

public var Flutter_TouchState: _TouchState = { (_) in fatalError("'TouchState' called before it was registered") }

@_cdecl("register_touch_state")
public func _registerTouchState(_ outlet: _TouchState_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'TouchState'")
    Flutter_TouchState = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: NewStatelessUserWidget
// Outlet emitted by 'StatelessUserWidget' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:96
public typealias _NewStatelessUserWidget_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ proxy: UnsafeRawPointer, _ swiftWidgetName: UnsafePointer<CChar>?) -> Dart_Handle
public typealias _NewStatelessUserWidget = (_ key: UnsafePointer<CChar>?, _ proxy: UnsafeRawPointer, _ swiftWidgetName: UnsafePointer<CChar>?) -> Dart_Handle

public var Flutter_NewStatelessUserWidget: _NewStatelessUserWidget = { (_, _, _) in fatalError("'NewStatelessUserWidget' called before it was registered") }

@_cdecl("register_new_stateless_user_widget")
public func _registerNewStatelessUserWidget(_ outlet: _NewStatelessUserWidget_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewStatelessUserWidget'")
    Flutter_NewStatelessUserWidget = { (p0, p1, p2) in assertIsOnFlutterThread(); return outlet(p0, p1, p2) }
}