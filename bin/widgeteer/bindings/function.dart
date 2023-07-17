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

import '../bindings_generator/code_unit.dart';
import '../bindings_generator/models/binding.dart';

import 'package:path/path.dart' as p;

import '../bindings_generator/models/dart_function.dart';
import '../bindings_generator/models/outlet.dart';
import '../bindings_generator/models/parameter.dart';

class FunctionBinding extends Binding {
  final BindingContext context;

  final String bindingName;
  final String functionName;
  final String functionLocation;
  final String returnType;
  final ParametersList parameters;

  final String tomlPath;

  FunctionBinding({
    required this.bindingName,
    required this.context,
    required this.functionName,
    required this.tomlPath,
    required this.functionLocation,
    required this.returnType,
    required this.parameters,
  });

  factory FunctionBinding.fromTOML(
      String tomlPath, String fileStem, Map toml, BindingContext context) {
    return FunctionBinding(
      context: context,
      bindingName: fileStem,
      functionName: toml["function"]["name"] ?? fileStem,
      tomlPath: tomlPath,
      functionLocation: toml["function"]["location"],
      returnType: toml["function"]["return_type"],
      parameters: ParametersList.fromTOML(toml["parameter"], context),
    );
  }

  @override
  String get name => bindingName;

  @override
  String get origin => p.relative(tomlPath);

  late DartFunction function = DartFunction(
    outletName: functionName,
    context: context,
    name: functionName,
    location: functionLocation,
    returnType: returnType,
    parameters: parameters,
  );

  @override
  List<Outlet> get outlets => [function.callingOutlet];

  @override
  CodeUnit get dartBody {
    final body = CodeUnit.empty();
    body.appendUnit(function.outletImplementation(false));
    return body;
  }
}
