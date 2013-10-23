/*
 * Copyright 2007-2010 the original author or authors.
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
package org.haxecommons.async.command.impl;
import haxe.Timer;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.operation.impl.AbstractOperation;

/**
 * An async mock command. For testing purposes, obviously. :)
 * @author Roland Zwaga
 */
class MockAsyncCommand extends AbstractOperation implements ICommand {
	
	/**
	 * Creates a new <code>MockAsyncCommand</code> instance.
	 * @param fail Determines if the current <code>MockAsyncCommand</code> should dispatch an error event, default is <code>false</code>.
	 * @param timeout Determines the amount of milliseconds that the <code>MockAsyncCommand</code> should wait to complete, default is <code>1</code>.
	 * @param func Optional <code>Function</code> which will be invoked when the <code>execute()</code> method is invoked.
	 */
	public function new(?fail:Bool, timeout:Int = 1, ?func:Void -> Dynamic) {
		super();
		initMockAsyncCommand(fail, timeout, func);
	}
	
	var _fail:Bool;
	var _timeout:Int = 1;
	var _func:Void -> Dynamic;

	/**
	 * Initializes the current <code>MockAsyncCommand</code> instance.
	 * @param fail Determines if the current <code>MockAsyncCommand</code> should dispatch an error event.
	 * @param timeout Determines how long the <code>MockAsyncCommand</code> should wait to complete.
	 * @param func Optional <code>Function</code> which will be invoked when the <code>execute()</code> method is invoked.
	 */
	function initMockAsyncCommand(fail:Bool, timeout:Int, func:Void -> Dynamic) {
		_fail = fail;
		_timeout = timeout;
		_func = func;
	}
	
	/**
	 * Invokes the specified <code>Function</code> if its not <code>null</code> (its result will be assigned to the <code>result</code> property).<br/>
	 * The <code>MockAsyncCommand</code> then waits the specified timeout amount and either dispatches an <code>OperationEvent.ERROR</code> or <code>OperationEvent.COMPLETE</code> event, determined by the <code>fail</code> argument.
	 * @return The result of the specified <code>Function</code>, or <code>void</code> if its <code>null</code>.
	 */
	public function execute():Dynamic {
		if (_func != null) {
			result = _func();
		}
		
		if (_fail) {
			Timer.delay(function() dispatchErrorEvent(), _timeout);
		} else {
			Timer.delay(function() dispatchCompleteEvent(), _timeout);
		}
		
		return null;
	}
}