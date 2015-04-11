/*
 * Copyright 2007 - 2015 the original author or authors.
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
import org.haxecommons.async.task.TaskFlowControlKind;

/**
 * @author Roland Zwaga
 */
class TaskFlowControlEvent extends Event{
	
	/**
	 * Indicates a break in the flow control.
	 */
	public static var BREAK = TaskFlowControlKind.BREAK.name;
	
	/**
	 * Indicates a continuation in the flow control.
	 */
	public static var CONTINUE = TaskFlowControlKind.CONTINUE.name;
	
	/**
	 * Indicates an exit (abort) of the flow control.
	 */
	public static var EXIT = TaskFlowControlKind.EXIT.name;
	
	/**
	 * Creates a new <code>TaskFlowControlEvent</code> instance.
	 */
	public function new(kind:TaskFlowControlKind, ?bubbles:Bool, ?cancelable:Bool) {
		super(kind.name, bubbles, cancelable);
	}
	
	/**
	 * @return An exact copy of the current <code>TaskFlowControlEvent</code>.
	 */
	public override function clone():Event return new TaskFlowControlEvent(TaskFlowControlKind.fromName(type), bubbles, cancelable);
}