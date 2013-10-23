package org.haxecommons.async.task.impl;

/**
 * @author SlavaRa
 */
class FunctionCountProvider extends CountProvider {

	public function new(func:Void -> Int) {
		#if debug
		if(func == null) throw "the func argument must not be null";
		#end
		
		super();
		
		_func = func;
	}
	
	var _func:Void -> Int;

	public override function getCount():Int return _func();
	
}