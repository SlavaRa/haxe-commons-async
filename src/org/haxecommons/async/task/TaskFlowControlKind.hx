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
package org.haxecommons.async.task;

/**
 * Enumeration that describes different kinds of flow control.
 * @author Roland Zwaga
 */
@:final class TaskFlowControlKind {
	
	/**
	 * Indicates a break in the flow control.
	 */
	public static var BREAK = new TaskFlowControlKind("break");
	
	/**
	 * Indicates a continuation in the flow control.
	 */
	public static var CONTINUE = new TaskFlowControlKind("continue");
	
	/**
	 * Indicates an exit (abort) of the flow control.
	 */
	public static var EXIT = new TaskFlowControlKind("exit");
	
	/**
	 * Converts, if possible, a <code>String</code> to its <code>TaskFlowControlKind</code> equivalent.
	 * @param name the name of the requested <code>TaskFlowControlKind</code>.
	 * @return A <code>TaskFlowControlKind</code> instance whose name value is equal to the specified <code>name</code> argument.
	 * @throws openfl.errors.Error Error when the specified name cannot be converted to a valid <code>TaskFlowControlKind</code> instance.
	 */
	public static function fromName(name:String):TaskFlowControlKind {
		switch (name.toLowerCase()) {
			case "break":
				return BREAK;
			case "continue":
				return CONTINUE;
			case "exit":
				return EXIT;
			default:
				throw "Unknown TaskFlowControlKind value: " + name;
		}
		return null;
	}
	
	/**
	 * Creates a new <code>TaskFlowControlKind</code> instance.
	 * @param name The name of the current <code>TaskFlowControlKind</code>
	 */
	function new(name:String) this.name = name;
	
	/**
	 * The name of the current <code>TaskFlowControlKind</code>.
	 */
	public var name(default, null):String;
	
	/**
	 * A <code>String</code> representation of the current <code>TaskFlowControlKind</code>.
	 */
	public function toString():String return name;
}