// ignore_for_file: avoid_print

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

import 'dart:core' as core;

class Logger {
  const Logger();

  /// Used to inform the user that something has happened.
  void info(core.String message) {
    core.print("[INFO] $message");
  }

  /// Used for debugging only messages.
  void debug(core.String message) {
    core.print("[DEBUG] $message");
  }

  /// Prints the message as-is to the terminal.
  void print(core.String message) {
    core.print(message);
  }

  /// Used to notify advance of a task.
  void log(core.String message) {
    core.print(message);
  }
}

const logger = Logger();
