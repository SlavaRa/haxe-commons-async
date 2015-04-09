/*
 * Copyright 2007-2015 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.haxecommons.async.task.event;
import openfl.events.Event;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.task.ITask;

/**
 * @author Roland Zwaga
 */
class TaskEvent extends Event {
	
	/**
	 * Defines the value of the type property of a <code>TaskEvent.TASK_ERROR</code> event object.
	 * @eventType String
	 */
	public static var TASK_ERROR = "taskError";
	
	/**
	 * Defines the value of the type property of a <code>TaskEvent.TASK_ABORTED</code> event object.
	 * @eventType String
	 */
	public static var TASK_ABORTED = "taskAborted";
	
	/**
	 * Defines the value of the type property of a <code>TaskEvent.TASK_COMPLETE</code> event object.
	 * @eventType String
	 */
	public static var TASK_COMPLETE = "taskComplete";
	
	/**
	 * Defines the value of the type property of a <code>TaskEvent.BEFORE_EXECUTE_COMMAND</code> event object.
	 * @eventType String
	 */
	public static var BEFORE_EXECUTE_COMMAND = "taskBeforeExecuteCommand";
	
	/**
	 * Defines the value of the type property of a <code>TaskEvent.AFTER_EXECUTE_COMMAND</code> event object.
	 * @eventType String
	 */
	public static var AFTER_EXECUTE_COMMAND = "taskAfterExecuteCommand";
	
	/**
	 * Creates a new <code>TaskEvent</code> instance.
	 */
	public function new(type:String, task:ITask, command:ICommand, ?bubbles:Bool, ?cancelable:Bool) {
		super(type, bubbles, cancelable);
		this.command = command;
		this.task = task;
	}

	public var command(default, null):ICommand;
	public var task(default, null):ITask;
	
	/**
	 * @return An exact copy of the current <code>TaskEvent</code>.
	 */
	public override function clone():Event return new TaskEvent(type, task, command, bubbles, cancelable);
}