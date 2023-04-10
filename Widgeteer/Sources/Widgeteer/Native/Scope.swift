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

@_cdecl("widgeteer_enter_scope")
public func _enterScope() {
    trace("---------------------------------")
    trace(">>> Entering scope on behalf of Dart")
    trace("---------------------------------")

    assertIsOnFlutterThread()
    Dart_EnterScope_DL()
}

@_cdecl("widgeteer_exit_scope")
public func _exitScope() {
    trace("---------------------------------")
    trace("<<< Exiting scope on behalf of Dart")
    trace("---------------------------------")

    assertIsOnFlutterThread()
    Dart_ExitScope_DL()
}
