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
package org.haxecommons.async.operation;
import openfl.events.Event;
import openfl.events.IEventDispatcher;

/**
 * The IOperation interface describes an asynchronous operation. It serves as handle for asynchronous executions
 * to which you can attach listeners in order to know when the operation is done executing or when an error
 * occurred during the execution of the operation.
 *
 * <p>An operation has a <code>result</code> property in case the operation needs to return a result and
 * an <code>error</code> in case an error occurred during the execution of the operation.</p>
 *
 * <p>Convenience methods are provided to add and remove listeners to the events dispatched by an operation.</p>
 *
 * @author Christophe Herreman
 */
interface IOperation extends IEventDispatcher {
	
	/**
	 * The result of this operation or <code>null</code> if the operation does not have a result.
	 *
	 * @return the result of the operation or <code>null</code>
	 */
	var result(default, null):Dynamic;
	
	/**
	 * The error of this operation or <code>null</code> if no error occurred during this operation.
	 *
	 * @return the error of the operation or <code>null</code>
	 */
	var error(default, null):Dynamic;
	
	/**
	 * The timeout in milliseconds. A value less or equal to zero prevents a timeout.
	 */
	var timeout(default, default):Int;
	
	/**
	 * Convenience method for adding a listener to the OperationEvent.COMPLETE event.
	 *
	 * @param listener the event handler function
	 */
	function addCompleteListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool):Void;
	
	/**
	 * Convenience method for adding a listener to the OperationEvent.ERROR event.
	 *
	 * @param listener the event handler function
	 */
	function addErrorListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool):Void;
	
	/**
	 * Convenience method for adding a listener to the OperationEvent.TIMEOUT event.
	 *
	 * @param listener the event handler function
	 */
	function addTimeoutListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool):Void;
	
	/**
	 * Convenience method for removing a listener from the OperationEvent.COMPLETE event.
	 *
	 * @param listener the event handler function
	 */
	function removeCompleteListener(listener:Dynamic -> Void, ?useCapture:Bool):Void;
	
	/**
	 * Convenience method for removing a listener from the OperationEvent.ERROR event.
	 *
	 * @param listener the event handler function
	 */
	function removeErrorListener(listener:Dynamic -> Void, ?useCapture:Bool):Void;
	
	/**
	 * Convenience method for removing a listener from the OperationEvent.TIMEOUT event.
	 *
	 * @param listener the event handler function
	 */
	function removeTimeoutListener(listener:Dynamic -> Void, ?useCapture:Bool):Void;
}