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

/// Perform an equality check on two type-erased widgets.
/// Managed properties are ignored in the comparison (they are always considered equal).
///
/// This function tries its best to use the correct method with the info available at runtime
/// by testing the following methods in order:
///     1. `Equatable` conformance
///     2. `memcmp` if type is POD
///     3. `AnyClass` conformance (compare references)
///     4. Recursive field by field comparison using a `Mirror`
/// Note: a slower `Mirror` is required instead of faster `cachedTypeInfo` because we need the custom `Mirror` representation of enums, lists, tuples and dicts
/// TODO: can we do without and ditch the `Mirror`?
func widgetsEqual(lhs: Any, rhs: Any) -> Bool {
    var lhs = lhs
    var rhs = rhs

    // Type check
    if type(of: lhs) != type(of: rhs) {
        return false
    }

    // Consider managed properties as always equal (entered in recursive call)
    if lhs is ManagedProperty {
        return true
    }

    // Consider closures as never equal (entered in recursive call)
    // XXX: This is a giant hack but we can't do better until Swift
    // has some sort of a "callable" protocol
    if String(describing: type(of: lhs)).contains("->") {
        return false
    }

    // `Equatable` conformance
    if let equatableResult = tryEquatable(lhs: lhs, rhs: rhs) {
        return equatableResult
    }

    // `IsPodable` conformance
    if let podResult = tryPod(lhs: &lhs, rhs: &rhs) {
        return podResult
    }

    // `AnyClass` conformance
    // TODO:    Having a different reference doesn't mean the _value_ is different:
    //          if `===` returns `true` then we know it's the same, however if it returns `false` we
    //          should still compare field by field to see if the _values_ of both references are
    //          the same and prevent an useless `body` call.
    //          We should implement this optimization if we notice a lot of useless `body` calls
    //          on changing observable objects and/or on views with class property wrappers.
    if type(of: rhs) is AnyClass {
        return (lhs as AnyObject) === (rhs as AnyObject)
    }

    // Recursive field by field comparison
    // Also compares enums, lists, tuples and dicts
    let lhsMirror = Mirror(reflecting: lhs)
    let rhsMirror = Mirror(reflecting: rhs)

    // This can happen for enums with different associated values count:
    //      cases with no associated value will have 0 children, cases with associated values
    //      will have 1 child (a tuple containing all associated values), but either way the
    //      type of `lhs` and `rhs` will be the same
    if lhsMirror.children.count != rhsMirror.children.count {
        return false
    }

    return zip(lhsMirror.children, rhsMirror.children).allSatisfy { (lhsChild, rhsChild) in
        let lhs = lhsChild.value
        let rhs = rhsChild.value

        // Ignore managed properties
        if lhs is ManagedProperty {
            return true
        }

        return widgetsEqual(lhs: lhs, rhs: rhs)
    }
}

/// Try to compare `lhs` and `rhs` using an hypothetical `Equatable` conformance
/// on an unknown type. Returns `nil` if type isn't conforming to `Equatable`.
func tryEquatable(lhs: Any, rhs: Any) -> Bool? {
    guard let lhsEquatable = lhs as? any Equatable else { return nil }
    return lhsEquatable.equals(other: rhs)
}

extension Equatable {
    func equals(other: Any) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
}

/// Allows using POD and memory layout features in a type-erased way.
public protocol IsPodable {
    /// Is the type a "Plain Old Data" type?
    var isPod: Bool { get }

    /// Memory size of the type.
    var size: Int { get }
}

/// Try to compare `lhs` and `rhs` using `memcmp` if type is POD.
func tryPod(lhs: inout Any, rhs: inout Any) -> Bool? {
    guard let maybePod = lhs as? IsPodable, maybePod.isPod else {
        return nil
    }

    return withUnsafePointer(to: &lhs) { lhs in
        return withUnsafePointer(to: &rhs) { rhs in
            return memcmp(lhs, rhs, maybePod.size) == 0
        }
    }
}

public extension IsPodable {
    var isPod: Bool {
        return _isPOD(Self.self)
    }

    var size: Int {
        return MemoryLayout<Self>.size
    }
}
