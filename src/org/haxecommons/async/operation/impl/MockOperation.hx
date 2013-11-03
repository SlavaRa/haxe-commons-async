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
import haxe.Timer;

/**
 * An async mock operation. For testing purposes, obviously. :)
 * @author Christophe Herreman
 */
class MockOperation extends AbstractOperation {
	
	/**
	 * Creates a new <code>MockOperation</code> instance.
	 */
	public function new(resultData:Dynamic, delay:Int = 1000, ?returnError:Bool, ?func:Void -> Void, useRandomDelay:Bool = true) {
		super();
		initMockOperation(resultData, delay, returnError, func, useRandomDelay);
	}

	var _result:Dynamic;
	var _func:Void -> Void;
	var _delay:Int;

	function initMockOperation(resultData:Dynamic, delay:Int, returnError:Bool, func:Void -> Void, useRandomDelay:Bool) {
		_result = resultData;
		_delay = useRandomDelay ? Std.int(Math.random() * delay) : delay;
		_func = func;
		
		if (returnError) {
			var timer = haxe.Timer.delay(function() {
				error = "error occurred";
				if (_func != null) {
					_func();
				}
				dispatchErrorEvent();
			}, _delay);
			timer.run();
		} else {
			var timer = haxe.Timer.delay(function() {
				result = _result;
				if (_func != null) {
					_func();
				}
				dispatchCompleteEvent();
			}, _delay);
			timer.run();
		}
		
	}
}