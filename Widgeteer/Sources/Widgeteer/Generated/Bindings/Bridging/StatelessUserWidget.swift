// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:91
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/widget.dart:159
// 🍞 bin/widgeteer/bindings/widget.dart:241
public struct StatelessUserWidget: BuiltinWidget {
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:207
    let proxy: StatelessUserWidgetProxy
    let swiftWidgetName: String

    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:220
    public init(proxy: StatelessUserWidgetProxy, swiftWidgetName: String) {
        self.proxy = proxy
        self.swiftWidgetName = swiftWidgetName
    }

    // 🍞 bin/widgeteer/bindings/widget.dart:264
    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        // 🍞 bin/widgeteer/bindings/bridging.dart:67
        let proxyValue = Unmanaged<StatelessUserWidgetProxy>.passRetained(self.proxy).toOpaque()
        // 🍞 bin/widgeteer/bindings/string.dart:79
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