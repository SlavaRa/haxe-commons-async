package org.haxecommons.async.operation.trigger.impl;
import flash.errors.IllegalOperationError;
import haxe.Log;
import org.haxecommons.async.operation.event.OperationEvent;

/**
 * @author SlavaRa
 */
class AbstractParallelOperationCompleteTrigger extends AbstractCompositeOperationCompleteTrigger {

	public function new() super();
	
	public override function dispose() {
		if (!isDisposed) {
			#if debug
			Log.trace("Disposing");
			#end
			
			removeTriggerListeners();
			super.dispose();
		}
	}

	override function doExecute() {
		addTriggerListeners();
		startTriggers();
	}

	function onTriggerCompleteHandler(event:OperationEvent) throw new IllegalOperationError();

	function addTriggerListeners() for (it in triggers) it.addCompleteListener(onTriggerCompleteHandler);

	function removeTriggerListeners() {
		#if debug
		Log.trace("Removing trigger listeners");
		#end
		
		for(it in triggers) {
			it.removeCompleteListener(onTriggerCompleteHandler);
		}
	}

	function startTriggers() for(it in triggers) it.execute();
}