package org.haxecommons.async.task.command;

import org.haxecommons.async.command.ICommand;

/**
 * @author SlavaRa
 */
class FunctionProxyCommand implements ICommand {

	public function new(?target:Dynamic, ?methodName:String = "", ?args:Array<Dynamic>) {
		init(target, methodName, args);
	}
	
	public var methodInvoker(default, default):MethodInvoker;

	public function execute():Dynamic {
		#if debug
		if(methodInvoker == null) throw "the methodInvoker argument must not be null";
		#end
		
		return methodInvoker.invoke();
	}
	
	function init(?target:Dynamic, methodName:String, args:Array<Dynamic>) {
		if(target == null || methodName == null || methodName.length == 0) {
			return;
		}
		
		methodInvoker = new MethodInvoker();
		methodInvoker.target = target;
		methodInvoker.method = methodName;
		methodInvoker.args = args;
	}
}

class MethodInvoker {
	
	public function new() {
		args = [];
	}

	public var target:Dynamic;
	public var method:String;
	public var args:Array<Dynamic>;

	public function invoke():Dynamic {
		if(Reflect.hasField(target, method)) {
			return Reflect.callMethod(target, Reflect.getProperty(target, method), args);
		}
		
		return null;
	}
}