// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:72
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/widget.dart:132
// 🍞 bin/widgeteer/bindings/widget.dart:155
public struct MaterialApp<Home: SingleWidget>: BuiltinWidget {
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:160
    let title: String
    let home: Home

    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:173
    public init(title: String, home: () -> Home) {
        self.title = title
        self.home = home()
    }

    // 🍞 bin/widgeteer/bindings/widget.dart:176
    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        // 🍞 bin/widgeteer/bindings/string.dart:74
        let titleValue = self.title
        // 🍞 bin/widgeteer/bindings/widget.dart:434
        let homeValue = self.home.reduce(parentKey: parentKey.joined("home")).handle
        let localHandle = Flutter_NewMaterialApp(
            parentKey.joined(String(describing: Self.self)),
            titleValue,
            homeValue
        )
        return ReducedWidget(handle: localHandle)
    }
}