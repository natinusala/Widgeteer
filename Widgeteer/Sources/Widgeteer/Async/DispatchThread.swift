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
import Dispatch

private class DispatchThread: Thread {
    override init() {
        super.init()

        self.name = "widgeteer.dispatch_main"
    }

    override func main() {
        trace("Starting Dispatch thread (\(Thread.current))")

        // Run Dispatch indefinitely
        dispatchMain()
    }
}

private let dispatchThread = DispatchThread()

func startDispatchThread() {
#if !os(macOS) && !os(iOS)
    assert(!dispatchThread.isExecuting)
    dispatchThread.start()
#endif
}
