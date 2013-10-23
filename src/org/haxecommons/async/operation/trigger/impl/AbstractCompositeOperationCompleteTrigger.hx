/*
 * Copyright 2007-2012 the original author or authors.
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
package org.haxecommons.async.operation.trigger.impl;
import flash.errors.IllegalOperationError;
import haxe.Log;
import org.haxecommons.async.operation.trigger.ICompositeOperationCompleteTrigger;
import org.haxecommons.async.operation.trigger.IOperationCompleteTrigger;

class AbstractCompositeOperationCompleteTrigger extends AbstractOperationCompleteTrigger implements ICompositeOperationCompleteTrigger {

	public function new() {
		super();
		triggers = [];
	}
	
	public var isExecuting(default, null):Bool;
	
	var triggers:Array<IOperationCompleteTrigger>;

	public override function dispose() {
		if (isDisposed) {
			return;
		}
		
		disposeTriggers();
		super.dispose();
	}

	public function addTrigger(trigger:IOperationCompleteTrigger) {
		Assert.state(!isExecuting);
		triggers.push(trigger);
	}

	@:final public override function execute():Dynamic {
		isExecuting = true;
		doExecute();
		return null;
	}

	function doExecute() throw new IllegalOperationError();

	function disposeTriggers() {
		#if debug
		Log.trace("Disposing triggers");
		#end
		
		for (it in triggers) {
			it.dispose();
		}
	}
	
}