package org.haxecommons.async.operation.impl;
import flash.events.Event;
import flash.events.EventDispatcher;
import haxe.ds.WeakMap.WeakMap;
import org.hamcrest.Exception.MissingImplementationException;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.operation.IOperationHandler;


/**
 * @author SlavaRa
 */
class OperationHandler extends EventDispatcher implements IOperationHandler {

	private static var BUSY_CHANGE_EVENT = "busyChanged";
	
	public function new(?defaultErrorHandler:Dynamic -> Void) {
		super();
		initOperationHandler(defaultErrorHandler);
	}

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

	public function handleOperation(?operation:IOperation, ?resultMethod:Dynamic -> Dynamic, ?resultTargetObject:Map<String, Dynamic>, ?resultPropertyName:String, ?errorMethod:Dynamic -> Void):Void {
		if (operation == null) {
			return;
		}
		
		busy = true;
		_operations.set(operation, new OperationHandlerData(resultPropertyName, resultTargetObject, resultMethod, errorMethod));
		operation.addCompleteListener(operationCompleteListener);
		operation.addErrorListener(operationErrorHandler);
	}

	function cleanupUpOperation(operation:IOperation) {
		#if debug
		if(operation == null) throw "the operation argument must not be null";
		#end
		
		operation.removeCompleteListener(operationCompleteListener);
		operation.removeErrorListener(operationErrorHandler);
		_operations.remove(operation);
	}

	function initOperationHandler(defaultErrorHandler:Dynamic -> Void) {
		_operations = new Map();
		_defaultErrorHandler = defaultErrorHandler;
	}

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