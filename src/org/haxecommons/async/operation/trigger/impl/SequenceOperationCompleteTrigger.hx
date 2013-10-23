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
import org.haxecommons.async.command.CompositeCommandKind;
import org.haxecommons.async.command.impl.CompositeCommand;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.trigger.IOperationCompleteTrigger;

class SequenceOperationCompleteTrigger extends AbstractCompositeOperationCompleteTrigger {

	public function new() {
		super();
		_commandQueue = new CompositeCommand(CompositeCommandKind.SEQUENCE);
		_commandQueue.addCompleteListener(commandQueue_completeHandler);
	}
	
	var _commandQueue:CompositeCommand;

	public override function addTrigger(trigger:IOperationCompleteTrigger) {
		super.addTrigger(trigger);
		_commandQueue.addCommand(trigger);
	}

	public override function dispose() {
		if (isDisposed) {
			return;
		}
		
		_commandQueue.removeCompleteListener(commandQueue_completeHandler);
		_commandQueue = null;
		super.dispose();
	}
	
	override function doExecute() _commandQueue.execute();

	function commandQueue_completeHandler(event:OperationEvent) {
		dispose();
		dispatchCompleteEvent();
	}
}