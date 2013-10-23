package org.haxecommons.async.operation.impl;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.operation.IOperationQueue;

/**
 * @author SlavaRa
 */
class OperationQueue extends AbstractProgressOperation implements IOperationQueue {

	static var _queueCounter:UInt = 0;
	
	public function new(?name:String) {
		super();
		_queueCounter++;
		_operations = [];
		this.name = (name == null || name.length == 0) ? "queue_" +Std.string(_queueCounter) : name;
	}
	
	public var name(default, null):String;
	
	var _operations:Array<IOperation>;

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

	public override function toString():String {
		return "[OperationQueue(name='" + name + "', operations:'" + _operations.length + "', total:'" + total + "', progress:'" + progress + "')]";
	}

	function addOperationListeners(?operation:IOperation) {
		if (operation == null) {
			return;
		}
		
		operation.addCompleteListener(operation_completeHandler);
		operation.addErrorListener(operation_errorHandler);
	}

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

	function removeOperationListeners(?operation:IOperation) {
		if (operation == null) {
			return;
		}
		
		operation.removeCompleteListener(operation_completeHandler);
		operation.removeErrorListener(operation_errorHandler);
	}
	
}