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

public struct Color: ExpressibleByIntegerLiteral {
    /// ARGB color value.
    let value: Int

    public init(_ value: Int) {
        self.value = value
    }

    public init(integerLiteral: Int) {
        self = Color(integerLiteral)
    }

    public static func argb(_ value: Int) -> Color {
        return Color(value)
    }

    public static func rgb(_ value: Int) -> Color {
        return Color(0xFF000000 | value)
    }

    public static let white = Color(0xFFFFFFFF)
    public static let black = Color(0xFF000000)
    public static let red = Color(0xFFFF0000)
    public static let green = Color(0xFF00FF00)
    public static let blue = Color(0xFF0000FF)
}
