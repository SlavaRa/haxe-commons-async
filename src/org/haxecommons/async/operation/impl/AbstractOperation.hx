package org.haxecommons.async.operation.impl;
import flash.events.EventDispatcher;
import haxe.Timer;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.IOperation;


/**
 * @author SlavaRa
 */
class AbstractOperation extends EventDispatcher implements IOperation {

	public function new(timeoutInMilliseconds:Int = 0, autoStartTimeout:Bool = true) {
		super(this);
		
		timeout = timeoutInMilliseconds;
		_autoStartTimeout = autoStartTimeout;
		
		if (autoStartTimeout) {
			startTimeout();
		}
	}

	public var error(default, default):Dynamic;
	public var result(default, default):Dynamic;
	public var timeout(default, default):Int = 0;
	
	var _autoStartTimeout:Bool = true;
	var _timedOut:Bool = false;
	var _timer:Timer;
	var _timeoutId:UInt;
	
	public function addCompleteListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool) {
		addEventListener(OperationEvent.COMPLETE, listener, useCapture, priority, useWeakReference);
	}

	public function addErrorListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool) {
		addEventListener(OperationEvent.ERROR, listener, useCapture, priority, useWeakReference);
	}
	
	public function addTimeoutListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool) {
		addEventListener(OperationEvent.TIMEOUT, listener, useCapture, priority, useWeakReference);
	}
	
	public function dispatchCompleteEvent(?result:Dynamic):Bool {
		if (_timedOut) {
			return false;
		}
		
		if (result != null) {
			this.result = result;
		}
		
		return dispatchEvent(OperationEvent.createCompleteEvent(this));
	}

	public function dispatchErrorEvent(?error:Dynamic):Bool {
		if (_timedOut) {
			return false;
		}
		
		if (error != null) {
			this.error = error;
		}
		
		return dispatchEvent(OperationEvent.createErrorEvent(this));
	}

	public function dispatchTimeoutEvent():Bool {
		return dispatchEvent(OperationEvent.createTimeoutEvent(this));
	}
	
	public function removeCompleteListener(listener:Dynamic -> Void, ?useCapture:Bool) {
		removeEventListener(OperationEvent.COMPLETE, listener, useCapture);
	}

	public function removeErrorListener(listener:Dynamic -> Void, ?useCapture:Bool) {
		removeEventListener(OperationEvent.ERROR, listener, useCapture);
	}

	public function removeTimeoutListener(listener:Dynamic -> Void, ?useCapture:Bool) {
		removeEventListener(OperationEvent.TIMEOUT, listener, useCapture);
	}

	function completeHandler(event:OperationEvent) stopTimeout();

	function errorHandler(event:OperationEvent) stopTimeout();

	function startTimeout() {
		if (timeout <= 0) {
			return;
		}
		
		addCompleteListener(completeHandler);
		addErrorListener(errorHandler);
		
		_timer = Timer.delay(timeoutHandler, timeout);
	}

	function stopTimeout() {
		if(_timer == null) {
			return;
		}
		
		_timer.stop();
		_timer = null;
	}

	function timeoutHandler() {
		_timedOut = true;
		dispatchTimeoutEvent();
	}
}