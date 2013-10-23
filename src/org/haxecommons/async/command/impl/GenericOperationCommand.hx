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
package org.haxecommons.async.command.impl;
import flash.system.ApplicationDomain;
import org.haxecommons.async.command.IAsyncCommand;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.impl.AbstractProgressOperation;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.operation.IProgressOperation;

/**
 * Generic <code>ICommand</code> implementation that can be used to wrap arbitrary <code>IOperation</code> or <code>IProgressOperation</code>
 * implementations. This way immediate execution of the <code>IOperation</code> can be defered to an instance
 * of this class.
 * @see org.haxecommons.async.operation.IOperation IOperation
 * @see org.haxecommons.async.operation.IProgressOperation IProgressOperation
 * @author Roland Zwaga
 */
class GenericOperationCommand extends AbstractProgressOperation implements IAsyncCommand  /*IApplicationDomainAware */{
	
	/**
	 * Static factory method to create a new <code>GenericOperationCommand</code> instance.
	 * @param cls The specified <code>Class</code> (must be an <code>IOperation</code> implementation).
	 * @param constructorArgs An optional <code>Array</code> of constructor arguments for the specified <code>Class</code>.
	 * @return A new <code>GenericOperationCommand</code> instance.
	 */
	public static function createNew(cls:Class<Dynamic>, ?constructorArgs:Array<Dynamic>):GenericOperationCommand {
		var goc:GenericOperationCommand = new GenericOperationCommand(cls);
		if (constructorArgs != null) {
			goc.constructorArguments = constructorArgs;
		}
		
		return goc;
	}
	
	/**
	 * Creates a new <code>GenericOperationCommand</code> instance.
	 * @param operationClass The specified <code>IOperation</code> implementation that will be created.
	 * @param constructorArgs An array of arguments that will be passed to the constructor of the specified <code>IOperation</code> implementation.
	 */
	public function new(operationClass:Class<Dynamic>, ?constructorArgs:Array<Dynamic>) {
		super();
		initGenericOperationCommand(operationClass, constructorArgs);
	}
	
	/**
	 * The specified <code>IOperation</code> implementation that will be created when the current <code>GenericOperationCommand</code> is executed.
	 */
	public var operationClass(default, null):Class<Dynamic>;
	public var applicationDomain(default, null):ApplicationDomain;
	
	/**
	 * An array of arguments that will be passed to the constructor of the specified <code>IOperation</code> implementation.
	 */
	public var constructorArguments(default, default):Array<Dynamic>;
	
	var _operation:IOperation;

	function initGenericOperationCommand(operationClass:Class<Dynamic>, ?constructorArgs:Array<Dynamic>) {
		#if debug
		if(operationClass == null) throw "the operationClass argument must not be null";
		#end
		
		this.operationClass = operationClass;
		constructorArguments = constructorArgs;
	}
	
	/**
	 * Creates an instance of the specified <code>IOperation</code> with the specified constructor arguments.
     * Adds a complete and error event listener to redispatch the <code>IOperation</code> events through the
     * current <code>GenericOperationCommand</code>.
     */
	public function execute():Dynamic {
		_operation = Type.createInstance(operationClass, constructorArguments);
		_operation.addCompleteListener(operationComplete);
		_operation.addErrorListener(operationError);
		
		if (Std.is(_operation, IProgressOperation)) {
			cast(_operation, IProgressOperation).addProgressListener(operationProgress);
		}
		
		return null;
	}
	
	/**
	 * Event handler for the specified <code>IOperation</code>'s <code>OperationEvent.COMPLETE</code> event.
	 */
	function operationComplete(event:OperationEvent){
		removeListeners();
		dispatchCompleteEvent(event.operation.result);
	}
	
	/**
	 * Event handler for the specified <code>IOperation</code>'s <code>OperationEvent.ERROR</code> event.
	 */
	function operationError(event:OperationEvent){
		removeListeners();
		dispatchErrorEvent(event.operation.error);
	}
	
	/**
	 * Event handler for the specified <code>IProgressOperation</code>'s <code>OperationEvent.PROGRESS</code> event.
	 */
	function operationProgress(event:OperationEvent) {
		var operation:IProgressOperation = cast(event.operation, IProgressOperation);
		progress = operation.progress;
		total = operation.total;
		dispatchProgressEvent();
	}
	
	/**
	 * Removes the complete and error listeners from the <code>IOperation</code>'s instance.
	 */
	function removeListeners(){
		if (_operation == null) {
			return;
		}
		
		_operation.removeCompleteListener(operationComplete);
		_operation.removeErrorListener(operationError);
		if (Std.is(_operation, IProgressOperation)) {
			cast(_operation, IProgressOperation).removeProgressListener(operationProgress);
		}
	}
}