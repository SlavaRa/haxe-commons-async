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
import org.haxecommons.async.operation.IProgressOperation;

/**
 * Abstract base class for <code>IProgressOperation</code> implementations.
 * @author Roland Zwaga
 */
class AbstractProgressOperation extends AbstractOperation implements IProgressOperation {
	
	/**
	 * Creates a new <code>AbstractProgressOperation</code> instance.
	 */
	public function new(timeoutInMilliseconds:Int = 0, autoStartTimeout:Bool = true) {
		super(timeoutInMilliseconds, autoStartTimeout);
	}
	
	/**
	 * Sets the progress of this operation.
	 * @param value the progress of this operation
	 */
	public var progress(default, default):Int;
	
	/**
	 * Sets the total amount of progress this operation should make before being done.
	 * @param value the total amount of progress this operation should make before being done
	 */
	public var total(default, default):Int;
	
	/**
	 * @inheritDoc
	 */
	public function addProgressListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool) {
		addEventListener(OperationEvent.PROGRESS, listener, useCapture, priority, useWeakReference);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeProgressListener(listener:Dynamic -> Void, ?useCapture:Bool) {
		removeEventListener(OperationEvent.PROGRESS, listener, useCapture);
	}
	
	/**
	 * Convenience method for dispatching a <code>OperationEvent.PROGRESS</code> event.
	 * @return true if the event was dispatched; false if not
	 */
	function dispatchProgressEvent() dispatchEvent(OperationEvent.createProgressEvent(this));
}