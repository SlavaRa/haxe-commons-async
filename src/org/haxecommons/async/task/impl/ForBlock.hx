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
package org.haxecommons.async.task.impl;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.task.event.TaskEvent;
import org.haxecommons.async.task.event.TaskFlowControlEvent;
import org.haxecommons.async.task.ICountProvider;
import org.haxecommons.async.task.IForBlock;

/**
 * @inheritDoc
 */
class ForBlock extends AbstractTaskBlock implements IForBlock {
	
	/**
	 * Creates a new <code>ForBlock</code> instance.
	 * @param countProvider an <code>ICountProvider</code> that will determine whether the current <code>ForBlock</code>'s logic will be executed or not.
	 */
	public function new(countProvider:ICountProvider) {
		#if debug
		if(countProvider == null) throw "the countProvider argument must not be null";
		#end
		
		super();
		
		this.countProvider = countProvider;
	}
	
	public var countProvider(default, default):ICountProvider;
	
	var _count:Int;

	public override function execute():Dynamic {
		finishedCommandList = [];
		if (Std.is(countProvider, IOperation)) {
			var async:IOperation = cast(countProvider, IOperation);
			if (async.result == null) {
				addCountListeners(async);
			}
			if (Std.is(countProvider, ICommand)) {
				cast(countProvider, ICommand).execute();
			} else {
				startExecution();
			}
		} else {
			startExecution();
		}
		return null;
	}
	
	override function executeCommand(command:ICommand) {
		currentCommand = command;
		if (command != null) {
			if (doFlowControlCheck(command)) {
				var async:IOperation = null;
				if (Std.is(command, IOperation)) {
					async = cast(command, IOperation);
				}
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

	override function restartExecution() {
		resetCommandList();
		_count--;
		executeBlock();
	}
	
	override function TaskFlowControlEvent_handler(event:TaskFlowControlEvent) {
		switch (event.type) {
			case TaskFlowControlEvent.BREAK:
				resetCommandList();
				completeExecution();
			case TaskFlowControlEvent.CONTINUE:
				restartExecution();
			case TaskFlowControlEvent.EXIT:
				exitExecution();
		}
	}

	function startExecution() {
		_count = countProvider.getCount();
		executeBlock();
	}

	function executeBlock() {
		if (_count > 0) {
			finishedCommandList = [];
			executeNextCommand();
		} else {
			completeExecution();
		}
	}

	function onCountResult(event:OperationEvent) {
		removeCountListeners(cast event.target);
		startExecution();
	}

	function onCountFault(event:OperationEvent) {
		removeCountListeners(cast event.target);
		dispatchErrorEvent(cast event.target);
	}

	function addCountListeners(?asyncCommand:IOperation) {
		if(asyncCommand == null) return;
		asyncCommand.addCompleteListener(onCountResult);
		asyncCommand.addErrorListener(onCountFault);
	}

	function removeCountListeners(?asyncCommand:IOperation) {
		if(asyncCommand == null) return;
		asyncCommand.removeCompleteListener(onCountResult);
		asyncCommand.removeErrorListener(onCountFault);
	}
}