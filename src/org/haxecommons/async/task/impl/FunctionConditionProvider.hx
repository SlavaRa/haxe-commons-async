package org.haxecommons.async.task.impl;
import org.haxecommons.async.task.IConditionProvider;

/**
 * @author SlavaRa
 */
class FunctionConditionProvider implements IConditionProvider {

	public function new(func:Void -> Bool) {
		#if debug
		if(func == null) throw "the func argument must not be null";
		#end
		
		_func = func;
	}
	
	var _func:Void -> Bool;

	public function getResult():Bool return _func != null ? _func() : false;
	
}