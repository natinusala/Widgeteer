// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:95
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/widget.dart:167
// 🍞 bin/widgeteer/bindings/widget.dart:267
public struct StatelessUserWidget: DartWidget {
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:209
    let proxy: StatelessUserWidgetProxy
    let swiftWidgetName: String

    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:222
    public init(proxy: StatelessUserWidgetProxy, swiftWidgetName: String) {
        self.proxy = proxy
        self.swiftWidgetName = swiftWidgetName
    }

    // 🍞 bin/widgeteer/bindings/widget.dart:290
    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        // 🍞 bin/widgeteer/bindings/flutter_bridging.dart:69
        let proxyValue = Unmanaged<StatelessUserWidgetProxy>.passRetained(self.proxy).toOpaque()
        // 🍞 bin/widgeteer/bindings/string.dart:149
        let swiftWidgetNameValue = self.swiftWidgetName
        let localHandle = Flutter_NewStatelessUserWidget(
        parentKey.joined(String(describing: Self.self)),
        proxyValue,
        swiftWidgetNameValue
        )
        let reducedWidget = ReducedWidget(handle: localHandle)
        return reducedWidget
    }
}