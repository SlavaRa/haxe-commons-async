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
package org.haxecommons.async.operation;

/**
 * Subinterface of <code>IOperation</code> that contains information about the progress of an operation.
 *
 * @author Christophe Herreman
 */
interface IProgressOperation extends IOperation {
	
	/**
	 * The progress of this operation.
	 */
	var progress(default, null):Int;
	
	/**
	 * The total amount of progress this operation should make before being done.
	 */
	var total(default, null):Int;
	
	/**
	 * Convenience method for adding a listener to the OperationEvent.PROGRESS event.
	 *
	 * @param listener the event handler function
	 */
	function addProgressListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool):Void;
	
	/**
	 * Convenience method for removing a listener from the OperationEvent.PROGRESS event.
	 *
	 * @param listener the event handler function
	 */
	function removeProgressListener(listener:Dynamic -> Void, ?useCapture:Bool):Void;
}