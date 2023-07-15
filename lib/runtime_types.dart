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

/// The overridden runtime type for Widgeteer Swift widgets.
/// Widgets would otherwise all have the same runtime type and nothing would ever work.
class UserWidgetRuntimeType extends Type {
  /// The full Swift widget name, including generic parameters and file name (important for equality).
  final String swiftWidgetName;

  UserWidgetRuntimeType({required this.swiftWidgetName});

  @override
  int get hashCode => swiftWidgetName.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is UserWidgetRuntimeType) {
      return swiftWidgetName == other.swiftWidgetName;
    }

    return false;
  }

  @override
  String toString() => swiftWidgetName;
}
