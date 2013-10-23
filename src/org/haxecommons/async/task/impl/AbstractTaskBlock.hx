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
package org.haxecommons.async.task.impl;
import org.haxecommons.async.command.CompositeCommandKind;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.task.command.TaskCommand;
import org.haxecommons.async.task.command.TaskFlowControlCommand;
import org.haxecommons.async.task.event.TaskEvent;
import org.haxecommons.async.task.event.TaskFlowControlEvent;
import org.haxecommons.async.task.ITask;
import org.haxecommons.async.task.ITaskBlock;
import org.haxecommons.async.task.ITaskFlowControl;
import org.haxecommons.async.task.TaskFlowControlKind;

/**
 * Base class for <code>ITaskBlock</code> implementations.
 * @inheritDoc
 */
class AbstractTaskBlock extends Task implements ITaskBlock {

	/**
	 * Creates a new <code>AbstractTaskBlock</code> instance.
	 */
	function new() super();
	
	/**
	 * @inheritDoc
	 */
	public override function end():ITask {
		setIsClosed(true);
		return parent != null ? parent : this;
	}
	
	/**
	 * @inheritDoc
	 */
	public override function break_():ITask {
		var result = addCommand(new TaskFlowControlCommand(TaskFlowControlKind.BREAK), CompositeCommandKind.SEQUENCE);
		return result != null ? result : this;
	}
	
	/**
	 * @inheritDoc
	 */
	public override function continue_():ITask {
		var result = addCommand(new TaskFlowControlCommand(TaskFlowControlKind.CONTINUE), CompositeCommandKind.SEQUENCE);
		return result != null ? result : this;
	}
	
	override function executeCommand(command:ICommand) {
		currentCommand = command;
		if (command != null) {
			if (doFlowControlCheck(command)) {
				var async:IOperation = cast command;
				addCommandListeners(async);
				dispatchTaskEvent(TaskEvent.BEFORE_EXECUTE_COMMAND, command);
				command.execute();
				if (async == null) {
					dispatchTaskEvent(TaskEvent.AFTER_EXECUTE_COMMAND, command);
					executeNextCommand();
				}
			}
		} else {
			restartExecution();
		}
	}
	
	override function TaskFlowControlEvent_handler(event:TaskFlowControlEvent) {
		executeFlowControl(TaskFlowControlKind.fromName(event.type));
	}
	
	function doFlowControlCheck(command:ICommand):Bool {
		if (Std.is(command, TaskCommand)) {
			var tc:TaskCommand = cast(command, TaskCommand);
			var command:ICommand = tc.commands[0];
			if (Std.is(command, ITaskFlowControl)) {
				return executeFlowControl(cast(command, ITaskFlowControl).kind);
			}
		}
		return true;
	}
	
	function executeFlowControl(kind:TaskFlowControlKind):Bool {
		if(kind == TaskFlowControlKind.BREAK) {
			resetCommandList();
			completeExecution();
			return false;
		} else if(kind == TaskFlowControlKind.CONTINUE) {
			restartExecution();
			return false;
		} else if(kind == TaskFlowControlKind.EXIT) {
			exitExecution();
			return false;
		}
		
		return true;
	}
	
	function exitExecution() {
		//nothing?
	}
	
	function restartExecution() {
		resetCommandList();
		execute();
	}
}