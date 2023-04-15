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

@resultBuilder
public struct SingleWidgetBuilder {
    public static func buildBlock<W0: Widget>(_ w0: W0) -> W0 {
        return w0
    }

    public static func buildEither<First: Widget, Second: Widget>(first: First) -> ConditionalWidget<First, Second> {
        return .first(first)
    }

    public static func buildEither<First: Widget, Second: Widget>(second: Second) -> ConditionalWidget<First, Second> {
        return .second(second)
    }
}

@resultBuilder
public struct MultiWidgetBuilder {
    public static func buildBlock() -> EmptyWidgetsList {
        return EmptyWidgetsList()
    }

    public static func buildBlock<W0: Widget>(_ w0: W0) -> W0 {
        return w0
    }

    public static func buildPartialBlock<Content>(first content: Content) -> WidgetsListFirst<Content> where Content: Widget {
        return WidgetsListFirst(position: 0, content: content)
    }

    public static func buildPartialBlock<Accumulated, Next>(accumulated: Accumulated, next: Next) -> WidgetsList<Accumulated, Next> where Accumulated: MultiWidget & AccumulatedWidget, Next: MultiWidget {
        return WidgetsList(accumulated: accumulated, next: next, position: accumulated.position + 1)
    }

    public static func buildOptional<Content>(_ content: Content?) -> OptionalMultiWidget<Content> {
        return OptionalMultiWidget<Content>(content: content)
    }

    public static func buildArray<Content: Widget>(_ content: [Content]) -> WidgetsArray<Content> {
        return WidgetsArray(array: content)
    }

    public static func buildEither<First: Widget, Second: Widget>(first: First) -> ConditionalWidget<First, Second> {
        return .first(first)
    }

    public static func buildEither<First: Widget, Second: Widget>(second: Second) -> ConditionalWidget<First, Second> {
        return .second(second)
    }
}

public enum ConditionalWidget<First: Widget, Second: Widget>: Widget {
    case first(First)
    case second(Second)

    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        switch self {
            case .first(let first):
                return first.reduce(parentKey: parentKey.joined("first"))
            case .second(let second):
                return second.reduce(parentKey: parentKey.joined("second"))
        }
    }

    public func reduce(parentKey: WidgetKey) -> [ReducedWidget] {
        switch self {
            case .first(let first):
                return first.reduce(parentKey: parentKey.joined("first"))
            case .second(let second):
                return second.reduce(parentKey: parentKey.joined("second"))
        }
    }

    public var body: Never {
        fatalError("'ConditionalWidget' does not have a body")
    }
}
