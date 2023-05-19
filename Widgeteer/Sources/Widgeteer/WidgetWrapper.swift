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

/// A lighter kind of widget modifier that has no state or input.
///
/// Removes the need for a container widget with a `build()` call but
/// also removes the ability to have any state or input properties.
/// TODO: add a check in debug mode that it has no managed properties (say to use a modifier instead)
public protocol WidgetWrapper: WidgetModifier {}

public struct WrappedWidget<Content: Widget, Wrapper: WidgetWrapper>: Widget {
    let content: Content
    let wrapper: Wrapper

    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        let content = AnyWidget(self.content)
        return self.wrapper.reduce(parentKey: parentKey, content: content)
    }

    public var body: Never {
        fatalError("'WrappedWidget' does not have a body")
    }
}

public extension SingleWidget {
    func wrapped<Wrapper: WidgetWrapper>(in wrapper: Wrapper) -> WrappedWidget<Self, Wrapper> {
        return WrappedWidget(content: self, wrapper: wrapper)
    }
}
