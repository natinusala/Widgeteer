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

/// Inflate the given widget and attach it to the screen.
///
/// Once the bootstrap sequence is finished, Flutter will call `widgeteer_run()`
/// which is is the only C exposed method in the Swift app library.
/// Inside, users should call ``runApp(_:)``, giving the root widget to use for their app.
public func runApp<Root: Widget>(_ root: Root) {
    trace("Running app")

    assertIsOnFlutterThread()

    // Use a unique timestamp as root key to prevent Flutter from reusing anything
    // after a hot restart
    let now = Date()
    let parentKey = String(describing: now.timeIntervalSince1970).joined(String(describing: Root.self))

    trace("Using '\(parentKey)' as key for top level widget")

    let localApp = root.reduce(parentKey: parentKey).handle
    Flutter_RunApp(localApp)
}
