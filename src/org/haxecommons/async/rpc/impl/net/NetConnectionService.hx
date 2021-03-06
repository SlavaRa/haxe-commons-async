/*
 * Copyright 2007 - 2015 the original author or authors.
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
package org.haxecommons.async.rpc.impl.net;
import org.haxecommons.async.operation.impl.NetConnectionOperation;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.rpc.IService;
import openfl.net.NetConnection;

/**
 * Service that invokes methods on a NetConnection and returns an IOperation for each of these calls.
 * @author Christophe Herreman
 */
class NetConnectionService implements IService {
	
	/**
	 * Creates a new NetConnectionService
	 * @param netConnection the netconnection used by this service
	 */
	public function new(?netConnection:NetConnection) this.netConnection = netConnection;
	
	/**
	 * Returns the NetConnection used by this service
	 */
	public var netConnection(default, default):NetConnection;
	
	/**
	 * @inheritDoc
	 */
	public function call(methodName:String, parameters):IOperation {
		#if debug
		if(netConnection == null) throw "the netConnection argument must not be null";
		#end
		return new NetConnectionOperation(netConnection, methodName, parameters);
	}
}