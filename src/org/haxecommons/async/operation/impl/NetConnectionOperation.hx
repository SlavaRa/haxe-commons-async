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
import openfl.net.NetConnection;

/**
 * An <code>IOperation</code> that invokes a method on a <code>NetConnection</code>.
 * @see openfl.net.NetConnection
 * @author Christophe Herreman
 */
class NetConnectionOperation extends AbstractOperation {
	
	/**
	 * Creates a new <code>NetConnectionOperation</code> instance.
	 * @param netConnection the netconnection on which the method is invoked
	 * @param methodName the name of the method to be invoked
	 * @param parameters the parameters passed to the invoked method
	 */
	public function new(netConnection:NetConnection, methodName:String, ?parameters:Array<Dynamic>) {
		super();
		initNetConnectionOperation(netConnection, methodName, parameters);
	}
	
	public var methodName(default, null):String;
	public var parameters(default, null):Array<Dynamic>;
	
	/**
	 * The <code>NetConnection</code> used by the current <code>NetConnectionOperation</code>.
	 * @return the netconnection
	 */
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