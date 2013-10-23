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
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.task.IConditionProvider;
import org.haxecommons.async.task.IWhileBlock;

/**
 * @inheritDoc
 */
class WhileBlock extends AbstractTaskBlock implements IWhileBlock {

	public function new(conditionProvider:IConditionProvider) {
		#if debug
		if(conditionProvider == null) throw "the conditionProvider argument must not be null";
		#end
		
		super();
		
		this.conditionProvider = conditionProvider;
	}
	
	public var conditionProvider(default, default):IConditionProvider;

	public override function execute():Dynamic {
		finishedCommandList = [];
		if (Std.is(conditionProvider, IOperation)) {
			var async:IOperation = cast(conditionProvider, IOperation);
			addConditionalListeners(async);
			if (Std.is(conditionProvider, ICommand)) {
				cast(conditionProvider, ICommand).execute();
			}
		} else {
			executeBlock();
		}
		return null;
	}

	function executeBlock() {
		if (conditionProvider.getResult()) {
			executeNextCommand();
		} else {
			completeExecution();
		}
	}

	function onConditionalResult(event:OperationEvent) {
		removeConditionalListeners(cast event.target);
		executeBlock();
	}

	function onConditionalFault(event:OperationEvent) {
		removeConditionalListeners(cast event.target);
		dispatchErrorEvent(cast event.target);
	}

	function addConditionalListeners(asyncCommand:IOperation) {
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

}