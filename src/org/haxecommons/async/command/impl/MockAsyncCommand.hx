package org.haxecommons.async.command.impl;
import haxe.Timer;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.operation.impl.AbstractOperation;

/**
 * @author SlavaRa
 */
class MockAsyncCommand extends AbstractOperation implements ICommand {

	public function new(?fail:Bool, timeout:Int = 1, ?func:Void -> Dynamic) {
		super();
		initMockAsyncCommand(fail, timeout, func);
	}
	
	var _fail:Bool;
	var _timeout:Int = 1;
	var _func:Void -> Dynamic;

	function initMockAsyncCommand(fail:Bool, timeout:Int, func:Void -> Dynamic) {
		_fail = fail;
		_timeout = timeout;
		_func = func;
	}

	public function execute():Dynamic {
		if (_func != null) {
			result = _func();
		}
		
		if (_fail) {
			Timer.delay(function() dispatchErrorEvent(), _timeout);
		} else {
			Timer.delay(function() dispatchCompleteEvent(), _timeout);
		}
		
		return null;
	}

}