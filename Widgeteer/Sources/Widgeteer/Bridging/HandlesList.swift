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

import DartApiDl

/// An array of Dart handles.
///
/// Because Dart FFI doesn't support converting `Dart_Handle` C arrays to Dart objects,
/// and doesn't support `Dart_Handle` inside structs either, we are forced to make a
/// Swift class to consume each array element one by one (which is inefficient).
///
/// Warning: this class doesn't have a dedicated release function. Objects will be automatically released
/// by Swift when their references go out of scope. As such, the opaque pointer should NOT escape the called
/// function on the Dart side, since it will point to garbage once the function returns.
class HandlesList {
    let handles: [Dart_Handle]

    init(handles: [Dart_Handle]) {
        self.handles = handles
    }
}

@_cdecl("widgeteer_handles_list_count")
public func _handlesListCount(_ list: UnsafeRawPointer) -> Int {
    let list = Unmanaged<HandlesList>.fromOpaque(list).takeUnretainedValue()
    return list.handles.count
}

@_cdecl("widgeteer_handles_list_get")
public func _handlesListGet(_ list: UnsafeRawPointer, _ idx: Int) -> Dart_Handle {
    let list = Unmanaged<HandlesList>.fromOpaque(list).takeUnretainedValue()
    return list.handles[idx]
}
