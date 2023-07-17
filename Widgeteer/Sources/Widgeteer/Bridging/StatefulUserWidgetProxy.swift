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

public class StatefulUserWidgetProxy: UserWidgetProxy {
    /// Create the state storage for the proxied widget.
    /// Inside a closure to avoid making the whole class generic.
    let createState: () -> UserStateStorage

    override init<Proxied: BuildableWidget>(of widget: Proxied) {
        self.createState = {
            trace("Creating state storage for '\(String(describing: Proxied.self))'")
            return widget.createStateStorage()
        }

        super.init(of: widget)

        trace("New 'StatefulUserWidgetProxy' created for '\(self.widgetName)'")
    }

    deinit {
        trace("Releasing 'StatefulWidgetProxy'")
    }

    /// Called by Flutter to rebuild the proxied widget.
    func build(buildContext: BuildContext, stateStorage: UserStateStorage, parentKey: String) -> LocalWidgetHandle {
        time("Building \(self.widgetName)")

        trace("Installing '\(self.widgetName)'")
        let installed = self.widget.installed(storage: stateStorage, buildContext: buildContext)
        let widget = installed.build( buildContext: buildContext, parentKey: parentKey)
        return widget
    }
}

@_cdecl("widgeteer_stateful_user_widget_proxy_release")
public func _statefulsUserWidgetProxyRelease(_ proxy: UnsafeRawPointer) {
    Unmanaged<StatefulUserWidgetProxy>.fromOpaque(proxy).release()
}

@_cdecl("widgeteer_stateful_user_widget_proxy_build")
public func _statefulsUserWidgetProxyBuild(_ proxy: UnsafeRawPointer, _ buildContext: Dart_Handle, _ storage: UnsafeRawPointer, _ parentKey: UnsafePointer<CChar>) -> LocalWidgetHandle {
    let proxy = Unmanaged<StatefulUserWidgetProxy>.fromOpaque(proxy).takeUnretainedValue()

    let storage = Unmanaged<UserStateStorage>.fromOpaque(storage).takeUnretainedValue()
    let parentKey = String(cString: parentKey)

    return proxy.build(buildContext: buildContext, stateStorage: storage, parentKey: parentKey)
}

@_cdecl("widgeteer_stateful_user_widget_proxy_create_storage")
public func _statefulsUserWidgetProxyBuild(_ proxy: UnsafeRawPointer) -> UnsafeMutableRawPointer {
    let proxy = Unmanaged<StatefulUserWidgetProxy>.fromOpaque(proxy).takeUnretainedValue()
    return Unmanaged.passRetained(proxy.createState()).toOpaque()
}
