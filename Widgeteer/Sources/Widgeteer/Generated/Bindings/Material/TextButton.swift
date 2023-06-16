// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:91
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/widget.dart:156
// 🍞 bin/widgeteer/bindings/widget.dart:238
public struct TextButton<Child: SingleWidget>: BuiltinWidget {
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:165
    let onPressed: VoidCallback?
    let child: Child

    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:178
    public init(onPressed: VoidCallback? = nil, _ child: () -> Child) {
        self.onPressed = onPressed
        self.child = child()
    }

    // 🍞 bin/widgeteer/bindings/widget.dart:261
    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        // 🍞 bin/widgeteer/bindings/callback.dart:228
        let onPressedValue: UnsafeMutableRawPointer?
        if let onPressedClosure = self.onPressed {
            onPressedValue = Unmanaged<VoidCallbackProxy>.passRetained(VoidCallbackProxy(onPressedClosure)).toOpaque()
        } else {
            onPressedValue = nil
        }
        // 🍞 bin/widgeteer/bindings/widget.dart:619
        let childValue = self.child.reduce(parentKey: parentKey.joined("child")).handle
        let localHandle = Flutter_NewTextButton(
            parentKey.joined(String(describing: Self.self)),
            onPressedValue,
            childValue
        )
        let reducedWidget = ReducedWidget(handle: localHandle)
        return reducedWidget
    }
}