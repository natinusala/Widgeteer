// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:91
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/widget.dart:156
// 🍞 bin/widgeteer/bindings/widget.dart:238
public struct Center<Child: SingleWidget>: BuiltinWidget {
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:160
    let child: Child

    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:173
    public init(_ child: () -> Child) {
        self.child = child()
    }

    // 🍞 bin/widgeteer/bindings/widget.dart:261
    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        // 🍞 bin/widgeteer/bindings/widget.dart:608
        let childValue = self.child.reduce(parentKey: parentKey.joined("child")).handle
        let localHandle = Flutter_NewCenter(
            parentKey.joined(String(describing: Self.self)),
            childValue
        )
        let reducedWidget = ReducedWidget(handle: localHandle)
        return reducedWidget
    }
}

// 🍞 bin/widgeteer/bindings/widget.dart:177
// 🍞 bin/widgeteer/bindings/widget.dart:189
struct CenterWrapper: WidgetWrapper {
    public func body(content: Content) -> Center<Content> {
        return Center() { content }
    }
}

// 🍞 bin/widgeteer/bindings/widget.dart:206
public extension Widget {
    func center() -> some Widget {
        return self.wrapped(in: CenterWrapper())
    }
}