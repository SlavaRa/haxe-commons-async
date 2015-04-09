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
package org.haxecommons.async.operation.impl;
import openfl.events.EventDispatcher;
import haxe.Timer;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.IOperation;

/**
 * Abstract base class for <code>IOperation</code> implementations.
 * @author Christophe Herreman
 */
class AbstractOperation extends EventDispatcher implements IOperation {

	/**
	 * Creates a new <code>AbstractOperation</code>.
	 *
	 * @param timeoutInMilliseconds
	 * @param autoStartTimeout
	 */
	public function new(timeoutInMilliseconds:Int = 0, autoStartTimeout:Bool = true) {
		super(this);
		
		timeout = timeoutInMilliseconds;
		_autoStartTimeout = autoStartTimeout;
		
		if (autoStartTimeout) {
			startTimeout();
		}
	}
	
	/**
	 * Sets the error of this operation
	 *
	 * @param value the error of this operation
	 */
	public var error(default, default):Dynamic;
	
	/**
	 * Sets the result of this operation.
	 *
	 * @param value the result of this operation
	 */
	public var result(default, default):Dynamic;
	
	/**
	 * @inheritDoc
	 */
	public var timeout(default, default):Int = 0;
	
	var _autoStartTimeout:Bool = true;
	var _timedOut:Bool = false;
	var _timer:Timer;
	
	/**
	 * @inheritDoc
	 */
	public function addCompleteListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool) {
		addEventListener(OperationEvent.COMPLETE, listener, useCapture, priority, useWeakReference);
	}
	
	/**
	 * @inheritDoc
	 */
	public function addErrorListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool) {
		addEventListener(OperationEvent.ERROR, listener, useCapture, priority, useWeakReference);
	}
	
	/**
	 * @inheritDoc
	 */
	public function addTimeoutListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool) {
		addEventListener(OperationEvent.TIMEOUT, listener, useCapture, priority, useWeakReference);
	}
	
	/**
	 * Convenience method for dispatching a <code>OperationEvent.COMPLETE</code> event.
	 *
	 * @return true if the event was dispatched; false if not
	 */
	public function dispatchCompleteEvent(?result:Dynamic):Bool {
		if (_timedOut) {
			return false;
		}
		
		if (result != null) {
			this.result = result;
		}
		
		return dispatchEvent(OperationEvent.createCompleteEvent(this));
	}
	
	/**
	 * Convenience method for dispatching a <code>OperationEvent.ERROR</code> event.
	 *
	 * @return true if the event was dispatched; false if not
	 */
	public function dispatchErrorEvent(?error:Dynamic):Bool {
		if (_timedOut) {
			return false;
		}
		
		if (error != null) {
			this.error = error;
		}
		
		return dispatchEvent(OperationEvent.createErrorEvent(this));
	}
	
	/**
	 * Convenience method for dispatching a <code>OperationEvent.TIMEOUT</code> event.
	 *
	 * @return true if the event was dispatched; false if not
	 */
	public function dispatchTimeoutEvent():Bool {
		return dispatchEvent(OperationEvent.createTimeoutEvent(this));
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeCompleteListener(listener:Dynamic -> Void, ?useCapture:Bool) {
		removeEventListener(OperationEvent.COMPLETE, listener, useCapture);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeErrorListener(listener:Dynamic -> Void, ?useCapture:Bool) {
		removeEventListener(OperationEvent.ERROR, listener, useCapture);
	}

	/**
	 * @inheritDoc
	 */
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