// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:77
// === GENERATED BY `widgeteer bindings generate` === DO NOT EDIT ===
// === Follow the breadcrumbs to find what code generated what you're reading ===
// 🍞 bin/widgeteer/bindings_generator/bindings_generator.dart:45
import 'package:widgeteer/generated/Bindings/Callback/VoidCallback.dart';
// 🍞 bin/widgeteer/bindings/callback.dart:124
import 'dart:ffi';
import 'package:widgeteer/dylib.dart';
import 'package:widgeteer/generated/lib_widgeteer.dart';

// 🍞 bin/widgeteer/bindings/callback.dart:141
class VoidCallbackProxy implements Finalizable {
    static final _finalizer = NativeFinalizer(libWidgeteer.addresses.void_callback_proxy_release);

    final void_callback_proxy proxy;

    VoidCallbackProxy(this.proxy) {
        _finalizer.attach(this, proxy, detach: this);
    }
    void call() {
        libWidgeteer.enter_scope();
        libWidgeteer.void_callback_proxy_call(proxy);
        libWidgeteer.exit_scope();
    }
}