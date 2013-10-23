package org.haxecommons.async.operation.trigger;

/**
 * @author SlavaRa
 */

interface ICompositeOperationCompleteTrigger extends IOperationCompleteTrigger {
	function addTrigger(trigger:IOperationCompleteTrigger);
}