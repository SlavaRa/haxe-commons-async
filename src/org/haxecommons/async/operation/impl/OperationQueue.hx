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
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.operation.IOperationQueue;

/**
 * A queue of <code>IOperation</code> objects that dispatches an <code>OperationEvent.COMPLETE</code> event when
 * all operations in the queue have completed (and dispatched a corresponding <code>OperationEvent.COMPLETE</code>
 * event). Useful for invoking multiple operations and getting informed when all operations are finished without
 * the need to keep track of each individual instance.
 * @see org.haxecommons.async.operation.OperationEvent OperationEvent
 * @author Christophe Herreman
 */
class OperationQueue extends AbstractProgressOperation implements IOperationQueue {
	
	/**
	 * A static counter of queues.
	 */
	static var _queueCounter:UInt = 0;
	
	/**
	 * Creates a new <code>OperationQueue</code> instance.
	 * @param name the name of the queue; if no name is given, one will be generated.
	 */
	public function new(?name:String) {
		super();
		_queueCounter++;
		_operations = [];
		this.name = (name == null || name.length == 0) ? "queue_" +Std.string(_queueCounter) : name;
	}
	
	/**
	 * The name of the queue, or the generated name if none was passed into the constructor.
	 */
	public var name(default, null):String;
	
	var _operations:Array<IOperation>;
	
	/**
	 * Adds an operation to the queue. The operation will not be added if it was previously added to the queue.
	 * @param operation The <code>IOperation</code> that needs to be added to the current queue.
	 * @return true if the operation was added; false if not
	 */
	public function addOperation(operation:IOperation):Bool {
		if (hasOperation(operation)) {
			return false;
		}
		
		_operations[_operations.length] = operation;
		addOperationListeners(operation);
		total++;
		return true;
	}

	public function hasOperation(operation:IOperation):Bool return Lambda.has(_operations, operation);
	
	/**
	 * @return A <code>String</code> representation of the current <code>OperationQueue</code>.
	 */
	public override function toString():String {
		return "[OperationQueue(name='" + name + "', operations:'" + _operations.length + "', total:'" + total + "', progress:'" + progress + "')]";
	}
	
	/**
	 * Adds the <code>operation_completeHandler</code> and <code>operation_errorHandler</code> event handler to
	 * the specified <code>operation</code> instance.
	 */
	function addOperationListeners(?operation:IOperation) {
		if (operation == null) {
			return;
		}
		
		operation.addCompleteListener(operation_completeHandler);
		operation.addErrorListener(operation_errorHandler);
	}
	
	/**
	 * Handles the completion of an operation in this queue. An <code>OperationEvent.PROGRESS</code> event is
	 * dispatched when more operations are left in the queue, or if all operations are complete an
	 * <code>OperationEvent.COMPLETE</code> is dispatched.
	 * @param event the event of the operation that completed
	 */
	function operation_completeHandler(event:OperationEvent) {
		removeOperationListeners(event.operation);
		removeOperation(event.operation);
		progress++;
		
		if (_operations.length == 0) {
			dispatchCompleteEvent();
		} else {
			dispatchProgressEvent();
		}
	}
	
	/**
	 * Handles an error from an operation in this queue.
	 */
	function operation_errorHandler(event:OperationEvent) {
		removeOperationListeners(event.operation);
		removeOperation(event.operation);
		progress++;
		
		if (Std.is(event.operation, OperationQueue)) {
			var queue = cast(event.operation, OperationQueue);
			var queueComplete = (queue.progress == queue.total);
			
			if (queueComplete) {
				redispatchErrorAndContinue(event.error);
				return;
			}
		}
		
		redispatchErrorAndContinue(event.error);
	}

	function redispatchErrorAndContinue(error:Dynamic) {
		dispatchErrorEvent(error);
		
		if (_operations.length == 0) {
			dispatchCompleteEvent();
		} else {
			dispatchProgressEvent();
		}
	}

	function removeOperation(operation:IOperation) _operations.remove(operation);
	
	/**
	 * Removes the <code>operation_completeHandler</code> and <code>operation_errorHandler</code> event handler from
	 * the specified <code>operation</code> instance.
	 */
	function removeOperationListeners(?operation:IOperation) {
		if (operation == null) {
			return;
		}
		
		operation.removeCompleteListener(operation_completeHandler);
		operation.removeErrorListener(operation_errorHandler);
	}
	
}