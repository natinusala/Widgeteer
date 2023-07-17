// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:95
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/widget.dart:167
// 🍞 bin/widgeteer/bindings/widget.dart:270
public struct FloatingActionButton<Child: SingleWidget>: DartWidget {
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:209
    let onPressed: VoidCallback?
    let tooltip: String?
    let child: Child

    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:222
    public init(onPressed: VoidCallback? = nil, tooltip: String? = nil, _ child: () -> Child) {
        self.onPressed = onPressed
        self.tooltip = tooltip
        self.child = child()
    }

    // 🍞 bin/widgeteer/bindings/widget.dart:293
    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        // 🍞 bin/widgeteer/bindings/callback.dart:228
        let onPressedValue: UnsafeMutableRawPointer?
        if let onPressedClosure = self.onPressed {
            onPressedValue = Unmanaged<VoidCallbackProxy>.passRetained(VoidCallbackProxy(onPressedClosure)).toOpaque()
        } else {
            onPressedValue = nil
        }
        // 🍞 bin/widgeteer/bindings/string.dart:57
        let tooltipUnmanaged = Unmanaged<OptionalValue>.passRetained(OptionalValue(string: self.tooltip))
        let tooltipValue = tooltipUnmanaged.toOpaque()
        // 🍞 bin/widgeteer/bindings/widget.dart:715
        let childValue = self.child.reduce(parentKey: parentKey.joined("child")).handle
        let localHandle = Flutter_NewFloatingActionButton(
            parentKey.joined(String(describing: Self.self)),
            onPressedValue,
            tooltipValue,
            childValue
        )
        let reducedWidget = ReducedWidget(handle: localHandle)
        // 🍞 bin/widgeteer/bindings/string.dart:65
        tooltipUnmanaged.release()
        return reducedWidget
    }
}