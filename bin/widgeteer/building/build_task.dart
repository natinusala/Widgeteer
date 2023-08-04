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

import '../logger.dart';

class BuildException implements Exception {
  final int exitCode;

  BuildException({required this.exitCode});
}

/// Asynchronously run a build task inside a clean environment.
///
/// The program will fail and exit if the command
/// returns a code other than 0.
Future<void> runBuildTask(
    String command,
    List<String> args,
    String workingDirectory,
    Map<String, String> additionalEnvironment,
    String action,
    String? done,
    {bool fatalFailure = true,
    required bool verbose}) async {
  // Clean out PATH since Flutter comes with its own linker that conflicts
  // with the one in the Swift toolchain
  var environment = Map.of(Platform.environment);
  final path = environment["PATH"];

  if (path == null) {
    fail("'PATH' environment variable is missing.");
  }

  environment["PATH"] = path
      .split(":")
      .where((element) => !element.contains("flutter"))
      .toList()
      .join(":");

  logger.log("$action...");

  if (verbose) {
    logger.log("⚙️  Running '$command ${args.join(" ")}'...");
    if (additionalEnvironment.isNotEmpty) {
      logger.log("📋 Environment: $additionalEnvironment");
    }
  }

  await stdout.flush();

  // Find the full command path using `which`
  final commandPath = Process.runSync("which", [command]).stdout.toString();

  final process = await Process.start(
    commandPath.replaceAll("\n", ""),
    args,
    workingDirectory: workingDirectory,
    mode: ProcessStartMode.inheritStdio,
    includeParentEnvironment: false,
    environment: {...environment, ...additionalEnvironment},
  );

  final exitCode = await process.exitCode;

  await stdout.flush();
  await stderr.flush();

  if (exitCode != 0) {
    if (fatalFailure) {
      fail(
          "❌  Command '$command' failed: process returned exit code '$exitCode'");
    } else {
      throw BuildException(exitCode: exitCode);
    }
  }

  if (done != null) {
    logger.log("✔️  $done");
  } else {
    logger.log(""); // dummy print necessary to create padding
  }

  await stdout.flush();
}
