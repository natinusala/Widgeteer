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

import '../code_unit.dart';

/// Represents a bound type.
///
/// Contains the definition of the Swift type, its Dart counterpart,
/// the intermediate C type as well as code in all languages to to convert values
/// of this type from and to all the different representations.
///
/// To avoid circular dependencies, bindings should avoid storing other bindings
/// in properties. Instead, store the binding name and use [getBinding] only when
/// the actual binding is needed (typically at generation time).
abstract class BoundType {
  /// Name of the type as used in bindings (internal to the bindings generator).
  /// Does not necessarily correspond to a valid Dart or Swift type.
  String get name;

  /// The corresponding Swift type.
  SwiftType get swiftType;

  /// The corresponding Dart type.
  DartType get dartType;

  /// The corresponding C type.
  CType get cType;
}

abstract class SwiftType {
  /// Name of the actual, final Swift type, as used
  /// in regular Swift code.
  String get name;
}

abstract class DartType {
  /// Name of the actual, final Dart type, as used
  /// in regular Dart code.
  String get name;

  /// Dart code that takes [sourceFfiValue] and turns it into a value
  /// of the target Dart type inside a variable called `${variableName}Value`.
  ///
  /// [sourceFfiValue] is the name of a variable (or a full expression)
  /// that has the FFI type described in the binding associated C type.
  ///
  /// [variableName] is the name of the associated parameter.
  CodeUnit fromCValue(String sourceFfiValue, String variableName);
}

/// The C type that acts as intermediate between a Swift type and its
/// Dart counterpart.
abstract class CType {
  String get name;

  /// Representation of the type as a C interop type.
  String get cInteropMapping;

  /// Representation of the type inside FFI.
  /// Should be an FFI type such as `Pointer`.
  String get dartFfiMapping;
}