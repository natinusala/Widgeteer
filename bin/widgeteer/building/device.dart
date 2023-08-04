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

import 'dart:io';
import 'package:collection/collection.dart';

import '../config.dart';
import '../logger.dart';

abstract class Device {
  final String id;
  final String name;
  final String platform;
  final String version;

  Device(
      {required this.id,
      required this.name,
      required this.platform,
      required this.version});

  List<String> get swiftBuildArgs => [];
  Map<String, String> get flutterRunEnvironment => {};

  /// OS identifier inside the Swift / LLVM triplet.
  String operatingSystem();

  /// Swift target name.
  String target();

  /// Nullability determines the availability of the device on the current platform.
  ///
  /// If the device is unavailable, this contains a human readable
  /// description of why.
  String? get unavailability => null;

  /// Build anything platform specific. Executed after the Swift build and before the
  /// Flutter build / run.
  Future<void> build(
      String swiftBuildDir, String artifactsDir, String mode) async {}

  /// Should the widgeteer CLI build the Swift app, or is it part of the
  /// platform specific project?
  bool get shouldBuildSwiftApp => true;

  String get description {
    String prefix = "";
    if (unavailability != null) {
      prefix = "UNAVAILABLE ($unavailability) • ";
    }

    return "$prefix$id • $name • $platform • $version";
  }
}

/// Parse a device line of `flutter devices` and attempt to return a device handle.
Device? parseDevice(String line) {
  if (line.isEmpty) {
    return null;
  }

  // Expected format is name, id, platform, version separated by a bullet point
  // So we can simply split the line, trim the extra whitespaces and be done with it
  final parsed = line.split("•").map((line) => line.trim()).toList();
  final name = parsed[0];
  final id = parsed[1];
  final platform = parsed[2];
  final version = parsed[3];

  return createDevice(id, name, platform, version);
}

/// Interrogate Flutter for all connected devices and return their handle.
Iterable<Device> getDevices() {
  final process = Process.runSync("flutter", ["devices"]);
  if (process.exitCode != 0) {
    fail("Cannot list connected devices: 'flutter devices' "
        "returned exit code ${process.exitCode}");
  }

  final lines = (process.stdout as String).split("\n");

  // Expected format is the pattern followed by a blank line
  // and one line per device
  return parseDevices(lines, "([0-9]+) connected device") +
      parseDevices(lines, "([0-9]+) wirelessly connected device");
}

List<Device> parseDevices(List<String> lines, String pattern) {
  final countRegex = RegExp(pattern);

  // Identify the first line matching the pattern, that's the start boundary
  int boundary = -1;
  int count = 0;
  for (int line = 0; line < lines.length; line++) {
    final countStr = countRegex.firstMatch(lines[line])?.group(1);
    if (countStr == null) {
      continue;
    }

    count = int.parse(countStr);
    boundary = line;
    break;
  }

  if (boundary == -1) {
    return [];
  }

  final devicesLines = lines.sublist(boundary + 2, boundary + 2 + count + 1);
  return devicesLines.map((line) => parseDevice(line)).whereNotNull().toList();
}

/// Attempt to find the right device from the given name or id.
Device? findDevice(String device, List<Device> devices) {
  for (Device candidate in devices) {
    if (candidate.id.toLowerCase().startsWith(device.toLowerCase()) ||
        candidate.name.toLowerCase().startsWith(device.toLowerCase())) {
      return candidate;
    }
  }

  return null;
}

/// Return the target device from CLI options or fail if none was found.
Device getTargetDevice(String? requestedDevice) {
  // Find the target device
  final devices = getDevices().toList();

  // If there are no devices, error out
  // (the desktop platform isn't guaranteed to be available if SDK or libs are missing)
  if (devices.isEmpty) {
    fail("No connected devices. "
        "Use 'widgeteer devices' to list connected devices.");
  }

  // If there is only one device, pick it
  // Otherwise require the user to explicitely select one with `-d`
  if (devices.length == 1) {
    return devices.first;
  } else {
    if (requestedDevice == null) {
      fail("Multiple connected devices; please select one with '--device'. "
          "Use 'widgeteer devices' to list connected devices.");
    }

    final foundDevice = findDevice(requestedDevice, devices);
    if (foundDevice == null) {
      fail(
          "Did not find any connected device with name or id '$requestedDevice'. "
          "Use 'widgeteer devices' to list connected devices.");
    }

    return foundDevice;
  }
}

/// An unsupported or unknown device.
///
/// We should still show them to the user to show that we detected it
/// but it's not supported by Widgeteer yet.
class UnsupportedDevice extends Device {
  UnsupportedDevice(
      {required super.id,
      required super.name,
      required super.platform,
      required super.version});

  @override
  String? get unavailability => "unsupported target platform";

  @override
  String operatingSystem() {
    throw UnimplementedError();
  }

  @override
  String target() {
    throw UnimplementedError();
  }
}
