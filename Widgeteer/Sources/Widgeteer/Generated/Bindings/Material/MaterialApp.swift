// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:95
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/widget.dart:167
// 🍞 bin/widgeteer/bindings/widget.dart:267
public struct MaterialApp<Home: SingleWidget>: DartWidget {
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:209
    let title: String
    let theme: ThemeData?
    let home: Home

    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:222
    public init(title: String = "", theme: ThemeData?, home: () -> Home) {
        self.title = title
        self.theme = theme
        self.home = home()
    }

    // 🍞 bin/widgeteer/bindings/widget.dart:290
    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        // 🍞 bin/widgeteer/bindings/string.dart:149
        let titleValue = self.title
        // 🍞 bin/widgeteer/bindings/persistent_object.dart:351
        let themeValue = self.theme?.handle ?? Dart_Null
        // 🍞 bin/widgeteer/bindings/widget.dart:705
        let homeValue = self.home.reduce(parentKey: parentKey.joined("home")).handle
        let localHandle = Flutter_NewMaterialApp(
        parentKey.joined(String(describing: Self.self)),
        titleValue,
        themeValue,
        homeValue
        )
        let reducedWidget = ReducedWidget(handle: localHandle)
        return reducedWidget
    }
}