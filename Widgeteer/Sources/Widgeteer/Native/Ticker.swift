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

import Foundation
import DartApiDl

public class FlutterTask {
    public typealias Closure = (_ synchronous: Bool) -> Void

    let perform: Closure
    let scoped: Bool

    init(perform: @escaping Closure, scoped: Bool) {
        self.perform = perform
        self.scoped = scoped
    }

    func run(synchronous: Bool) {
        assertIsOnFlutterThread()

        trace("Task scoped: \(self.scoped)")

        if self.scoped {
            _enterScope()
        }

        self.perform(synchronous)

        if self.scoped {
            _exitScope()
        }
    }
}

private var pendingTasks: [FlutterTask] = []
private var tasksLock = NSLock()

/// Executed repeatedly by Flutter on the main thread (every few milliseconds).
/// Longer gaps can happen if Flutter is busy updating the app (after a state change for example).
@_cdecl("widgeteer_tick")
public func _tick() {
    assertIsOnFlutterThread()

    // Run pending tasks
    // Copy the list inside the lock and release it immediately
    // to prevent a deadlock in case ``Flutter_Schedule`` is called again
    // inside a task, and to avoid mutating the list while it's being looped on
    tasksLock.lock()
    let tasks = pendingTasks
    pendingTasks = []
    tasksLock.unlock()

    for task in tasks {
        trace("[Flutter_Schedule] Running task asynchronously")
        task.run(synchronous: false)
    }
}

/// Schedule a task on the Flutter main thread. If the current thread is already
/// the Flutter main thread, the task will be executed synchronously and immediately.
/// Otherwise, it will be scheduled for the next ``tick()``.
// TODO: switch to package access level (SE-0386)
public func Flutter_Schedule(scoped: Bool, _ task: @escaping FlutterTask.Closure) {
    let task = FlutterTask(perform: task, scoped: scoped)
    Flutter_Schedule(task: task)
}

func Flutter_Schedule(task: FlutterTask) {
    if isOnFlutterThread() {
        trace("[Flutter_Schedule] Running task synchronously")
        task.run(synchronous: true)
    } else {
        tasksLock.performLocked {
            pendingTasks.append(task)
        }
    }
}

/// Async version of ``Flutter_Schedule`` that also supports returning a value.
// TODO: switch to package access level (SE-0386)
public func Flutter_AsyncSchedule<Result>(scoped: Bool, _ task: @escaping (_ synchronous: Bool) -> Result) async -> Result {
    return await withUnsafeContinuation { (continuation: UnsafeContinuation<Result, Never>) in
        let task = FlutterTask(
            perform: { synchronous in
                let result = task(synchronous)
                continuation.resume(returning: result)
            },
            scoped: scoped
        )

        Flutter_Schedule(task: task)
    }
}

/// Blocking version of ``Flutter_Schedule`` that also supports returning a value.
public func Flutter_BlockingSchedule<Result>(scoped: Bool, _ perform: @escaping (_ synchronous: Bool) -> Result) -> Result {
    if isOnFlutterThread() {
        trace("[Flutter_Schedule] Running blocking task synchronously")
        if scoped {
            _enterScope()
        }

        let value = perform(true)

        if scoped {
            _exitScope()
        }

        return value
    } else {
        trace("[Flutter_Schedule] Running blocking task asynchronously")

        var result: Result?
        let condition = NSCondition()

        let task = FlutterTask(
            perform: { synchronous in
                assert(!synchronous)
                result = perform(synchronous)
                condition.signal()
            },
            scoped: scoped
        )

        Flutter_Schedule(task: task)

        condition.wait()

        guard let result else {
            fatalError("Blocking Flutter task did not set result")
        }

        return result
    }
}
