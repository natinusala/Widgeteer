/*
   Copyright 2023 natinusala

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import DartApiDl

/// Local handle to the build context.
/// Becomes invalid after the call to `build`, do not let it escape out of scope.
public typealias BuildContext = Dart_Handle

/// A handle to a Flutter widget in the local scope.
public typealias LocalWidgetHandle = Dart_Handle

/// Result of a widget reduction.
public struct ReducedWidget {
    let handle: LocalWidgetHandle
}

/// A widget that's reduced to a single optional Flutter widget.
/// ``Dart_Null`` is allowed as a return value.
public protocol OptionalSingleWidget {
    /// Reduce the widget to a Flutter widget.
    func reduce(parentKey: WidgetKey) -> ReducedWidget
}

/// A widget that's reduced to a single Flutter widget.
/// ``Dart_Null`` is NOT allowed as a return value.
public protocol SingleWidget: OptionalSingleWidget, MultiWidget {}

/// A widget that's reduced to multiple Flutter widgets.
public protocol MultiWidget: IsPodable {
    /// Reduce the widget to multiple Flutter widgets.
    func reduce(parentKey: WidgetKey) -> [ReducedWidget]
}

/// A widget.
public protocol Widget: SingleWidget, BuildableWidget, InstallableWidget {
    associatedtype Body: Widget

    @SingleWidgetBuilder var body: Body { get }
}

public protocol InstallableWidget {
    func installed(storage: UserStateStorage?, buildContext: BuildContext) -> Self
    func isStateful() -> Bool
    func createStateStorage() -> UserStateStorage
}

/// A widget that can be built by Flutter when needed.
public protocol BuildableWidget: IsPodable, InstallableWidget {
    /// Called by Flutter when the widget needs to be rebuilt.
    func build(buildContext: BuildContext, parentKey: String) -> LocalWidgetHandle
}

/// A Flutter widget that's defined in Dart, such as built in widgets
/// or widgets coming from an external library.
public protocol DartWidget: Widget {}

public extension SingleWidget {
    func reduce(parentKey: WidgetKey) -> [ReducedWidget] {
        return [self.reduce(parentKey: parentKey)]
    }
}

public extension DartWidget {
    var body: Never {
        fatalError("Builtin widgets do not have a body")
    }

    func build(buildContext: BuildContext, parentKey: String) -> LocalWidgetHandle {
        fatalError("Builtin widgets cannot be built")
    }
}

/// "Key" of a widget, in the Flutter sense.
///
/// All widgets have a key that is computed during the reduction
/// process to achieve structural identity.
public typealias WidgetKey = String

extension WidgetKey {
    func joined(_ childKey: WidgetKey) -> WidgetKey {
        if self.isEmpty {
            return childKey
        }

        return "\(self).\(childKey)"
    }
}

/// A property which value is managed by either Flutter or Widgeteer.
public protocol ManagedProperty: IsPodable {}

public class UserWidgetProxy {
    let widget: any BuildableWidget
    let widgetType: any BuildableWidget.Type

    init<Proxied: BuildableWidget>(of widget: Proxied) {
        self.widget = widget
        self.widgetType = Proxied.self
    }

    var widgetName: String {
        return String(describing: self.widgetType)
    }

    /// Return `true` if the widget held by this proxy is equal to the
    /// widget held by the given proxy.
    func equals(other: Any) -> Bool {
        guard let other = other as? Self else { return false }

        return widgetsEqual(lhs: self.widget, rhs: other.widget)
    }
}

@_cdecl("widgeteer_user_widget_proxy_equals")
public func _userWidgetProxyEquals(_ lhs: UnsafeRawPointer, _ rhs: UnsafeRawPointer) -> Bool {
    let lhs = Unmanaged<UserWidgetProxy>.fromOpaque(lhs).takeUnretainedValue()
    let rhs = Unmanaged<UserWidgetProxy>.fromOpaque(rhs).takeUnretainedValue()

    // Don't bother checking for value equality if the proxy is identical then we already know the widget is the same
    // This is also to handle cases where Flutter asserts that the current widget
    // is the same as the new one after an update (widgets with closures would always return `false`,
    // tripping the assertion)
    if lhs === rhs {
        trace("Skipping equality check of '\(lhs.widgetType)': proxy is identical")
        return true
    }

    let equals = lhs.equals(other: rhs)
    trace("Equality of '\(lhs.widgetType)': \(equals)")
    return equals
}

// MARK: Constrained built in widget protocols

public protocol PreferredSizeWidget: DartWidget {}
