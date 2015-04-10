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
import openfl.errors.IllegalOperationError;
import haxe.Log;
import org.haxecommons.async.operation.event.OperationEvent;

class AbstractParallelOperationCompleteTrigger extends AbstractCompositeOperationCompleteTrigger {

	public function new() super();
	
	public override function dispose() {
		if (!isDisposed) {
			#if debug
			Log.trace("Disposing");
			#end
			
			removeTriggerListeners();
			super.dispose();
		}
	}

	override function doExecute() {
		addTriggerListeners();
		startTriggers();
	}

	function onTriggerCompleteHandler(event:OperationEvent) throw new IllegalOperationError();

	function addTriggerListeners() for (it in triggers) it.addCompleteListener(onTriggerCompleteHandler);

	function removeTriggerListeners() {
		#if debug
		Log.trace("Removing trigger listeners");
		#end
		
		for(it in triggers) {
			it.removeCompleteListener(onTriggerCompleteHandler);
		}
	}

	function startTriggers() for(it in triggers) it.execute();
}