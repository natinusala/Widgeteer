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

import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:widgeteer/generated/lib_app.dart';
import 'package:widgeteer/generated/lib_widgeteer.dart';

import 'dylib.dart';
import 'environment.dart';
import 'generated/register_outlets.dart';

final Object? nullHandle = null;

/// Load, initialize and run the Swift app.
void main(List<String> args) {
  _bootstrap(args);
  _restart();
}

/// Start the Widgeteer bootstrap sequence: load the Swift app library,
/// register all callbacks and call `widgeteer_main()`.
void _bootstrap(List<String> args) {
  // The entrypoint lib has symbols for all other libs
  // thanks to `@_exported` imports in Swift, so we only need
  // to open one library in here
  final DynamicLibrary lib;
  final libraryPath = _getLibraryPath(args);
  if (libraryPath != null) {
    lib = DynamicLibrary.open(libraryPath);
  } else {
    lib = DynamicLibrary.executable();
  }

  libWidgeteer = LibWidgeteer(lib);
  libApp = LibApp(lib);

  const projectWorkingDirectory =
      String.fromEnvironment(projectWorkingDirectoryEnv);

  // This is necessary for Swift widgets to appear in DevTools
  // See: https://github.com/flutter/devtools/issues/4152
  // TODO: somehow find a way to autodetect the Widgeteer directory location relative to project location
  // ignore: invalid_use_of_protected_member
  WidgetInspectorService.instance.addPubRootDirectories(
    ["$projectWorkingDirectory/../Widgeteer"],
  );
  print("XXXXX $projectWorkingDirectory");

  libWidgeteer.init(NativeApi.initializeApiDLData);
  setNullHandle(lib);
  registerOutlets(libWidgeteer);

  Timer.periodic(const Duration(milliseconds: 8), (Timer t) {
    libWidgeteer.tick();
  });
}

/// Restart the app: call the Swift app entry function, but do
/// not bootstrap again.
void _restart() {
  libWidgeteer.enter_scope();

  libApp.main();

  libWidgeteer.exit_scope();
}

String? _getLibraryPath(List<String> args) {
  // Get value from args if specified, or fallback to environment
  if (args.isNotEmpty) {
    return args[0];
  }

  const widgeteerPath =
      String.fromEnvironment(libraryPathEnv, defaultValue: "");

  if (widgeteerPath.isEmpty) {
    return null; // use executable
  }

  return widgeteerPath;
}

/// This bootstrap step has its own separate mechanism because it needs `Object?`
/// and ffigen doesn't support it yet, so we need to work our way around the generated
/// wrapper and call the function directly.
void setNullHandle(DynamicLibrary lib) {
  late final _set_null_handlePtr =
      lib.lookup<NativeFunction<Void Function(Handle)>>(
          'widgeteer_set_null_handle');
  late final _set_null_handle =
      _set_null_handlePtr.asFunction<void Function(Object?)>();

  _set_null_handle(nullHandle);
}

List<T> consumeHandlesList<T>(handles_list list) {
  final count = libWidgeteer.handles_list_count(list);

  return List<T>.generate(
      count, (idx) => libWidgeteer.handles_list_get(list, idx) as T);
}
