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
package org.haxecommons.async.command;

/**
 * Enumeration that defines the different ways an <code>ICompositeCommand</code> can execute its collection.
 * of <code>ICommands</code>
 * @author Roland Zwaga
 * @see org.haxecommons.async.command.CompositeCommand CompositeCommand
 * @see org.haxecommons.async.command.ICommand ICommand
 */
@:final class CompositeCommandKind {
	
	static var _kinds:Map<String, CompositeCommandKind> = new Map();
	
	/**
	 * Determines that the <code>ICompositeCommand</code> will execute its collection of command one after the other.
	 */
	public static var SEQUENCE = new CompositeCommandKind("sequence");
	
	/**
	 * Determines that the <code>ICompositeCommand</code> will execute its collection of command all at the same time.
	 */
	public static var PARALLEL = new CompositeCommandKind("parallel");
	
	/**
	 * Returns the <code>ComposeiteCommandKind</code> instance whose <code>name</code> property is equivalent
	 * to the specified <code>name</code> argument, or null if the name doesn't exist.
	 * @param name the specified <code>name</code>.
	 * @return The <code>ComposeiteCommandKind</code> instance whose <code>name</code> property is equivalent
	 * to the specified <code>name</code> argument, or null if the name doesn't exist.
	 */
	public static function fromName(?name:String):CompositeCommandKind {
		if(name == null || name.length == 0) {
			return null;
		}
		
		return _kinds.get(name);
	}
	
	/**
	 * Creates a new <code>ComposeiteCommandKind</code> instance. Do not call this constructor
	 * directly, it is only used internally the create the appropriate instances.
	 * @param name The string representation of the current <code>ComposeiteCommandKind</code> instance.
	 */
	function new(name:String) {
		this.name = name;
		_kinds.set(name, this);
	}
	
	/**
	 * Returns the name of the current <code>ComposeiteCommandKind</code>.
	 */
	public var name(default, null):String;
	
	/**
	 * Returns a string representation of the current <code>ComposeiteCommandKind</code>.
	 */
	public function toString() return name;
}