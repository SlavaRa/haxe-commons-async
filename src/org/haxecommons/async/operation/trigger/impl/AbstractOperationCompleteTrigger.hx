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
package org.haxecommons.async.operation.trigger.impl;
import openfl.errors.IllegalOperationError;
import org.haxecommons.async.operation.impl.AbstractOperation;
import org.haxecommons.async.operation.trigger.IOperationCompleteTrigger;

class AbstractOperationCompleteTrigger extends AbstractOperation implements IOperationCompleteTrigger {

	public function new() super();
	
	public var isComplete(default, null):Bool = false;
	public var isDisposed(default, null):Bool = false;

	public function execute():Dynamic throw new IllegalOperationError("execute is abstract");

	public function dispose() isDisposed = true;

	public override function dispatchCompleteEvent(result:Dynamic = null):Bool {
		var result2 = super.dispatchCompleteEvent(result);
		isComplete = true;
		return result2;
	}
}