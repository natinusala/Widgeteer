// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

/// Widgeteer runtime library
class LibWidgeteer {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  LibWidgeteer(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  LibWidgeteer.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void register_new_text(
    ffi.Pointer<
            ffi.NativeFunction<
                ffi.Handle Function(
                    ffi.Pointer<ffi.Char> key, ffi.Pointer<ffi.Char> data)>>
        outlet,
  ) {
    return _register_new_text(
      outlet,
    );
  }

  late final _register_new_textPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<
                  ffi.NativeFunction<
                      ffi.Handle Function(ffi.Pointer<ffi.Char> key,
                          ffi.Pointer<ffi.Char> data)>>)>>('register_new_text');
  late final _register_new_text = _register_new_textPtr.asFunction<
      void Function(
          ffi.Pointer<
              ffi.NativeFunction<
                  ffi.Handle Function(ffi.Pointer<ffi.Char> key,
                      ffi.Pointer<ffi.Char> data)>>)>();

  void register_new_column(
    ffi.Pointer<
            ffi.NativeFunction<
                ffi.Handle Function(
                    ffi.Pointer<ffi.Char> key, handles_list children)>>
        outlet,
  ) {
    return _register_new_column(
      outlet,
    );
  }

  late final _register_new_columnPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<
                  ffi.NativeFunction<
                      ffi.Handle Function(ffi.Pointer<ffi.Char> key,
                          handles_list children)>>)>>('register_new_column');
  late final _register_new_column = _register_new_columnPtr.asFunction<
      void Function(
          ffi.Pointer<
              ffi.NativeFunction<
                  ffi.Handle Function(
                      ffi.Pointer<ffi.Char> key, handles_list children)>>)>();

  void register_run_app(
    ffi.Pointer<ffi.NativeFunction<ffi.Void Function(ffi.Handle app)>> outlet,
  ) {
    return _register_run_app(
      outlet,
    );
  }

  late final _register_run_appPtr = _lookup<
          ffi.NativeFunction<
              ffi.Void Function(
                  ffi.Pointer<
                      ffi.NativeFunction<ffi.Void Function(ffi.Handle app)>>)>>(
      'register_run_app');
  late final _register_run_app = _register_run_appPtr.asFunction<
      void Function(
          ffi.Pointer<
              ffi.NativeFunction<ffi.Void Function(ffi.Handle app)>>)>();

  void register_new_directionality(
    ffi.Pointer<
            ffi.NativeFunction<
                ffi.Handle Function(ffi.Pointer<ffi.Char> key,
                    ffi.Int textDirection, ffi.Handle child)>>
        outlet,
  ) {
    return _register_new_directionality(
      outlet,
    );
  }

  late final _register_new_directionalityPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<
                  ffi.NativeFunction<
                      ffi.Handle Function(
                          ffi.Pointer<ffi.Char> key,
                          ffi.Int textDirection,
                          ffi.Handle child)>>)>>('register_new_directionality');
  late final _register_new_directionality =
      _register_new_directionalityPtr.asFunction<
          void Function(
              ffi.Pointer<
                  ffi.NativeFunction<
                      ffi.Handle Function(ffi.Pointer<ffi.Char> key,
                          ffi.Int textDirection, ffi.Handle child)>>)>();

  void register_new_center(
    ffi.Pointer<
            ffi.NativeFunction<
                ffi.Handle Function(
                    ffi.Pointer<ffi.Char> key, ffi.Handle child)>>
        outlet,
  ) {
    return _register_new_center(
      outlet,
    );
  }

  late final _register_new_centerPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<
                  ffi.NativeFunction<
                      ffi.Handle Function(ffi.Pointer<ffi.Char> key,
                          ffi.Handle child)>>)>>('register_new_center');
  late final _register_new_center = _register_new_centerPtr.asFunction<
      void Function(
          ffi.Pointer<
              ffi.NativeFunction<
                  ffi.Handle Function(
                      ffi.Pointer<ffi.Char> key, ffi.Handle child)>>)>();

  void register_new_material_app(
    ffi.Pointer<
            ffi.NativeFunction<
                ffi.Handle Function(
                    ffi.Pointer<ffi.Char> key,
                    ffi.Pointer<ffi.Char> title,
                    ffi.Handle theme,
                    ffi.Handle home)>>
        outlet,
  ) {
    return _register_new_material_app(
      outlet,
    );
  }

  late final _register_new_material_appPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<
                  ffi.NativeFunction<
                      ffi.Handle Function(
                          ffi.Pointer<ffi.Char> key,
                          ffi.Pointer<ffi.Char> title,
                          ffi.Handle theme,
                          ffi.Handle home)>>)>>('register_new_material_app');
  late final _register_new_material_app =
      _register_new_material_appPtr.asFunction<
          void Function(
              ffi.Pointer<
                  ffi.NativeFunction<
                      ffi.Handle Function(
                          ffi.Pointer<ffi.Char> key,
                          ffi.Pointer<ffi.Char> title,
                          ffi.Handle theme,
                          ffi.Handle home)>>)>();

  void register_new_theme_data(
    ffi.Pointer<ffi.NativeFunction<ffi.Handle Function(ffi.Int primarySwatch)>>
        outlet,
  ) {
    return _register_new_theme_data(
      outlet,
    );
  }

  late final _register_new_theme_dataPtr = _lookup<
          ffi.NativeFunction<
              ffi.Void Function(
                  ffi.Pointer<
                      ffi.NativeFunction<
                          ffi.Handle Function(ffi.Int primarySwatch)>>)>>(
      'register_new_theme_data');
  late final _register_new_theme_data = _register_new_theme_dataPtr.asFunction<
      void Function(
          ffi.Pointer<
              ffi.NativeFunction<
                  ffi.Handle Function(ffi.Int primarySwatch)>>)>();

  void register_new_text_button(
    ffi.Pointer<
            ffi.NativeFunction<
                ffi.Handle Function(ffi.Pointer<ffi.Char> key,
                    ffi.Pointer<ffi.Void> onPressed, ffi.Handle child)>>
        outlet,
  ) {
    return _register_new_text_button(
      outlet,
    );
  }

  late final _register_new_text_buttonPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<
                  ffi.NativeFunction<
                      ffi.Handle Function(
                          ffi.Pointer<ffi.Char> key,
                          ffi.Pointer<ffi.Void> onPressed,
                          ffi.Handle child)>>)>>('register_new_text_button');
  late final _register_new_text_button =
      _register_new_text_buttonPtr.asFunction<
          void Function(
              ffi.Pointer<
                  ffi.NativeFunction<
                      ffi.Handle Function(
                          ffi.Pointer<ffi.Char> key,
                          ffi.Pointer<ffi.Void> onPressed,
                          ffi.Handle child)>>)>();

  void register_new_app_bar(
    ffi.Pointer<
            ffi.NativeFunction<
                ffi.Handle Function(
                    ffi.Pointer<ffi.Char> key, ffi.Handle title)>>
        outlet,
  ) {
    return _register_new_app_bar(
      outlet,
    );
  }

  late final _register_new_app_barPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<
                  ffi.NativeFunction<
                      ffi.Handle Function(ffi.Pointer<ffi.Char> key,
                          ffi.Handle title)>>)>>('register_new_app_bar');
  late final _register_new_app_bar = _register_new_app_barPtr.asFunction<
      void Function(
          ffi.Pointer<
              ffi.NativeFunction<
                  ffi.Handle Function(
                      ffi.Pointer<ffi.Char> key, ffi.Handle title)>>)>();

  void register_new_stateless_user_widget(
    ffi.Pointer<
            ffi.NativeFunction<
                ffi.Handle Function(
                    ffi.Pointer<ffi.Char> key,
                    stateless_user_widget_proxy proxy,
                    ffi.Pointer<ffi.Char> swiftWidgetName)>>
        outlet,
  ) {
    return _register_new_stateless_user_widget(
      outlet,
    );
  }

  late final _register_new_stateless_user_widgetPtr = _lookup<
          ffi.NativeFunction<
              ffi.Void Function(
                  ffi.Pointer<
                      ffi.NativeFunction<
                          ffi.Handle Function(
                              ffi.Pointer<ffi.Char> key,
                              stateless_user_widget_proxy proxy,
                              ffi.Pointer<ffi.Char> swiftWidgetName)>>)>>(
      'register_new_stateless_user_widget');
  late final _register_new_stateless_user_widget =
      _register_new_stateless_user_widgetPtr.asFunction<
          void Function(
              ffi.Pointer<
                  ffi.NativeFunction<
                      ffi.Handle Function(
                          ffi.Pointer<ffi.Char> key,
                          stateless_user_widget_proxy proxy,
                          ffi.Pointer<ffi.Char> swiftWidgetName)>>)>();

  void void_callback_proxy_release(
    void_callback_proxy proxy,
  ) {
    return _void_callback_proxy_release(
      proxy,
    );
  }

  late final _void_callback_proxy_releasePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(void_callback_proxy)>>(
          'widgeteer_void_callback_proxy_release');
  late final _void_callback_proxy_release = _void_callback_proxy_releasePtr
      .asFunction<void Function(void_callback_proxy)>();

  void void_callback_proxy_call(
    void_callback_proxy proxy,
  ) {
    return _void_callback_proxy_call(
      proxy,
    );
  }

  late final _void_callback_proxy_callPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(void_callback_proxy)>>(
          'widgeteer_void_callback_proxy_call');
  late final _void_callback_proxy_call = _void_callback_proxy_callPtr
      .asFunction<void Function(void_callback_proxy)>();

  void init(
    ffi.Pointer<ffi.Void> data,
  ) {
    return _init(
      data,
    );
  }

  late final _initPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>(
          'widgeteer_init');
  late final _init =
      _initPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  void tick() {
    return _tick();
  }

  late final _tickPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('widgeteer_tick');
  late final _tick = _tickPtr.asFunction<void Function()>();

  void enter_scope() {
    return _enter_scope();
  }

  late final _enter_scopePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('widgeteer_enter_scope');
  late final _enter_scope = _enter_scopePtr.asFunction<void Function()>();

  void exit_scope() {
    return _exit_scope();
  }

  late final _exit_scopePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('widgeteer_exit_scope');
  late final _exit_scope = _exit_scopePtr.asFunction<void Function()>();

  bool user_widget_proxy_equals(
    user_widget_proxy lhs,
    user_widget_proxy rhs,
  ) {
    return _user_widget_proxy_equals(
      lhs,
      rhs,
    );
  }

  late final _user_widget_proxy_equalsPtr = _lookup<
      ffi.NativeFunction<
          ffi.Bool Function(user_widget_proxy,
              user_widget_proxy)>>('widgeteer_user_widget_proxy_equals');
  late final _user_widget_proxy_equals = _user_widget_proxy_equalsPtr
      .asFunction<bool Function(user_widget_proxy, user_widget_proxy)>();

  Object stateless_user_widget_proxy_build(
    stateless_user_widget_proxy proxy,
    ffi.Pointer<ffi.Char> parentKey,
    Object buildContext,
  ) {
    return _stateless_user_widget_proxy_build(
      proxy,
      parentKey,
      buildContext,
    );
  }

  late final _stateless_user_widget_proxy_buildPtr = _lookup<
      ffi.NativeFunction<
          ffi.Handle Function(
              stateless_user_widget_proxy,
              ffi.Pointer<ffi.Char>,
              ffi.Handle)>>('widgeteer_stateless_user_widget_proxy_build');
  late final _stateless_user_widget_proxy_build =
      _stateless_user_widget_proxy_buildPtr.asFunction<
          Object Function(
              stateless_user_widget_proxy, ffi.Pointer<ffi.Char>, Object)>();

  void stateless_user_widget_proxy_release(
    stateless_user_widget_proxy proxy,
  ) {
    return _stateless_user_widget_proxy_release(
      proxy,
    );
  }

  late final _stateless_user_widget_proxy_releasePtr = _lookup<
          ffi.NativeFunction<ffi.Void Function(stateless_user_widget_proxy)>>(
      'widgeteer_stateless_user_widget_proxy_release');
  late final _stateless_user_widget_proxy_release =
      _stateless_user_widget_proxy_releasePtr
          .asFunction<void Function(stateless_user_widget_proxy)>();

  int handles_list_count(
    handles_list list,
  ) {
    return _handles_list_count(
      list,
    );
  }

  late final _handles_list_countPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(handles_list)>>(
          'widgeteer_handles_list_count');
  late final _handles_list_count =
      _handles_list_countPtr.asFunction<int Function(handles_list)>();

  Object handles_list_get(
    handles_list list,
    int idx,
  ) {
    return _handles_list_get(
      list,
      idx,
    );
  }

  late final _handles_list_getPtr =
      _lookup<ffi.NativeFunction<ffi.Handle Function(handles_list, ffi.Int)>>(
          'widgeteer_handles_list_get');
  late final _handles_list_get =
      _handles_list_getPtr.asFunction<Object Function(handles_list, int)>();

  late final addresses = _SymbolAddresses(this);
}

class _SymbolAddresses {
  final LibWidgeteer _library;
  _SymbolAddresses(this._library);
  ffi.Pointer<ffi.NativeFunction<ffi.Void Function(void_callback_proxy)>>
      get void_callback_proxy_release =>
          _library._void_callback_proxy_releasePtr;
  ffi.Pointer<
          ffi.NativeFunction<ffi.Void Function(stateless_user_widget_proxy)>>
      get stateless_user_widget_proxy_release =>
          _library._stateless_user_widget_proxy_releasePtr;
}

typedef handles_list = ffi.Pointer<ffi.Void>;
typedef stateless_user_widget_proxy = ffi.Pointer<ffi.Void>;
typedef void_callback_proxy = ffi.Pointer<ffi.Void>;
typedef user_widget_proxy = ffi.Pointer<ffi.Void>;
