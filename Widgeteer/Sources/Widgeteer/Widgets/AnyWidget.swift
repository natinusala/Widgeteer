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

/// A type-erased widget.
public struct AnyWidget: Widget {
    let widget: any Widget

    public init(_ widget: any Widget) {
        self.widget = widget
    }

    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        trace("Reducing '\(type(of: widget))' erased by '\(Self.self)'")
        return self.widget.reduce(parentKey: parentKey)
    }

    public var body: Never {
        fatalError("'AnyWidget' does not have a body")
    }
}
