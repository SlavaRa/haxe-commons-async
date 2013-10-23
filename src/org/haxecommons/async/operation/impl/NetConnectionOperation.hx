package org.haxecommons.async.operation.impl;
import haxe.Timer;

/**
 * @author SlavaRa
 */
class NetConnectionOperation extends AbstractOperation {

	public function new(netConnection:NetConnection, methodName:String, ?parameters:Array<Dynamic>) {
		super();
		initNetConnectionOperation(netConnection, methodName, parameters);
	}
	
	public var methodName(default, null):String;
	public var parameters(default, null):Array<Dynamic>;
	public var netConnection(default, default):NetConnection;
	
	function initNetConnectionOperation(netConnection:NetConnection, methodName:String, parameters:Array) {
		#if debug
		if(netConnection == null) throw "the netConnection argument must not be null";
		if(methodName == null || methodName.length == 0) "The method name must not be null or an empty string";
		#end
		
		this.netConnection = netConnection;
		this.methodName = methodName;
		this.parameters = parameters;
		
		Timer.delay(invokeRemoteMethod, 0);
	}

	function invokeRemoteMethod() {
		var responder = new Responder(resultHandler, faultHandler);
		var parameters:Array<Dynamic> = [methodName, responder];
		parameters = parameters.concat(parameters);
		netConnection.call.apply(netConnection, parameters);
	}
	
	function resultHandler(result:Dynamic) {
		this.result = result;
		dispatchCompleteEvent();
	}

	function faultHandler(fault:Dynamic) {
		error = fault;
		dispatchErrorEvent();
	}
}