/*
 * Copyright 2007-2011 the original author or authors.
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
import flash.events.Event;
import org.haxecommons.async.command.ICommand;

/**
 * @author Christophe Herreman
 */
class CommandEvent extends Event {
	
	/**
	 * Defines the value of the type property of a <code>CommandEvent.EXECUTE</code> event object.
	 * @eventType String
	 */
	public static var EXECUTE = "executeCommand";
	
	/**
     * Creates a new <code>CompositeCommandEvent</code> instance.
     */
	public function new(type:String, command:ICommand, ?bubbles:Bool, ?cancelable:Bool) {
		super(type, bubbles, cancelable);
		this.command = command;
	}
	
	public var command(default, null):ICommand;
	
	/**
	 * Returns an exact copy of the current <code>CommandEvent</code> instance.
	 */
	public override function clone():Event return new CommandEvent(type, command, bubbles, cancelable);
}