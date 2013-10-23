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
package org.haxecommons.async.task.command;
import flash.events.EventDispatcher;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.task.event.TaskFlowControlEvent;
import org.haxecommons.async.task.ITaskFlowControl;
import org.haxecommons.async.task.TaskFlowControlKind;

/**
 * @author Roland Zwaga
 */
class TaskFlowControlCommand extends EventDispatcher implements ICommand implements ITaskFlowControl {
	
	/**
	 * Creates a new <code>TaskFlowControlCommand</code> instance.
	 */
	public function new(kind:TaskFlowControlKind) {
		#if debug
		if(kind == null) throw "the kind argument must not be null";
		#end
		
		super();
		
		this.kind = kind;
	}
	
	public var kind(default, null):TaskFlowControlKind;

	public function execute():Dynamic {
		dispatchEvent(new TaskFlowControlEvent(this.kind));
		return this.kind;
	}

}