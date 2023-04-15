// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:72
// GENERATED BY `widgeteer bindings generate` - DO NOT EDIT
// 🍞 bin/widgeteer/bindings/widget.dart:108
// 🍞 bin/widgeteer/bindings/widget.dart:123
public struct Directionality: BuiltinWidget {
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:159
    let textDirection: TextDirection

    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:172
    public init(textDirection: TextDirection) {
        self.textDirection = textDirection
    }

    // 🍞 bin/widgeteer/bindings/widget.dart:143
    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        // 🍞 bin/widgeteer/bindings/enum.dart:108
        let textDirectionValue = self.textDirection.rawValue
        let localHandle = Flutter_NewDirectionality(
            parentKey.joined(String(describing: Self.self)),
            textDirectionValue
        )
        return ReducedWidget(handle: localHandle)
    }
}