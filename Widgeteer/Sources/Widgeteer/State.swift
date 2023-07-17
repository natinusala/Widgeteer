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
import Runtime
import DartApiDl

protocol StateProperty: ManagedProperty {
    var anyInitialValue: Any { get }

    func installed(location: StateLocation) -> Any
}

@propertyWrapper
public struct State<Value>: StateProperty {
    let initialValue: Value
    let location: StateLocation?

    public var wrappedValue: Value {
        get {
            if let location {
                guard let value = location.get() as? Value else {
                    fatalError("State property integrity error: storage holds a value of the wrong type (expected '\(Value.self)', found '\(type(of: location.get()))')")
                }

                return value
            }

            return self.initialValue
        }
        nonmutating set {
            guard let location else {
                fatalError("State property integrity error: tried to set a value on a non-installed property")
            }

            location.set(newValue)
        }
    }

    public init(wrappedValue: Value) {
        self.initialValue = wrappedValue
        self.location = nil
    }

    init(initialValue: Value, location: StateLocation) {
        self.initialValue = initialValue
        self.location = location
    }

    func installed(location: StateLocation) -> Any {
        return Self(initialValue: self.initialValue, location: location)
    }

    var anyInitialValue: Any {
        return self.initialValue
    }
}

/// Handle to get and set a state property.
/// Contains the underlying storage (held by a Flutter state object)
/// and the position of the property inside this storage.
struct StateLocation {
    let storage: UserStateStorage
    let position: Int

    func set(_ value: Any) {
        self.storage.set(value, at: self.position)
    }

    func get() -> Any {
        return self.storage.get(at: self.position)
    }
}

/// Stores all state properties of a widget. Held by a `UserWidgetState` object
/// on the Flutter side.
public class UserStateStorage {
    struct Entry {
        let property: PropertyInfo
        let value: Any
    }

    let lock = NSLock()
    let widgetType: any InstallableWidget.Type

    /// Has state changed since the last touch?
    private var isDirty = false

    /// State properties tracked by this storage instance.
    private var entries: [Entry] = []

    /// Weak persistent handle to the Flutter `UserWidgetState` counterpart.
    /// Used to touch it to notify Flutter that the state has changed.
    var dartStateHandle: Dart_PersistentHandle?

    init<W: InstallableWidget>(from widget: W) {
        self.widgetType = W.self

        // TODO: cache an initial state storage for the type to clone instead of parsing properties every time
        let info = tryTo("read type info of '\(W.self)'", { try typeInfo(of: W.self) }) // TODO: use cached metadata
        for property in info.properties {
            if let entry = tryTo("read property '\(property.name)' of '\(W.self)'", { try property.get(from: widget) }) as? any StateProperty {
                self.entries.append(Entry(property: property, value: entry.anyInitialValue))
            }
        }

        assert(!self.entries.isEmpty, "Did not find any state properties for '\(W.self)', a stateless widget should have been used")
    }

    func get(at position: Int) -> Any {
        return self.lock.performLocked {
            return self.entries[position].value
        }
    }

    func set(_ value: Any, at position: Int) {
        self.lock.performLocked {
            // TODO: check for inequality before continuing

            trace("Set storage property at position \(position)")
            self.entries[position] = Entry(property: self.entries[position].property, value: value)

            if !self.isDirty {
                trace("Marking storage as dirty, state flushing is scheduled")
                self.isDirty = true

                Flutter_Schedule(scoped: false) { [weak self] synchronous in
                    guard let self else { return }

                    guard let dartStateHandle = self.dartStateHandle else {
                        fatalError("State storage integrity error: trying to touch state on unbound storage")
                    }

                    trace("Touching state")
                    Flutter_TouchState(dartStateHandle)

                    // Only lock in case we are running asynchronously to
                    // prevent a deadlock

                    if !synchronous {
                        self.lock.lock()
                    }

                    assert(self.isDirty)
                    self.isDirty = false

                    if !synchronous {
                        self.lock.unlock()
                    }
                }
            }
        }
    }

    func installState<Installed: InstallableWidget>(on widget: inout Installed) {
        self.lock.performLocked {
            assert(type(of: widget) == self.widgetType)

            trace("Installing state")

            tryTo("install state properties") {
                var position = 0
                for entry in self.entries {
                    guard let current = try entry.property.get(from: widget) as? StateProperty else {
                        fatalError("State storage integrity error: tracking a property wrapper of the wrong type")
                    }

                    trace("Installing property '\(entry.property.name)' at position \(position)")

                    let location = StateLocation(storage: self, position: position)
                    let new = current.installed(location: location)
                    try entry.property.set(value: new, on: &widget)

                    position += 1
                }
            }
        }
    }

    deinit {
        if let dartStateHandle {
            trace("Deleting Dart state handle from 'deinit'")
            Dart_DeleteWeakPersistentHandle_DL(dartStateHandle)
        }
    }
}

/// Called by Flutter to bind the created `UserWidgetState` instance to the Swift
/// state storage.
@_cdecl("widgeteer_user_state_storage_bind_state")
public func _userStateStorageBindState(_ storagePtr: UnsafeRawPointer, _ state: Dart_Handle) {
    trace("Binding state storage")

    let storage = Unmanaged<UserStateStorage>.fromOpaque(storagePtr).takeUnretainedValue()
    assert(storage.dartStateHandle == nil)

    let mutableStoragePtr = UnsafeMutableRawPointer(mutating: storagePtr)

    // Create a new weak persistent handle to deinit the Swift class when the Dart state is GC'd
    storage.dartStateHandle = Dart_NewWeakPersistentHandle_DL(
        state,
        mutableStoragePtr,
        0,
        { isolate_callback_data, peer in
            guard let peer else {
                fatalError("State weak persistent handle finalizer called without 'peer'")
            }

            trace("Deleting Dart state handle from finalizer")

            let storage = Unmanaged<UserStateStorage>.fromOpaque(peer).takeUnretainedValue()
            assert(storage.dartStateHandle != nil)

            Dart_DeleteWeakPersistentHandle_DL(storage.dartStateHandle)
            storage.dartStateHandle = nil
        }
    )
}

@_cdecl("widgeteer_user_state_storage_release")
public func _userStateStorageRelease(_ storage: UnsafeRawPointer) {
    trace("Releasing Swift state storage")
    Unmanaged<UserStateStorage>.fromOpaque(storage).release()
}

extension InstallableWidget {
    // TODO: cache that info
    public func isStateful() -> Bool {
        let info = tryTo("read type info of '\(Self.self)'", { try typeInfo(of: Self.self) }) // TODO: use cached metadata
        for property in info.properties {
            if tryTo("read property '\(property.name)' of '\(Self.self)'", { try property.get(from: self) }) is any StateProperty {
                return true
            }
        }
        return false
    }
}
