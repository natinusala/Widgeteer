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

#include "types.h"

// All the functions exposed by the Widgeteer library (not generated).
// See their Swift implementation for documentation.

// Lifecycle
extern void widgeteer_init(void* data);
extern void widgeteer_tick();

// Don't use ffigen for this function as it needs `Object?` which is not supported yet
// extern void widgeteer_set_null_handle(Dart_Handle handle);

// Scope management
extern void widgeteer_enter_scope();
extern void widgeteer_exit_scope();

// widgeteer_user_widget_proxy: common features for all widget proxies (widgeteer_stateless_user_widget_proxy and widgeteer_stateful_user_widget_proxy)
extern bool widgeteer_user_widget_proxy_equals(widgeteer_user_widget_proxy lhs, widgeteer_user_widget_proxy rhs);

// widgeteer_stateless_user_widget_proxy: stateless user widgets
extern Dart_Handle widgeteer_stateless_user_widget_proxy_build(widgeteer_stateless_user_widget_proxy proxy, char* parentKey, Dart_Handle buildContext);
extern void widgeteer_stateless_user_widget_proxy_release(widgeteer_stateless_user_widget_proxy proxy);

// widgeteer_handles_list: Dart handles list
extern int widgeteer_handles_list_count(widgeteer_handles_list list);
extern Dart_Handle widgeteer_handles_list_get(widgeteer_handles_list list, int idx);
