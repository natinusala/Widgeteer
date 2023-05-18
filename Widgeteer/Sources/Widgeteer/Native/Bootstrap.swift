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

#if !os(macOS) && !os(iOS)
import Backtrace
#endif

/// Very first function to be called in the bootstrap sequence.
@_cdecl("widgeteer_init")
public func _init(data: UnsafeMutableRawPointer) {
#if !os(macOS) && !os(iOS)
    Backtrace.install()
#endif

    trace("Initializing Widgeteer")
    startDispatchThread()
    markFlutterThread()

    let apiData = data.assumingMemoryBound(to: DartApi.self).pointee
    log("Host Dart version: \(apiData.major).\(apiData.minor)")
    log("Widgeteer Dart version: \(DART_API_DL_MAJOR_VERSION).\(DART_API_DL_MINOR_VERSION)")

    guard apiData.major == DART_API_DL_MAJOR_VERSION, apiData.minor == DART_API_DL_MINOR_VERSION else {
        fatalError("Dart API DL version mismatch")
    }

    let result = Dart_InitializeApiDL(data)
    guard result == 0 else {
        fatalError("'Dart_InitializeApiDL' returned '\(result)'")
    }
}

private var globalPersistentNull: Dart_PersistentHandle?

@_cdecl("widgeteer_set_null_handle")
public func _setNullHandle(_ nullObjectHandle: Dart_Handle) {
    assertIsOnFlutterThread()

    assert(globalPersistentNull == nil, "'widgeteer_set_null_handle' called twice, leaking the first handle")

    guard let persistentNull = Dart_NewPersistentHandle_DL(nullObjectHandle) else {
        fatalError("Could not make the null handle persistent")
    }

    globalPersistentNull = persistentNull
}

/// Persistent `null` object handle. Use in place of any handle when calling back to
/// Dart if you want to return `null` instead (if the function takes `Object?` for that parameter).
///
/// Originally an `Object?` instance, it is safe to cast to any optional type in Dart
/// since its value is guaranteed to always be `null`.
var Dart_Null: Dart_PersistentHandle {
    guard let handle = globalPersistentNull else {
        fatalError("Tried to access 'Dart_Null' before 'widgeteer_set_null_handle' was called")
    }

    return handle
}
