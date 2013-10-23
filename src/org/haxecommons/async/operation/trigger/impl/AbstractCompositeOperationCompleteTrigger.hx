package org.haxecommons.async.operation.trigger.impl;
import flash.errors.IllegalOperationError;
import haxe.Log;
import org.haxecommons.async.operation.trigger.ICompositeOperationCompleteTrigger;
import org.haxecommons.async.operation.trigger.IOperationCompleteTrigger;

/**
 * @author SlavaRa
 */
class AbstractCompositeOperationCompleteTrigger extends AbstractOperationCompleteTrigger implements ICompositeOperationCompleteTrigger {

	public function new() {
		super();
		triggers = [];
	}
	
	public var isExecuting(default, null):Bool;
	
	var triggers:Array<IOperationCompleteTrigger>;

	public override function dispose() {
		if (isDisposed) {
			return;
		}
		
		disposeTriggers();
		super.dispose();
	}

	public function addTrigger(trigger:IOperationCompleteTrigger) {
		Assert.state(!isExecuting);
		triggers.push(trigger);
	}

	@:final public override function execute():Dynamic {
		isExecuting = true;
		doExecute();
		return null;
	}

	function doExecute() throw new IllegalOperationError();

	function disposeTriggers() {
		#if debug
		Log.trace("Disposing triggers");
		#end
		
		for (it in triggers) {
			it.dispose();
		}
	}
	
}