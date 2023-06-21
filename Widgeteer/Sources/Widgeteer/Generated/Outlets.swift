// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:166
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
import DartApiDl

// MARK: NewText
// Outlet emitted by 'Text' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:86
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
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:86
public typealias _NewColumn_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ mainAxisAlignment: Int, _ mainAxisSize: Int, _ crossAxisAlignment: Int, _ children: UnsafeRawPointer) -> Dart_Handle
public typealias _NewColumn = (_ key: UnsafePointer<CChar>?, _ mainAxisAlignment: Int, _ mainAxisSize: Int, _ crossAxisAlignment: Int, _ children: UnsafeRawPointer) -> Dart_Handle

public var Flutter_NewColumn: _NewColumn = { (_, _, _, _, _) in fatalError("'NewColumn' called before it was registered") }

@_cdecl("register_new_column")
public func _registerNewColumn(_ outlet: _NewColumn_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewColumn'")
    Flutter_NewColumn = { (p0, p1, p2, p3, p4) in assertIsOnFlutterThread(); return outlet(p0, p1, p2, p3, p4) }
}
// MARK: RunApp
// Outlet emitted by 'RunApp' binding (Instance of 'FunctionBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:86
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
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:86
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
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:86
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
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:86
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
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:86
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
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:86
public typealias _ThemeOf_CFunctionPointer = @convention(c) (_ buildContext: Dart_Handle) -> Dart_PersistentHandle
public typealias _ThemeOf = (_ buildContext: Dart_Handle) -> Dart_PersistentHandle

public var Flutter_ThemeOf: _ThemeOf = { (_) in fatalError("'ThemeOf' called before it was registered") }

@_cdecl("register_theme_of")
public func _registerThemeOf(_ outlet: _ThemeOf_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'ThemeOf'")
    Flutter_ThemeOf = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: NewTextTheme
// Outlet emitted by 'TextTheme' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:86
public typealias _NewTextTheme_CFunctionPointer = @convention(c) (_ headlineLarge: Dart_PersistentHandle, _ headlineMedium: Dart_PersistentHandle, _ headlineSmall: Dart_PersistentHandle, _ titleLarge: Dart_PersistentHandle, _ titleMedium: Dart_PersistentHandle, _ titleSmall: Dart_PersistentHandle, _ labelLarge: Dart_PersistentHandle, _ labelMedium: Dart_PersistentHandle, _ labelSmall: Dart_PersistentHandle, _ bodyLarge: Dart_PersistentHandle, _ bodyMedium: Dart_PersistentHandle, _ bodySmall: Dart_PersistentHandle) -> Dart_Handle
public typealias _NewTextTheme = (_ headlineLarge: Dart_PersistentHandle, _ headlineMedium: Dart_PersistentHandle, _ headlineSmall: Dart_PersistentHandle, _ titleLarge: Dart_PersistentHandle, _ titleMedium: Dart_PersistentHandle, _ titleSmall: Dart_PersistentHandle, _ labelLarge: Dart_PersistentHandle, _ labelMedium: Dart_PersistentHandle, _ labelSmall: Dart_PersistentHandle, _ bodyLarge: Dart_PersistentHandle, _ bodyMedium: Dart_PersistentHandle, _ bodySmall: Dart_PersistentHandle) -> Dart_Handle

public var Flutter_NewTextTheme: _NewTextTheme = { (_, _, _, _, _, _, _, _, _, _, _, _) in fatalError("'NewTextTheme' called before it was registered") }

@_cdecl("register_new_text_theme")
public func _registerNewTextTheme(_ outlet: _NewTextTheme_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewTextTheme'")
    Flutter_NewTextTheme = { (p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) in assertIsOnFlutterThread(); return outlet(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) }
}
// MARK: NewThemeData
// Outlet emitted by 'ThemeData' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:86
public typealias _NewThemeData_CFunctionPointer = @convention(c) (_ primarySwatch: Int, _ textTheme: Dart_PersistentHandle, _ scaffoldBackgroundColor: Int, _ hintColor: Int, _ primaryTextTheme: Dart_PersistentHandle) -> Dart_Handle
public typealias _NewThemeData = (_ primarySwatch: Int, _ textTheme: Dart_PersistentHandle, _ scaffoldBackgroundColor: Int, _ hintColor: Int, _ primaryTextTheme: Dart_PersistentHandle) -> Dart_Handle

public var Flutter_NewThemeData: _NewThemeData = { (_, _, _, _, _) in fatalError("'NewThemeData' called before it was registered") }

@_cdecl("register_new_theme_data")
public func _registerNewThemeData(_ outlet: _NewThemeData_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewThemeData'")
    Flutter_NewThemeData = { (p0, p1, p2, p3, p4) in assertIsOnFlutterThread(); return outlet(p0, p1, p2, p3, p4) }
}
// MARK: NewTextButton
// Outlet emitted by 'TextButton' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:86
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
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:86
public typealias _NewAppBar_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ title: Dart_Handle) -> Dart_Handle
public typealias _NewAppBar = (_ key: UnsafePointer<CChar>?, _ title: Dart_Handle) -> Dart_Handle

public var Flutter_NewAppBar: _NewAppBar = { (_, _) in fatalError("'NewAppBar' called before it was registered") }

@_cdecl("register_new_app_bar")
public func _registerNewAppBar(_ outlet: _NewAppBar_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewAppBar'")
    Flutter_NewAppBar = { (p0, p1) in assertIsOnFlutterThread(); return outlet(p0, p1) }
}
// MARK: NewTextStyle
// Outlet emitted by 'TextStyle' binding (Instance of 'PersistentObjectBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:86
public typealias _NewTextStyle_CFunctionPointer = @convention(c) (_ color: Int) -> Dart_Handle
public typealias _NewTextStyle = (_ color: Int) -> Dart_Handle

public var Flutter_NewTextStyle: _NewTextStyle = { (_) in fatalError("'NewTextStyle' called before it was registered") }

@_cdecl("register_new_text_style")
public func _registerNewTextStyle(_ outlet: _NewTextStyle_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewTextStyle'")
    Flutter_NewTextStyle = { (p0) in assertIsOnFlutterThread(); return outlet(p0) }
}
// MARK: NewStatelessUserWidget
// Outlet emitted by 'StatelessUserWidget' binding (Instance of 'WidgetBinding')
// 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:86
public typealias _NewStatelessUserWidget_CFunctionPointer = @convention(c) (_ key: UnsafePointer<CChar>?, _ proxy: UnsafeRawPointer, _ swiftWidgetName: UnsafePointer<CChar>?) -> Dart_Handle
public typealias _NewStatelessUserWidget = (_ key: UnsafePointer<CChar>?, _ proxy: UnsafeRawPointer, _ swiftWidgetName: UnsafePointer<CChar>?) -> Dart_Handle

public var Flutter_NewStatelessUserWidget: _NewStatelessUserWidget = { (_, _, _) in fatalError("'NewStatelessUserWidget' called before it was registered") }

@_cdecl("register_new_stateless_user_widget")
public func _registerNewStatelessUserWidget(_ outlet: _NewStatelessUserWidget_CFunctionPointer) {
    assertIsOnFlutterThread()
    trace("Registering 'NewStatelessUserWidget'")
    Flutter_NewStatelessUserWidget = { (p0, p1, p2) in assertIsOnFlutterThread(); return outlet(p0, p1, p2) }
}