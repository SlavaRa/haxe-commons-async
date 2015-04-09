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
import openfl.events.Event;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.command.impl.GenericOperationCommand;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.impl.AbstractOperation;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.task.event.TaskEvent;
import org.haxecommons.async.task.event.TaskFlowControlEvent;
import org.haxecommons.async.task.IConditionProvider;
import org.haxecommons.async.task.ICountProvider;
import org.haxecommons.async.task.IForBlock;
import org.haxecommons.async.task.IIfElseBlock;
import org.haxecommons.async.task.ITask;
import org.haxecommons.async.task.IWhileBlock;

/**
 * @inheritDoc
 */
class IfElseBlock extends AbstractOperation implements IIfElseBlock {
	
	/**
	 * Creates a new <code>IfElseBlock</code> instance.
	 * @param conditionProvider An <code>IConditionProvider</code> instance that determines which block will be executed.
	 */
	public function new(conditionProvider:IConditionProvider) {
		#if debug
		if(conditionProvider == null) throw "the conditionProvider argument must not be null";
		#end
		
		super();
		
		this.conditionProvider = conditionProvider;
		_ifBlock = new Task();
		_currentBlock = _ifBlock;
	}
	
	private var _ifBlock:ITask;
	private var _elseBlock:ITask;
	private var _currentBlock:ITask;
	
	/**
	 * @inheritDoc
	 */
	public var context:Dynamic;
	public var parent(default, set):ITask;

	function set_parent(value:ITask):ITask {
		parent = value;
		_ifBlock.parent = value;
		return value;
	}

	public var conditionProvider(default, default):IConditionProvider;
	
	/**
	 * @inheritDoc
	 */
	public var isClosed(default, null):Bool;

	public function switchToElseBlock() {
		_elseBlock = new Task();
		_elseBlock.parent = parent;
		_currentBlock = _elseBlock;
	}

	public function execute():Dynamic {
		if (Std.is(conditionProvider, IOperation)) {
			var async:IOperation = cast(conditionProvider, IOperation);
			addConditionalListeners(async);
			if (Std.is(conditionProvider, ICommand)) {
				cast(conditionProvider, ICommand).execute();
			}
		} else {
			executeBlocks();
		}
		return null;
	}

	public function reset(?doHardReset:Bool):ITask {
		if (!isClosed) {
			_currentBlock.reset(doHardReset);
		}
		return this;
	}

	public function next(item:Dynamic, ?constructorArgs:Array<Dynamic>):ITask {
		if (!isClosed) {
			var command:ICommand = Std.is(item, ICommand) ? cast(item, ICommand) : new GenericOperationCommand(item, constructorArgs);
			_currentBlock.next(command);
		}
		return this;
	}

	public function and(item:Dynamic, ?constructorArgs:Array<Dynamic>):ITask {
		if (!isClosed) {
			var command:ICommand = Std.is(item, ICommand) ? cast(item, ICommand) : new GenericOperationCommand(item, constructorArgs);
			_currentBlock.and(command);
		}
		return this;
	}

	public function if_(?condition:IConditionProvider, ?ifElseBlock:IIfElseBlock):IIfElseBlock {
		if (!isClosed) {
			_currentBlock.if_(condition, ifElseBlock);
		}
		return this;
	}

	public function else_():IIfElseBlock {
		if (!isClosed) {
			switchToElseBlock();
		}
		return this;
	}

	public function while_(?condition:IConditionProvider, ?whileBlock:IWhileBlock):IWhileBlock {
		if (!isClosed) {
			return _currentBlock.while_(condition, whileBlock);
		}
		return null;
	}

	public function for_(count:Int, ?countProvider:ICountProvider, ?forBlock:IForBlock):IForBlock {
		if (!isClosed) {
			return _currentBlock.for_(count, countProvider, forBlock);
		}
		return null;
	}

	public function end():ITask {
		isClosed = true;
		return parent != null ? parent : this;
	}

	public function exit():ITask {
		if (!isClosed) {
			_currentBlock.exit();
		}
		return this;
	}

	public function pause(duration:Int, ?pauseCommand:ICommand):ITask {
		if (!isClosed) {
			return _currentBlock.pause(duration, pauseCommand);
		}
		return this;
	}

	public function break_():ITask return this;

	public function continue_():ITask return this;
	
	function executeBlocks() {
		var result = conditionProvider.getResult();
		if (result) {
			addBlockListeners(_ifBlock);
			_ifBlock.execute();
		} else if (!result && (_elseBlock != null)) {
			addBlockListeners(_elseBlock);
			_elseBlock.execute();
		} else {
			dispatchCompleteEvent(null);
		}
	}

	function onConditionalResult(event:OperationEvent) {
		removeConditionalListeners(cast event.target);
		executeBlocks();
	}

	function onBlockComplete(event:TaskEvent) {
		removeBlockListeners(cast event.target);
		dispatchCompleteEvent(null);
	}

	function onCommandFault(event:OperationEvent) {
		var operation:IOperation = cast event.target;
		removeBlockListeners(operation);
		dispatchErrorEvent(operation);
	}

	function onConditionalFault(event:OperationEvent) {
		var operation:IOperation = cast event.target;
		removeConditionalListeners(event.target);
		dispatchErrorEvent(event.target);
	}

	function addConditionalListeners(?asyncCommand:IOperation) {
		if (asyncCommand == null) {
			return;
		}
		
		asyncCommand.addCompleteListener(onConditionalResult);
		asyncCommand.addErrorListener(onConditionalFault);
	}

	function removeConditionalListeners(?asyncCommand:IOperation) {
		if (asyncCommand == null) {
			return;
		}
		
		asyncCommand.removeCompleteListener(onConditionalResult);
		asyncCommand.removeErrorListener(onConditionalFault);
	}

	function addBlockListeners(?asyncCommand:IOperation) {
		if (asyncCommand == null) {
			return;
		}
		
		asyncCommand.addEventListener(TaskEvent.TASK_COMPLETE, onBlockComplete);
		asyncCommand.addEventListener(TaskEvent.BEFORE_EXECUTE_COMMAND, redispatch);
		asyncCommand.addEventListener(TaskEvent.AFTER_EXECUTE_COMMAND, redispatch);
		asyncCommand.addEventListener(TaskFlowControlEvent.BREAK, redispatch);
		asyncCommand.addEventListener(TaskFlowControlEvent.CONTINUE, redispatch);
		asyncCommand.addErrorListener(onCommandFault);
	}

	function removeBlockListeners(?asyncCommand:IOperation) {
		if (asyncCommand == null) {
			return;
		}
		
		asyncCommand.removeEventListener(TaskEvent.TASK_COMPLETE, onBlockComplete);
		asyncCommand.removeEventListener(TaskEvent.BEFORE_EXECUTE_COMMAND, redispatch);
		asyncCommand.removeEventListener(TaskEvent.AFTER_EXECUTE_COMMAND, redispatch);
		asyncCommand.removeEventListener(TaskFlowControlEvent.BREAK, redispatch);
		asyncCommand.removeEventListener(TaskFlowControlEvent.CONTINUE, redispatch);
		asyncCommand.removeErrorListener(onCommandFault);
	}

	function redispatch(event:Event) dispatchEvent(event.clone());
}