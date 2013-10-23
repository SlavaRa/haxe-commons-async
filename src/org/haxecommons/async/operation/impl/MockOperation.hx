package org.haxecommons.async.operation.impl;
import haxe.Timer;


/**
 * @author SlavaRa
 */
class MockOperation extends AbstractOperation {

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
			Timer.delay(function() {
					error = "error occurred";
					if (_func != null) {
						_func();
					}
					dispatchErrorEvent();
			}, _delay);
		} else {
			var foo:Dynamic->Void = function(data:Dynamic) {
				result = data;
				if (_func != null) {
					_func();
				}
				dispatchCompleteEvent();
			}
			
			Timer.delay(function() foo(_result), _delay);
		}
	}
}