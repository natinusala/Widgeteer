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

import 'package:args/command_runner.dart';

import '../building/build_path.dart';
import '../building/build_task.dart';

class CleanCommand extends Command {
  @override
  String get description => "Clean all build artifacts and ephemerals.";

  @override
  String get name => "clean";

  @override
  void run() async {
    ensureWidgeteerProject();

    // Clean Swift lib
    await runBuildTask(
      "swift",
      ["package", "clean"],
      libDir,
      {},
      "🧹  Cleaning Swift app",
      "Swift app cleaned",
      verbose: false,
    );

    // Clean flutter
    await runBuildTask(
      "flutter",
      ["clean"],
      workingDirectory,
      {},
      "🧹  Cleaning Flutter app",
      "Flutter app cleaned",
      verbose: false,
    );
  }
}
