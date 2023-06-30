// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:91
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/persistent_object.dart:189
import DartApiDl

// 🍞 bin/widgeteer/bindings/persistent_object.dart:135
public class TextStyle {
    /// Persistent handle to the Dart object.
    let handle: Dart_PersistentHandle

    // 🍞 bin/widgeteer/bindings/persistent_object.dart:98
    public init(color: Color?) {
        // 🍞 bin/widgeteer/bindings_generator/models/outlet.dart:128
        assertIsOnFlutterThread()
        
        // 🍞 bin/widgeteer/bindings/color.dart:79
        let colorValue = color?.value ?? -1
        let localHandle = Flutter_NewTextStyle(
            colorValue
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
    public var color: Color? {
        return Flutter_BlockingSchedule(scoped: false) { _ in
            let localHandle = Flutter_TextStyleGetColor(self.handle)
            // 🍞 bin/widgeteer/bindings/color.dart:53
            let TextStyleValue: Color? = localHandle == -1 ? nil : Color(localHandle)
            return TextStyleValue
        }
    }
    
}