package org.haxecommons.async.operation.trigger.impl;
import flash.errors.IllegalOperationError;
import org.haxecommons.async.operation.impl.AbstractOperation;
import org.haxecommons.async.operation.trigger.IOperationCompleteTrigger;


/**
 * @author SlavaRa
 */
class AbstractOperationCompleteTrigger extends AbstractOperation implements IOperationCompleteTrigger {

	public function new() super();
	
	public var isComplete(default, null):Bool = false;
	public var isDisposed(default, null):Bool = false;

	public function execute():Dynamic throw new IllegalOperationError("execute is abstract");

	public function dispose() isDisposed = true;

	public override function dispatchCompleteEvent(result:Dynamic = null):Bool {
		var result2 = super.dispatchCompleteEvent(result);
		isComplete = true;
		return result2;
	}
}