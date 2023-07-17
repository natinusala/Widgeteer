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

  /// Name of the type inside the initializer of types
  /// using a property of this type.
  String get initType => name;

  /// List of additional attributes to use when inside an initializer,
  /// such as result builders.
  List<String> get initAttributes => [];

  /// Value to use for the property in the initializer.
  String initSetterValue(String source) {
    return source;
  }

  /// Swift code that takes [sourceFfiValue] and turns it into a value of
  /// the target Swift type inside a variable called `${destination}Value`.
  CodeUnit fromCValue(String source, String destination);
}

abstract class DartType {
  /// Name of the actual, final Dart type, as used
  /// in regular Dart code.
  String get name;

  /// Dart code that takes [sourceFfiValue] and turns it into a value
  /// of the target Dart type inside a variable called `${destination}Value`.
  ///
  /// [sourceFfiValue] is the name of a variable (or a full expression)
  /// that has the FFI type described in the binding associated C type.
  ///
  /// [variableName] is the name of the associated parameter.
  CodeUnit fromCValue(String source, String destination);
}

/// The C type that acts as intermediate between a Swift type and its
/// Dart counterpart.
abstract class CType {
  String get name;

  /// Representation of the type as a Swift C interop type.
  String get swiftCInteropMapping;

  /// Representation of the type inside FFI.
  /// Should be an FFI type such as `Pointer`.
  String get dartFfiMapping;

  /// Swift code that takes [sourceValue] and turns it unto a value of the
  /// interop C type inside a variable called `${destination}Value`.
  CodeUnit fromSwiftValue(String source, String destination);

  /// Dart code that takes [sourceValue] and turns it unto a value of the
  /// Dart FFI C type inside a variable called `${destination}Value`.
  CodeUnit fromDartValue(String source, String destination);

  /// Optional Swift code to run after the values from [fromSwiftValue] are about
  /// to go out of scope.
  CodeUnit? fromSwiftValueCleanup(String source, String destination) {
    return null;
  }

  /// Some types need an "exceptional return value" when using `Pointer.fromFunction`.
  /// If this type is one of them, override this property to give the exceptional value.
  ///
  /// As literas do not apparently count as constants, any new value needs to be declared as
  /// const at the very top of `register_outlets.dart`.
  String? get exceptionalReturnValue => null;
}
