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

/// Contains path to the shared library to load on bootstrap.
const libraryPathEnv = "WIDGETEER_LIBRARY_PATH";

// This tells the app to call `widgeteer_preview` instead of `widgeteer_run`
// on restart
const previewEnv = "WIDGETEER_PREVIEW";

// Path to the file where the app writes its PID on start.
const pidEnv = "WIDGETEER_PID";

/// Path to the "next library" text file to use when hot reloading.
const nextSoEnv = "WIDGETEER_NEXT_SO";

/// Working directory of the project files on the host computer.
const projectWorkingDirectoryEnv = "WIDGETEER_WORKING_DIRECTORY";
