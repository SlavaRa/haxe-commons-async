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
package org.haxecommons.async.task.command;
import org.haxecommons.async.command.ICommand;

/**
 * @author Roland Zwaga
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