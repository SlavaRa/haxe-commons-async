package org.haxecommons.async.operation.trigger.impl;
import haxe.Log;
import haxe.Timer;

/**
 * @author SlavaRa
 */
class TimeBasedOperationCompleteTrigger extends AbstractOperationCompleteTrigger {

	public function new(durationInMilliseconds:Int) {
		super();
		_durationInMilliseconds = durationInMilliseconds;
	}

	var _durationInMilliseconds:Int;
	var _timer:Timer;

	public function execute():Dynamic {
		#if debug
		Log.trace("Executing");
		#end
		
		_timer = Timer.delay(timeoutDispatcher, _durationInMilliseconds);
		return null;
	}

	public override function dispose() {
		#if debug
		Log.trace("Disposing");
		#end
		
		if (!isDisposed && _timer != null) {
			_timer.stop();
			_timer = null;
			
			#if debug
			Log.trace("Cleared timeout");
			#end
		}
	}
	
	function timeoutDispatcher() {
		#if debug
		Log.trace(_durationInMilliseconds + " ms elapsed. Dispatching complete event.");
		#end
		
		dispatchCompleteEvent();
	}

}