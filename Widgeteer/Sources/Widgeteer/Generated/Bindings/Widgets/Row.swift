// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:91
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings/widget.dart:167
// 🍞 bin/widgeteer/bindings/widget.dart:270
public struct Row<Children: MultiWidget>: BuiltinWidget {
    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:209
    let mainAxisAlignment: MainAxisAlignment
    let children: Children

    // 🍞 bin/widgeteer/bindings_generator/models/parameter.dart:222
    public init(mainAxisAlignment: MainAxisAlignment = .start, @MultiWidgetBuilder _ children: () -> Children) {
        self.mainAxisAlignment = mainAxisAlignment
        self.children = children()
    }

    // 🍞 bin/widgeteer/bindings/widget.dart:293
    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        // 🍞 bin/widgeteer/bindings/enum.dart:119
        let mainAxisAlignmentValue = self.mainAxisAlignment.rawValue
        // 🍞 bin/widgeteer/bindings/widget.dart:644
        let childrenList = HandlesList(handles: self.children.reduce(parentKey: parentKey.joined("children")).map(\.handle))
        let childrenUnmanaged = Unmanaged<HandlesList>.passRetained(childrenList)
        let childrenValue = childrenUnmanaged.toOpaque()
        let localHandle = Flutter_NewRow(
            parentKey.joined(String(describing: Self.self)),
            mainAxisAlignmentValue,
            childrenValue
        )
        let reducedWidget = ReducedWidget(handle: localHandle)
        // 🍞 bin/widgeteer/bindings/widget.dart:653
        childrenUnmanaged.release()
        return reducedWidget
    }
}