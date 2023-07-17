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

#include "../Widgeteer/Sources/DartApiDl/include/dart_api_dl.h"

// All types used to communicate between Swift and Dart.
// Unless stated otherwise, `void*` types correspond to opaque retained Swift classes.
// See their Swift implementation for documentation.

typedef void* widgeteer_user_widget_proxy;
typedef void* widgeteer_stateless_user_widget_proxy;
typedef void* widgeteer_stateful_user_widget_proxy;
typedef void* widgeteer_handles_list;
typedef void* widgeteer_optional_value;
typedef void* widgeteer_user_state_storage;
