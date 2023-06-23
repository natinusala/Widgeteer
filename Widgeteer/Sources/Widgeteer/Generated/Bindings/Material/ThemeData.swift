// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:91
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/persistent_object.dart:190
import DartApiDl

// 🍞 bin/widgeteer/bindings/persistent_object.dart:135
public class ThemeData {
    /// Persistent handle to the Dart object.
    let handle: Dart_PersistentHandle

    // 🍞 bin/widgeteer/bindings/persistent_object.dart:98
    public init(primarySwatch: MaterialColor?, textTheme: TextTheme? = nil, scaffoldBackgroundColor: Color? = nil, hintColor: Color? = nil, primaryTextTheme: TextTheme? = nil) {
        // 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:118
        assertIsOnFlutterThread()
        
        // 🍞 bin/widgeteer/bindings/enum.dart:235
        let primarySwatchValue = primarySwatch?.rawValue ?? -1
        // 🍞 bin/widgeteer/bindings/persistent_object.dart:323
        let textThemeValue = textTheme?.handle ?? Dart_Null
        // 🍞 bin/widgeteer/bindings/color.dart:79
        let scaffoldBackgroundColorValue = scaffoldBackgroundColor?.value ?? -1
        // 🍞 bin/widgeteer/bindings/color.dart:79
        let hintColorValue = hintColor?.value ?? -1
        // 🍞 bin/widgeteer/bindings/persistent_object.dart:323
        let primaryTextThemeValue = primaryTextTheme?.handle ?? Dart_Null
        let localHandle = Flutter_NewThemeData(
            primarySwatchValue,
            textThemeValue,
            scaffoldBackgroundColorValue,
            hintColorValue,
            primaryTextThemeValue
        )
        self.handle = Dart_NewPersistentHandle_DL(localHandle)!
    }
    
    public init(persisting localHandle: Dart_Handle) {
        self.handle = Dart_NewPersistentHandle_DL(localHandle)!
    }

    // 🍞 bin/widgeteer/bindings/persistent_object.dart:123
    deinit {
        Flutter_Schedule(scoped: false) { [handle] _ in
            Dart_DeletePersistentHandle_DL(handle)
        }
    }
    // 🍞 bin/widgeteer/bindings/persistent_object.dart:159
    public var textTheme: TextTheme {
        return Flutter_BlockingSchedule(scoped: false) { _ in
            let localHandle = Flutter_ThemeDataGetTextTheme(self.handle)
            // 🍞 bin/widgeteer/bindings/persistent_object.dart:238
            let ThemeDataValue = TextTheme(persisting: localHandle)
            return ThemeDataValue
        }
    }
    
    public var scaffoldBackgroundColor: Color {
        return Flutter_BlockingSchedule(scoped: false) { _ in
            let localHandle = Flutter_ThemeDataGetScaffoldBackgroundColor(self.handle)
            // 🍞 bin/widgeteer/bindings/color.dart:110
            let ThemeDataValue = Color(localHandle)
            return ThemeDataValue
        }
    }
    
    public var hintColor: Color {
        return Flutter_BlockingSchedule(scoped: false) { _ in
            let localHandle = Flutter_ThemeDataGetHintColor(self.handle)
            // 🍞 bin/widgeteer/bindings/color.dart:110
            let ThemeDataValue = Color(localHandle)
            return ThemeDataValue
        }
    }
    
    public var primaryTextTheme: TextTheme {
        return Flutter_BlockingSchedule(scoped: false) { _ in
            let localHandle = Flutter_ThemeDataGetPrimaryTextTheme(self.handle)
            // 🍞 bin/widgeteer/bindings/persistent_object.dart:238
            let ThemeDataValue = TextTheme(persisting: localHandle)
            return ThemeDataValue
        }
    }
    
}