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
import 'package:widgeteer/runtime_types.dart';

import '../dylib.dart';

class StatelessUserWidget extends StatelessWidget {
  final StatelessUserWidgetProxy proxy;

  late final UserWidgetRuntimeType _runtimeType;

  StatelessUserWidget(String swiftWidgetName,
      {super.key, required this.proxy}) {
    _runtimeType = UserWidgetRuntimeType(swiftWidgetName: swiftWidgetName);
  }

  @override
  Widget build(BuildContext context) {
    final key = this.key! as ValueKey<String>;
    return proxy.build(context, key.value);
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

    return other is StatelessUserWidget &&
        libWidgeteer.user_widget_proxy_equals(
            proxy.nativeProxy, other.proxy.nativeProxy);
  }
}

class StatelessUserWidgetProxy implements Finalizable {
  static final _finalizer = NativeFinalizer(
      libWidgeteer.addresses.stateless_user_widget_proxy_release);

  final stateless_user_widget_proxy nativeProxy;

  StatelessUserWidgetProxy(this.nativeProxy) {
    _finalizer.attach(this, nativeProxy);
  }

  Widget build(BuildContext context, String key) {
    final utf8Key = key.toNativeUtf8().cast<Char>();

    libWidgeteer.enter_scope();
    final widget = libWidgeteer.stateless_user_widget_proxy_build(
        nativeProxy, context, utf8Key) as Widget;
    libWidgeteer.exit_scope();

    calloc.free(utf8Key);

    return widget;
  }
}
