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

import 'package:ffigen/ffigen.dart';

/// Represents a native library exposed as C calling convention
/// by the Swift code.
///
/// At the end of the generation process, each library gets an ffigen
/// generation call to create the corresponding Dart binding.
abstract class NativeLibrary {
  /// ffigen config to run.
  Config config(String workingDirectory);

  /// Path to the generated Dart file containing bindings.
  String output(String workingDirectory);

  String get name;
}
