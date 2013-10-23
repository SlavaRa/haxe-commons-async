package org.haxecommons.async.task.impl;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.task.IConditionProvider;
import org.haxecommons.async.task.IWhileBlock;

/**
 * @author SlavaRa
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