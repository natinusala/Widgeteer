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

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/widgets.dart';
import 'package:widgeteer/generated/lib_widgeteer.dart';

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
    final state = UserWidgetState(storage);

    libWidgeteer.user_state_storage_bind_state(storage.nativeStorage, state);
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

class UserWidgetState extends State<StatefulUserWidget> {
  final UserStateStorage storage;

  UserWidgetState(this.storage);

  @override
  Widget build(BuildContext context) {
    final proxy = widget.proxy;
    final key = widget.key! as ValueKey<String>;
    return proxy.build(context, storage, key.value);
  }

  void touchState() {
    /// XXX: I would use `_element.markNeedsBuild()` directly but it's private
    setState(() {});
  }
}

class StatefulUserWidgetProxy implements Finalizable {
  static final _finalizer = NativeFinalizer(
      libWidgeteer.addresses.stateful_user_widget_proxy_release);

  final stateful_user_widget_proxy nativeProxy;

  StatefulUserWidgetProxy(this.nativeProxy) {
    _finalizer.attach(this, nativeProxy);
  }

  Widget build(BuildContext context, UserStateStorage storage, String key) {
    final utf8Key = key.toNativeUtf8().cast<Char>();

    libWidgeteer.enter_scope();
    final widget = libWidgeteer.stateful_user_widget_proxy_build(
        nativeProxy, context, storage.nativeStorage, utf8Key) as Widget;
    libWidgeteer.exit_scope();

    calloc.free(utf8Key);

    return widget;
  }
}

/// Swift class storing a widget's state properties.
class UserStateStorage implements Finalizable {
  static final _finalizer =
      NativeFinalizer(libWidgeteer.addresses.user_state_storage_release);

  final user_state_storage nativeStorage;

  UserStateStorage(this.nativeStorage) {
    _finalizer.attach(this, nativeStorage, detach: this);
  }
}

/// Called by Swift to mark the state of a Swift widget as dirty.
void touchState(Object state) {
  (state as UserWidgetState).touchState();
}
