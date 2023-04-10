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

private var flutterThread: Thread?

// Permanently mark the current thread as the "Flutter main thread".
func markFlutterThread() {
    assert(flutterThread == nil)
    flutterThread = Thread.current

    trace("Thread '\(Thread.current)' marked as Flutter main thread")
}

// Ensure the current thread is the Flutter main thread.
// TODO: switch to package access level (SE-0386)
public func assertIsOnFlutterThread() {
    assert(flutterThread != nil, "Flutter thread not marked, has Widgeteer been initialized?")
    assert(isOnFlutterThread(), "Expected to be on Flutter thread, is on '\(Thread.current)' instead")
}

func isOnFlutterThread() -> Bool {
    assert(flutterThread != nil)
    return Thread.current == flutterThread!
}
