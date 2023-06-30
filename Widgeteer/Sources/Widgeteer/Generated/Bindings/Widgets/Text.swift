// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:91
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/widget.dart:159
// 🍞 bin/widgeteer/bindings/widget.dart:241
public struct Text: BuiltinWidget {
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:207
    let data: String
    let style: TextStyle?

    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:220
    public init(_ data: String, style: TextStyle? = nil) {
        self.data = data
        self.style = style
    }

    // 🍞 bin/widgeteer/bindings/widget.dart:264
    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        // 🍞 bin/widgeteer/bindings/string.dart:79
        let dataValue = self.data
        // 🍞 bin/widgeteer/bindings/persistent_object.dart:361
        let styleValue = self.style?.handle ?? Dart_Null
        let localHandle = Flutter_NewText(
            parentKey.joined(String(describing: Self.self)),
            dataValue,
            styleValue
        )
        let reducedWidget = ReducedWidget(handle: localHandle)
        return reducedWidget
    }
}