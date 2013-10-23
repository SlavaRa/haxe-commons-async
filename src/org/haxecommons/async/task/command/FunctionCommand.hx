package org.haxecommons.async.task.command;
import org.haxecommons.async.command.ICommand;

/**
 * @author SlavaRa
 */
class FunctionCommand implements ICommand {

	public function new(func:Void -> Dynamic) {
		#if debug
		if(func == null) throw "the func argument must not be null";
		#end
		
		_func = func;
	}
	
	var _func:Void -> Dynamic;

	public function execute():Dynamic return _func();
}