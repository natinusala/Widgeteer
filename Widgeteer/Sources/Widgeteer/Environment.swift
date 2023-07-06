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

import Runtime

protocol EnvironmentProperty: ManagedProperty {
    func installed(values: EnvironmentValues) -> Any
}

/// An environment property.
///
/// It can be a built-in property from the Flutter build context,
/// or a user-defined one.
@propertyWrapper
public struct Environment<Value>: EnvironmentProperty {
    let keyPath: KeyPath<EnvironmentValues, Value>

    /// Current value.
    /// May be `nil` if the property hasn't been installed yet.
    let value: Value?

    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
        self.value = nil
    }

    private init(keyPath: KeyPath<EnvironmentValues, Value>, value: Value) {
        self.keyPath = keyPath
        self.value = value
    }

    public var wrappedValue: Value {
        guard let value else {
            fatalError("Environment property integrity error: accessing wrapped value of non-installed property")
        }

        return value
    }

    func installed(values: EnvironmentValues) -> Any {
        let value = values[keyPath: self.keyPath]
        return Self(keyPath: self.keyPath, value: value)
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

extension BuildContext {
    /// Install environment properties on the given widget.
    func installEnvironment<Installed: InstallableWidget>(on widget: inout Installed) {
        log("Installing environment on '\(Installed.self)'")
        let values = EnvironmentValues(buildContext: self)

        return tryTo("install environment properties on '\(Installed.self)'") {
            let info = try typeInfo(of: Installed.self) // TODO: use cached version

            // TODO: cache what properties are context properties to avoid parsing each time
            for property in info.properties {
                if let contextProperty = try property.get(from: widget) as? EnvironmentProperty {
                    let installed = contextProperty.installed(values: values)
                    try property.set(value: installed, on: &widget)
                    log("Installed '\(property.name)'")
                }
            }
        }
    }
}
