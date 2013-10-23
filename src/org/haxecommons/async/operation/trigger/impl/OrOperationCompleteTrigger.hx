package org.haxecommons.async.operation.trigger.impl;
import haxe.Log;
import org.haxecommons.async.operation.event.OperationEvent;

/**
 * @author SlavaRa
 */
class OrOperationCompleteTrigger extends AbstractParallelOperationCompleteTrigger {

	public function new() super();

	public override function toString() return new ToStringBuilder(this).append(triggers.length, "numTriggers").toString();
	
	override function onTriggerCompleteHandler(event:OperationEvent) {
		#if debug
		Log.trace('Trigger complete ${event.operation}');
		#end
		
		dispose();
		dispatchCompleteEvent();
	}
}