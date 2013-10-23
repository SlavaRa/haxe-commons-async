package org.haxecommons.async.operation.trigger.impl;
import haxe.Log;
import org.haxecommons.async.operation.event.OperationEvent;

/**
 * @author SlavaRa
 */
class AndOperationCompleteTrigger extends AbstractParallelOperationCompleteTrigger {

	public function new() super();
	
	override function trigger_completeHandler(event:OperationEvent) {
		if (allTriggersAreComplete()) {
			#if debug
			Log.trace("All triggers complete")
			#end
			
			dispatchCompleteEvent();
		}
	}

	function allTriggersAreComplete():Bool {
		for (it in triggers) {
			if (!it.isComplete) {
				return false;
			}
		}
		return true;
	}
	
}