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

public class StatelessUserWidgetProxy: WidgetProxy {
    override init<Proxied: BuildableWidget>(of widget: Proxied) {
        super.init(of: widget)

        trace("New 'StatelessWidgetProxy' created for '\(self.widgetName)'")
    }

    deinit {
        trace("'StatelessWidgetProxy' released for '\(self.widgetName)'")
    }

    func build(parentKey: String, buildContext: BuildContext) -> LocalWidgetHandle {
        time("Building \(self.widgetName)")

        trace("Installing '\(self.widgetName)'")
        let installed = self.widget.installed(storage: nil, buildContext: buildContext)
        let widget = installed.build(parentKey: parentKey, buildContext: buildContext)
        return widget
    }
}

@_cdecl("widgeteer_stateless_user_widget_proxy_release")
public func _statelessUserWidgetProxyRelease(_ proxy: UnsafeRawPointer) {
    Unmanaged<StatelessUserWidgetProxy>.fromOpaque(proxy).release()
}

@_cdecl("widgeteer_stateless_user_widget_proxy_build")
public func _statelessUserWidgetProxyBuild(_ proxy: UnsafeRawPointer, _ parentKey: UnsafePointer<CChar>, _ buildContext: Dart_Handle) {
    // TODO: reinstate BuildContext and implement this
    fatalError("Unimplemented")
}
