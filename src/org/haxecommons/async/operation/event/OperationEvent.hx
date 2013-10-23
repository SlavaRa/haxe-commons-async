package org.haxecommons.async.operation.event;
import flash.events.Event;
import org.haxecommons.async.operation.IOperation;

/**
 * @author SlavaRa
 */
class OperationEvent extends Event {

	public static var COMPLETE = "operationComplete";
	public static var ERROR = "operationError";
	public static var PROGRESS = "operationProgress";
	public static var TIMEOUT = "operationTimeout";
	
	public static function createCompleteEvent(operation:IOperation, ?bubbles:Bool, ?cancelable:Bool):OperationEvent {
		return new OperationEvent(OperationEvent.COMPLETE, operation, bubbles, cancelable);
	}

	public static function createErrorEvent(operation:IOperation, ?bubbles:Bool, ?cancelable:Bool):OperationEvent {
		return new OperationEvent(OperationEvent.ERROR, operation, bubbles, cancelable);
	}

	public static function createProgressEvent(operation:IOperation, ?bubbles:Bool, ?cancelable:Bool):OperationEvent {
		return new OperationEvent(OperationEvent.PROGRESS, operation, bubbles, cancelable);
	}

	public static function createTimeoutEvent(operation:IOperation, ?bubbles:Bool, ?cancelable:Bool):OperationEvent {
		return new OperationEvent(OperationEvent.TIMEOUT, operation, bubbles, cancelable);
	}
	
	public function new(type:String, operation:IOperation, ?bubbles:Bool, ?cancelable:Bool) {
		super(type, bubbles, cancelable);
		this.operation = operation;
	}
	
	public var operation(default, default):IOperation;
	public var result(get , null):Dynamic;
	public var error(get, null):Dynamic;

	public override function clone():Event return new OperationEvent(type, operation, bubbles, cancelable);
	
	function get_result():Dynamic return operation != null ? operation.result : null;
	
	function get_error():Dynamic  return operation != null ? operation.error : null;
}