// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:72
// GENERATED BY `widgeteer bindings generate` - DO NOT EDIT
// 🍞 bin/widgeteer/bindings/widget.dart:132
// 🍞 bin/widgeteer/bindings/widget.dart:155
public struct StatelessUserWidget: BuiltinWidget {
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:160
    let proxy: StatelessUserWidgetProxy
    let swiftWidgetName: String

    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:173
    public init(proxy: StatelessUserWidgetProxy, swiftWidgetName: String) {
        self.proxy = proxy
        self.swiftWidgetName = swiftWidgetName
    }

    // 🍞 bin/widgeteer/bindings/widget.dart:176
    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        // 🍞 bin/widgeteer/bindings/bridging.dart:67
        let proxyValue = Unmanaged<StatelessUserWidgetProxy>.passRetained(self.proxy).toOpaque()
        // 🍞 bin/widgeteer/bindings/string.dart:74
        let swiftWidgetNameValue = self.swiftWidgetName
        let localHandle = Flutter_NewStatelessUserWidget(
            parentKey.joined(String(describing: Self.self)),
            proxyValue,
            swiftWidgetNameValue
        )
        return ReducedWidget(handle: localHandle)
    }
}