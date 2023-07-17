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

public extension BuildableWidget {
    func reduce(parentKey: WidgetKey) -> ReducedWidget {
        let widgetName = String(describing: Self.self) // TODO: add #file to account for private structs

        if self.isStateful() {
            return StatefulUserWidget(
                proxy: StatefulUserWidgetProxy(of: self),
                swiftWidgetName: widgetName
            ).reduce(parentKey: parentKey)
        } else {
            return StatelessUserWidget(
                proxy: StatelessUserWidgetProxy(of: self),
                swiftWidgetName: widgetName
            ).reduce(parentKey: parentKey)
        }
    }
}

public extension Widget {
    func build(buildContext: BuildContext, parentKey: String) -> LocalWidgetHandle {
        trace("Building '\(Self.self)'")
        return self.body.reduce(parentKey: parentKey).handle
    }
}

public extension InstallableWidget {
    // Default installation method: install the widget itself.
    func installed(storage: UserStateStorage?, buildContext: BuildContext) -> Self {
        log("Installing '\(Self.self)'")

        var installed = self

        storage?.installState(on: &installed)
        buildContext.installEnvironment(on: &installed)

        return installed
    }

    // Default state storage: get properties from self.
    func createStateStorage() -> UserStateStorage {
        return UserStateStorage(from: self)
    }
}
