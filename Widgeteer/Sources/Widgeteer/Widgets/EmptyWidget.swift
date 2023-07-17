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

/// A widget that reduces to "no widget" on the Flutter side (aka. a `null` widget).
/// Always returns ``Dart_Null`` in the reduction function.
///
/// This widget is the only one that conforms to ``OptionalSingleWidget`` and is
/// allowed to return ``Dart_Null``.
public struct EmptyWidget: OptionalSingleWidget, DartWidget, PreferredSizeWidget {
    public init() {}

    public func reduce(parentKey: WidgetKey) -> ReducedWidget {
        return ReducedWidget(handle: Dart_Null)
    }
}
