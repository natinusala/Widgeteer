// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:95
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/widget.dart:167
// 🍞 bin/widgeteer/bindings/widget.dart:270
public struct Scaffold<AppBar: PreferredSizeWidget, FloatingActionButton: OptionalSingleWidget, Body: SingleWidget>: DartWidget {
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:209
    let body: Body
    let appBar: AppBar
    let floatingActionButton: FloatingActionButton

    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:222
    public init(_ body: () -> Body, appBar: (() -> AppBar) = { EmptyWidget() }, floatingActionButton: (() -> FloatingActionButton) = { EmptyWidget() }) {
        self.body = body()
        self.appBar = appBar()
        self.floatingActionButton = floatingActionButton()
    }

    // 🍞 bin/widgeteer/bindings/widget.dart:293
    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        // 🍞 bin/widgeteer/bindings/widget.dart:715
        let bodyValue = self.body.reduce(parentKey: parentKey.joined("body")).handle
        // 🍞 bin/widgeteer/bindings/widget.dart:715
        let appBarValue = self.appBar.reduce(parentKey: parentKey.joined("appBar")).handle
        // 🍞 bin/widgeteer/bindings/widget.dart:715
        let floatingActionButtonValue = self.floatingActionButton.reduce(parentKey: parentKey.joined("floatingActionButton")).handle
        let localHandle = Flutter_NewScaffold(
            parentKey.joined(String(describing: Self.self)),
            bodyValue,
            appBarValue,
            floatingActionButtonValue
        )
        let reducedWidget = ReducedWidget(handle: localHandle)
        return reducedWidget
    }
}