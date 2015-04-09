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
import openfl.events.Event;
import openfl.events.EventDispatcher;
import haxe.ds.WeakMap.WeakMap;
import org.hamcrest.Exception.MissingImplementationException;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.operation.IOperationHandler;

/**
 * Helper class that generically handles <code>IOperation</code> events and either routes their result or error
 * data to a specified method or assigns them to a specified property on an object instance.
 * <p><em>Assigning an operation result to an instance property</em></p>
 * <listing version="3.0">
 * public class MyPresentationModel {
 *
 *   private var _operationHandler:OperationHandler
 *
 *   public var products:Array;
 *
 *   public function MyPresentationModel(){
 *     _operationHandler = new OperationHandler(this.errorHandler);
 *   }
 *
 *   public function getProducts():void {
 *     var operation:IOperation = serviceImplementation.getProducts();
 *     _operationHandler.handleOperation(operation,null,this,"products");
 *   }
 *
 *   protected function errorHandler(error:*):void {
 *     //implementation omitted
 *   }
 * }
 * </listing>
 * <p><em>Assigning an operation result to an instance property using an extra method</em></p>
 * <p>If the data returned from the <code>IOperation</code> needs some extra processing, specify
 * an extra method for it like in this example:</p>
 * <listing version="3.0">
 * public class MyPresentationModel {
 *
 *   private var _operationHandler:OperationHandler
 *
 *   public var products:ArrayCollection;
 *
 *   public function MyPresentationModel(){
 *     _operationHandler = new OperationHandler(this.errorHandler);
 *   }
 *
 *   public function getProducts():void {
 *     var operation:IOperation = serviceImplementation.getProducts();
 *     _operationHandler.handleOperation(operation,convertArray,this,"products");
 *   }
 *
 *   protected function convertArray(input:Array):ArrayCollection {
 *     return new ArrayCollection(input);
 *   }
 *
 *   protected function errorHandler(error:*):void {
 *     //implementation omitted
 *   }
 * }
 * </listing>
 * @author Roland Zwaga
 */
class OperationHandler extends EventDispatcher implements IOperationHandler {

	private static var BUSY_CHANGE_EVENT = "busyChanged";
	
	/**
	 * Creates a new <code>OperationHandler</code> instance.
	 * @param defaultErrorhandler a default method that is invoked when an operation returns an error.
	 */
	public function new(?defaultErrorHandler:Dynamic -> Void) {
		super();
		initOperationHandler(defaultErrorHandler);
	}
	
	/**
	 * Returns <code>true</code> if the current <code>OperationHandler</code> is waiting for an <code>IOperation</code>
	 * to complete.
	 */
	public var busy(get, set):Bool;
	
	var _busy:Bool;
	
	function get_busy() return _busy;
	
	function set_busy(value:Bool) {
		if (_busy != value) {
			_busy = value;
			dispatchEvent(new Event(BUSY_CHANGE_EVENT));
		}
		return busy;
	}
	
	var _defaultErrorHandler:Dynamic -> Void;
	var _operations:Map<IOperation, OperationHandlerData>;
	
	/**
	 * @param operation The specified <code>IOperation</code>
	 * @param resultMethod A <code>Function</code> that will be invoked using the <code>IOperation.result</code> as a parameter.
	 * @param resultTargetObject The target instance that holds the property that will have the <code>IOperation.result</code> or <code>resultMethod</code> result assigned to it.
	 * @param resultPropertyName The property name on the <code>resultTargetObject</code> that will have the <code>IOperation.result</code> or <code>resultMethod</code> result assigned to it.
	 * @param errorMethod A <code>Function</code> that will be invoked using the <code>IOperation.error</code> as a parameter.
	 */
	public function handleOperation(?operation:IOperation, ?resultMethod:Dynamic -> Dynamic, ?resultTargetObject:Map<String, Dynamic>, ?resultPropertyName:String, ?errorMethod:Dynamic -> Void):Void {
		if (operation == null) {
			return;
		}
		
		busy = true;
		_operations.set(operation, new OperationHandlerData(resultPropertyName, resultTargetObject, resultMethod, errorMethod));
		operation.addCompleteListener(operationCompleteListener);
		operation.addErrorListener(operationErrorHandler);
	}
	
	/**
	 * Removes all event listeners from the specified <code>IOperation</code>.
	 * @param operation
	 */
	function cleanupUpOperation(operation:IOperation) {
		#if debug
		if(operation == null) throw "the operation argument must not be null";
		#end
		
		operation.removeCompleteListener(operationCompleteListener);
		operation.removeErrorListener(operationErrorHandler);
		_operations.remove(operation);
	}
	
	/**
	 * Initializes the current <code>OperationHandler</code>.
	 * @param defaultErrorHandler a default method that is invoked when an operation returns an error.
	 */
	function initOperationHandler(defaultErrorHandler:Dynamic -> Void) {
		_operations = new Map();
		_defaultErrorHandler = defaultErrorHandler;
	}
	
	/**
	 * Invokes either the specified result method with
	 * the <code>OperationEvent.result</code> property after an <code>IOperation</code> return a result.
	 * @param event The specified <code>OperationEvent</code>.
	 */
	function operationCompleteListener(event:OperationEvent) {
		#if debug
		if(event == null) throw "the event argument must not be null";
		#end
		busy = false;
		
		var data = _operations.get(event.operation);
		cleanupUpOperation(event.operation);
		
		if (data == null || ((data.resultPropertyName == null) && (data.resultMethod == null))) {
			return;
		}
		
		if ((data.resultPropertyName != null) && (data.resultTargetObject != null) && (data.resultMethod == null)) {
			data.resultTargetObject[data.resultPropertyName] = event.operation.result;
		} else if ((data.resultPropertyName == null) && (data.resultMethod != null)) {
			data.resultMethod(event.operation.result);
		} else if ((data.resultPropertyName != null) && (data.resultTargetObject != null) && (data.resultMethod != null)) {
			data.resultTargetObject[data.resultPropertyName] = data.resultMethod(event.operation.result);
		}
	}
	
	/**
	 * Invokes either the default error method or the specified error method with
	 * the <code>OperationEvent.error</code> property after an <code>IOperation</code> encountered an error.
	 * @param event The specified <code>OperationEvent</code>.
	 */
	function operationErrorHandler(event:OperationEvent) {
		#if debug
		if(event == null) throw "the event argument must not be null";
		#end
		busy = false;
		
		var data = _operations.get(event.operation);
		cleanupUpOperation(event.operation);
		
		var errorMethod:Dynamic -> Void = _defaultErrorHandler;
		if (data.errorMethod != null) {
			errorMethod = data.errorMethod;
		}
		
		if (errorMethod != null) {
			errorMethod(event.operation.error);
		}
	}
	
}