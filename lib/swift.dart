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
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:widgeteer/generated/lib_app.dart';
import 'package:widgeteer/generated/lib_widgeteer.dart';

import 'environment.dart';
import 'generated/register_outlets.dart';

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
  final DynamicLibrary lib = DynamicLibrary.open(_getLibraryPath(args));

  _libWidgeteer = LibWidgeteer(lib);
  _libApp = LibApp(lib);

  // This is necessary for Swift widgets to appear in DevTools
  // See: https://github.com/flutter/devtools/issues/4152
  // TODO: somehow find a way to autodetect the directory
  final cur = Directory.current.parent.path;
  // ignore: invalid_use_of_protected_member
  WidgetInspectorService.instance.addPubRootDirectories(["$cur/../Widgeteer"]);

  _libWidgeteer.init(NativeApi.initializeApiDLData);
  registerOutlets(_libWidgeteer);
}

/// Restart the app: call the Swift app entry function, but do
/// not bootstrap again.
void _restart() {
  _libWidgeteer.enter_scope();

  _libApp.main();

  _libWidgeteer.exit_scope();
}

String _getLibraryPath(List<String> args) {
  // Get value from args if specified, or fallback to environment
  if (args.isNotEmpty) {
    return args[0];
  }

  const widgeteerPath =
      String.fromEnvironment(libraryPathEnv, defaultValue: "");
  if (widgeteerPath.isEmpty) {
    throw "Could not resolve Swift library path, "
        "check '--dart-define' in 'flutter run'";
  }

  return widgeteerPath;
}

late LibWidgeteer _libWidgeteer;
late LibApp _libApp;
