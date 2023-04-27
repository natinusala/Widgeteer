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

import 'widgeteer/commands/library.dart';
import 'widgeteer/commands/clean.dart';
import 'widgeteer/commands/devices.dart';
import 'widgeteer/commands/run.dart';

void main(List<String> args) async {
  CommandRunner("widgeteer", "Manage your Widgeteer app development.")
    ..addCommand(RunCommand())
    ..addCommand(DevicesCommand())
    ..addCommand(CleanCommand())
    ..addCommand(LibraryCommand())
    ..run(args);
}
