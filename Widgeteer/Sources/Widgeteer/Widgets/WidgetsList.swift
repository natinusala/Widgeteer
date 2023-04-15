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

public protocol AccumulatedWidget {
    /// Used to compute the key.
    var position: Int { get }
}

public struct EmptyWidgetsList: MultiWidget {
    public func reduce(parentKey: WidgetKey) -> [ReducedWidget] {
        return []
    }
}

public struct WidgetsListFirst<Content: Widget>: Widget, AccumulatedWidget {
    public var position: Int

    let content: Content

    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        return content.reduce(parentKey: parentKey.joined("\(self.position)"))
    }

    public func reduce(parentKey: WidgetKey) -> [ReducedWidget] {
        return content.reduce(parentKey: parentKey.joined("\(self.position)"))
    }

    public var body: Never {
        fatalError("'WidgetsListFirst' does not have a body")
    }
}

public struct WidgetsList<Accumulated: MultiWidget, Next: MultiWidget>: MultiWidget, AccumulatedWidget {
    let accumulated: Accumulated
    let next: Next

    public let position: Int

    public func reduce(parentKey: WidgetKey) -> [ReducedWidget] {
        return self.accumulated.reduce(parentKey: parentKey) + self.next.reduce(parentKey: parentKey.joined("\(self.position)"))
    }
}

public struct WidgetsArray<Content: Widget>: MultiWidget {
    let array: [Content]

    public func reduce(parentKey: WidgetKey) -> [ReducedWidget] {
        return self.array.enumerated().map { offset, content in
            return content.reduce(parentKey: parentKey.joined("\(offset)"))
        }
    }

    public var body: Never {
        fatalError("'WidgetsArray' does not have a body")
    }
}

public struct OptionalMultiWidget<Content: Widget>: MultiWidget {
    let content: Content?

    public func reduce(parentKey: WidgetKey) -> [ReducedWidget] {
        if let content {
            return content.reduce(parentKey: parentKey)
        } else {
            return []
        }
    }
}
