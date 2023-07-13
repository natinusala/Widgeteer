// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:91
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/widget.dart:162
// 🍞 bin/widgeteer/bindings/widget.dart:265
public struct AppBar<Title: OptionalSingleWidget>: PreferredSizeWidget {
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:209
    let title: Title

    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:222
    public init(title: (() -> Title) = { EmptyWidget() }) {
        self.title = title()
    }

    // 🍞 bin/widgeteer/bindings/widget.dart:288
    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        // 🍞 bin/widgeteer/bindings/widget.dart:701
        let titleValue = self.title.reduce(parentKey: parentKey.joined("title")).handle
        let localHandle = Flutter_NewAppBar(
            parentKey.joined(String(describing: Self.self)),
            titleValue
        )
        let reducedWidget = ReducedWidget(handle: localHandle)
        return reducedWidget
    }
}