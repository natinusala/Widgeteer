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

public protocol WidgetModifier: InstallableWidget {
    typealias Content = AnyWidget

    associatedtype Body: Widget

    @SingleWidgetBuilder func body(content: Content) -> Body

    func reduce(parentKey: WidgetKey, content: Content) -> ReducedWidget
}

public extension WidgetModifier {
    func reduce(parentKey: WidgetKey, content: Content) -> ReducedWidget {
        trace("Reducing '\(Self.self)'")
        return self.body(content: content).reduce(parentKey: parentKey)
    }

    func createStateStorage() -> UserStateStorage {
        fatalError("State storage should never be directly created for modifiers")
    }
}

/// Top-level container for a widget modifier.
/// Holds the modifier as well as its content and state.
/// When a modifier's state changes, the ``ModifiedWidget``'s build method is called instead, which
/// then defers everything to the modifier.
///
/// FIXME: As the modified widget holds both the content and the modifier, if only the content changes the
/// whole modifier will be rebuilt and its body will be called again. The modifier's body should not be called again
/// and only the modified content should be updated (one body call per content instance).
/// Verify first that this is something that SwiftUI does before fixing.
/// Maybe use a custom Flutter `Element` with a different equality method to individually check content and modifier?
/// Or wait to see if the virtual tree can resolve this?
public struct ModifiedWidget<Content: Widget, Modifier: WidgetModifier>: Widget, BuildableWidget, InstallableWidget {
    let content: Content
    let modifier: Modifier

    public func build(buildContext: BuildContext, parentKey: String) -> LocalWidgetHandle {
        trace("Building '\(Self.self)'")
        let content = AnyWidget(self.content)
        return self.modifier.reduce(parentKey: parentKey, content: content).handle
    }

    public func installed(storage: UserStateStorage?, buildContext: BuildContext) -> ModifiedWidget<Content, Modifier> {
        return Self(
            content: self.content,
            modifier: self.modifier.installed(storage: storage, buildContext: buildContext)
        )
    }

    public func isStateful() -> Bool {
        trace("Redirecting '\(Self.self)' 'isStateful()' call to '\(Modifier.self)'")
        return self.modifier.isStateful()
    }

    public func createStateStorage() -> UserStateStorage {
        return UserStateStorage(from: self.modifier)
    }

    public var body: Never {
        fatalError("'ModifiedWidget' does not have a body")
    }
}

public extension Widget {
    func modified<Modifier: WidgetModifier>(by modifier: Modifier) -> ModifiedWidget<Self, Modifier> {
        // TODO: remove the need for that assert by removing "WidgetWrapper" conformance to 'WidgetModifier' and duplicate the logic inside
        assert(!(modifier is any WidgetWrapper), "'\(Modifier.self)' is a widget wrapper, please use 'wrapped(in:)' instead of 'modified(by:)'")
        return ModifiedWidget(content: self, modifier: modifier)
    }
}
