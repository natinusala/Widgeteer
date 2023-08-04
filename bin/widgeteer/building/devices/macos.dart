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

import '../device.dart';

class macOSDevice extends Device {
  macOSDevice(
      {required super.id,
      required super.name,
      required super.platform,
      required super.version});

  @override
  bool get shouldBuildSwiftApp => false;

  @override
  String operatingSystem() {
    throw "widgeteer CLI should not build the Swift app on macOS";
  }

  @override
  String target() {
    throw "widgeteer CLI should not build the Swift app on macOS";
  }
}
