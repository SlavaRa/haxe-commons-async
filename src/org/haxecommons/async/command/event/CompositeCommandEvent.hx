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
package org.haxecommons.async.command.event;
import openfl.events.Event;
import org.haxecommons.async.command.ICommand;

/**
 * @author Christophe Herreman
 */
class CompositeCommandEvent extends Event {

	/**
	 * Defines the value of the type property of a <code>CompositeCommandEvent.COMPLETE</code> event object.
	 * @eventType String
	 */
	public static var COMPLETE = "compositeCommandComplete";
	
	/**
	 * Defines the value of the type property of a <code>CompositeCommandEvent.ERROR</code> event object.
	 * @eventType String
	 */
	public static var ERROR = "compositeCommandError";
	
	/**
	 * Defines the value of the type property of a <code>CompositeCommandEvent.BEFORE_EXECUTE_COMMAND</code> event object.
	 * @eventType String
	 */
	public static var BEFORE_EXECUTE_COMMAND = "compositeCommandBeforeExecuteCommand";
	
	/**
	 * Defines the value of the type property of a <code>CompositeCommandEvent.AFTER_EXECUTE_COMMAND</code> event object.
	 * @eventType String
	 */
	public static var AFTER_EXECUTE_COMMAND = "compositeCommandAfterExecuteCommand";
	
	/**
	 * Constructs a new CompositeCommandEvent
	 */
	public function new(type:String, ?command:ICommand, ?bubbles:Bool, ?cancelable:Bool) {
		super(type, bubbles, cancelable);
		this.command = command;
	}
	
	public var command(default, null):ICommand;
	
	/**
	 * Returns an exact copy of the current <code>CompositeCommandEvent</code> instance.
	 */
	public override function clone():Event return new CompositeCommandEvent(type, command, bubbles, cancelable);
}