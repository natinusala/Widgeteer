// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:91
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/widget.dart:162
// 🍞 bin/widgeteer/bindings/widget.dart:265
public struct Directionality<Child: SingleWidget>: BuiltinWidget {
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:209
    let textDirection: TextDirection
    let child: Child

    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:222
    public init(textDirection: TextDirection, child: () -> Child) {
        self.textDirection = textDirection
        self.child = child()
    }

    // 🍞 bin/widgeteer/bindings/widget.dart:288
    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        // 🍞 bin/widgeteer/bindings/enum.dart:119
        let textDirectionValue = self.textDirection.rawValue
        // 🍞 bin/widgeteer/bindings/widget.dart:701
        let childValue = self.child.reduce(parentKey: parentKey.joined("child")).handle
        let localHandle = Flutter_NewDirectionality(
            parentKey.joined(String(describing: Self.self)),
            textDirectionValue,
            childValue
        )
        let reducedWidget = ReducedWidget(handle: localHandle)
        return reducedWidget
    }
}