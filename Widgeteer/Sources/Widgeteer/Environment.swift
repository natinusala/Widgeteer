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

/// An environment property.
///
/// It can be a built-in property from the Flutter build context,
/// or a user-defined one.
@propertyWrapper
public struct Environment<Value> {
    let keyPath: KeyPath<EnvironmentValues, Value>

    /// Current value.
    /// May be `nil` if the property hasn't been installed yet.
    let value: Value?

    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
        self.value = nil
    }

    public var wrappedValue: Value {
        guard let value else {
            fatalError("Environment property integrity error: accessing wrapped value of non-installed property")
        }

        return value
    }
}

/// Proxy to get environment values from a build context using
/// a key path as accessor.
public struct EnvironmentValues {
    let buildContext: BuildContext

    public var theme: ThemeData {
        assertIsOnFlutterThread()
        return ThemeData(persisting: Flutter_ThemeOf(buildContext))
    }
}
