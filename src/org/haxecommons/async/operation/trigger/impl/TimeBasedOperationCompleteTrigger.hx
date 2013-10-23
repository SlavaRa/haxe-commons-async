/*
 * Copyright 2007-2012 the original author or authors.
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
package org.haxecommons.async.operation.trigger.impl;
import haxe.Log;
import haxe.Timer;

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