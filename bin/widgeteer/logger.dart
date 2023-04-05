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

import 'dart:io' as io;
import 'package:logger/logger.dart';

final filter = WidgeteerLogFilter();
final logger = Logger(
  filter: filter,
  printer: PrettyPrinter(
    methodCount: 0,
    colors: io.stdout.supportsAnsiEscapes,
    lineLength: io.stdout.terminalColumns,
  ),
);

class WidgeteerLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
