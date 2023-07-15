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

import Foundation
import DartApiDl

/// Allows passing an optional value from Swift to Dart for types that cannot
/// have an optional representation in C (such as integer types or floating point numbers...).
///
/// The actual value type needs to be statically known at code generation time to call
/// the right getter function.
///
/// Warning: this class doesn't have a dedicated release function. Objects will be automatically released
/// by Swift when their references go out of scope. As such, the opaque pointer should NOT escape the called
/// function on the Dart side, since it will point to garbage once the function returns.
class OptionalValue {
    enum Value: CustomStringConvertible {
        case double(Double?)
        case string(UnsafeMutablePointer<CChar>?)

        var description: String {
            switch self {
                case .double: return "Double?"
                case .string: return "String?"
            }
        }

        var isSet: Bool {
            switch self {
                case .double(let value): return value != nil
                case .string(let value): return value != nil
            }
        }
    }

    let value: Value

    init(double: Double?) {
        self.value = .double(double)
    }

    init(string: String?) {
        if let string {
            self.value = .string(strdup(string.cString(using: .utf8)!))
        } else {
            self.value = .string(nil)
        }
    }

    deinit {
        if case .string(let value) = self.value, let value {
            free(value)
        }
    }
}

@_cdecl("widgeteer_optional_value_is_set")
public func _optionalValueIsSet(_ value: UnsafeRawPointer) -> Bool {
    let value = Unmanaged<OptionalValue>.fromOpaque(value).takeUnretainedValue()
    return value.value.isSet
}

@_cdecl("widgeteer_optional_value_get_double")
public func _optionalValueGetDouble(_ value: UnsafeRawPointer) -> Double {
    let value = Unmanaged<OptionalValue>.fromOpaque(value).takeUnretainedValue()
    guard case .double(let value) = value.value else {
        fatalError("Tried to get a value from an 'OptionalValue' of the wrong type (expected 'Double?', got '\(value.value.description)')")
    }
    guard let value else {
        fatalError("Tried to get a value from an 'OptionalValue' without a value ('nil)")
    }
    return value
}

@_cdecl("widgeteer_optional_value_get_string")
public func _optionalValueGetString(_ value: UnsafeRawPointer) -> UnsafeMutablePointer<CChar> {
    let value = Unmanaged<OptionalValue>.fromOpaque(value).takeUnretainedValue()
    guard case .string(let value) = value.value else {
        fatalError("Tried to get a value from an 'OptionalValue' of the wrong type (expected 'String?', got '\(value.value.description)')")
    }
    guard let value else {
        fatalError("Tried to get a value from an 'OptionalValue' without a value ('nil)")
    }
    return value
}
