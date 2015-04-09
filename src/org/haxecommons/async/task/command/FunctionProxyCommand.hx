/*
 * Copyright 2007-2015 the original author or authors.
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
package org.haxecommons.async.task.command;
import org.haxecommons.async.command.ICommand;

/**
 * <code>ICommand</code> wrapper for <code>MethodInvoker</code> instances.
 * @author Roland Zwaga
 */
class FunctionProxyCommand implements ICommand {

	/**
	 * Creates a new <code>FunctionProxyCommand</code> instance.
	 */
	public function new(?target:Dynamic, ?methodName:String, ?args:Array<Dynamic>) {
		init(target, methodName, args);
	}
	
	public var methodInvoker(default, default):MethodInvoker;

	public function execute():Dynamic {
		#if debug
		if(methodInvoker == null) throw "the methodInvoker argument must not be null";
		#end
		
		return methodInvoker.invoke();
	}
	
	/**
	 * Initializes the <code>FunctionProxyCommand</code>.
	 */
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
		if(target == null || method == null || method.length == 0) {
			return null;
		}
		
		return Reflect.callMethod(target, Reflect.getProperty(target, method), args);
	}
}