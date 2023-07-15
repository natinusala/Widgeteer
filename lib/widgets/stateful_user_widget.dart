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

import 'package:flutter/widgets.dart';

import '../dylib.dart';
import '../runtime_types.dart';

class StatefulUserWidget extends StatefulWidget {
  final StatefulUserWidgetProxy proxy;

  late final UserWidgetRuntimeType _runtimeType;

  StatefulUserWidget(String swiftWidgetName, {super.key, required this.proxy}) {
    _runtimeType = UserWidgetRuntimeType(swiftWidgetName: swiftWidgetName);
  }

  @override
  // ignore: no_logic_in_create_state
  State createState() {
    final storage = UserStateStorage(libWidgeteer
        .stateful_user_widget_proxy_create_storage(proxy.nativeProxy));
    final state = UserWidgetState(storage: storage);

    libWidgeteer.state_storage_bind_state(storage.nativeStorage, state);
    return state;
  }

  @override
  Type get runtimeType => _runtimeType;

  @override
  // ignore: invalid_override_of_non_virtual_member
  int get hashCode => throw "Unimplemented";

  @override
  // ignore: invalid_override_of_non_virtual_member
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is StatefulUserWidget &&
        libWidgeteer.user_widget_proxy_equals(
            proxy.nativeProxy, other.proxy.nativeProxy);
  }
}

/// Called by Swift to mark the state of a Swift widget as dirty.
void touchState(Object state) {
  (state as UserWidgetState).touchState();
}
