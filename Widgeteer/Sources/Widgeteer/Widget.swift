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

public typealias BuildContext = Void

/// A handle to a Flutter widget in the local scope.
public typealias LocalWidgetHandle = Dart_Handle

/// Result of a widget reduction.
public struct ReducedWidget {
    let handle: LocalWidgetHandle
}

/// A widget that's reduced to a single Flutter widget.
public protocol SingleWidget {
    /// Reduce the widget to a Flutter widget.
    func reduce(parentKey: WidgetKey) -> ReducedWidget
}

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
    // func installed(storage: StateStorage?, buildContext: BuildContext) -> Self
    // func isStateful() -> Bool
    // func createStateStorage() -> StateStorage
}

/// A widget that can be built by Flutter when needed.
public protocol BuildableWidget: IsPodable, InstallableWidget {
    /// Called by Flutter when the widget needs to be rebuilt.
    // func build(parentKey: String, buildContext: BuildContext) -> LocalWidgetHandle
}

/// A widget that's reduced to a built in Flutter widget.
public protocol BuiltinWidget: Widget {}

public extension SingleWidget {
    func reduce(parentKey: WidgetKey) -> [ReducedWidget] {
        return [self.reduce(parentKey: parentKey)]
    }
}

public extension BuiltinWidget {
    var body: Never {
        fatalError("Builtin widgets do not have a body")
    }

    func build(parentKey: String, buildContext: BuildContext) -> LocalWidgetHandle {
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
