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

// TODO: reinstate cutelog
// TODO: also allow using Dart Logger for the observatory?

public func log(_ message: String) {
    print(message)
    fflush(stdout) // `flutter run` buffers stdout
}

private let tracingEnabled = true
private let timingEnabled = false

public func trace(_ message: String, file: StaticString = #fileID) {
#if DEBUG
    if tracingEnabled {
        log("[TRACE] (\(file)) \(message)")
    }
#endif
}

func time(_ what: String) {
    // TODO: use Dart Timeline instead
    if timingEnabled {
        let now = Date()
        log("[Time] \(now.timeIntervalSince1970.milliseconds) - \(what)")
    }
}

/// Behaves the same way as `try!` except that it shows a nicer error message in case of failure.
func tryTo<Result>(_ what: @autoclosure () -> String, _ perform: () throws -> Result) -> Result {
    do {
        return try perform()
    } catch {
        fatalError("Failed to \(what()): \(error)")
    }
}
