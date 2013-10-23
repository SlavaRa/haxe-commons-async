package org.haxecommons.async.command.impl;
import flash.system.ApplicationDomain;
import org.haxecommons.async.command.IAsyncCommand;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.impl.AbstractProgressOperation;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.operation.IProgressOperation;

/**
 * @author SlavaRa
 */
class GenericOperationCommand extends AbstractProgressOperation implements IAsyncCommand  /*IApplicationDomainAware */{

	public static function createNew(cls:Class<Dynamic>, ?constructorArgs:Array<Dynamic>):GenericOperationCommand {
		var goc:GenericOperationCommand = new GenericOperationCommand(cls);
		if (constructorArgs != null) {
			goc.constructorArguments = constructorArgs;
		}
		
		return goc;
	}
	
	public function new(operationClass:Class<Dynamic>, ?constructorArgs:Array<Dynamic>) {
		super();
		initGenericOperationCommand(operationClass, constructorArgs);
	}
	
	public var operationClass(default, null):Class<Dynamic>;
	public var applicationDomain(default, null):ApplicationDomain;
	public var constructorArguments(default, default):Array<Dynamic>;
	
	var _operation:IOperation;

	function initGenericOperationCommand(operationClass:Class<Dynamic>, ?constructorArgs:Array<Dynamic>) {
		#if debug
		if(operationClass == null) throw "the operationClass argument must not be null";
		#end
		
		this.operationClass = operationClass;
		constructorArguments = constructorArgs;
	}

	public function execute():Dynamic {
		_operation = Type.createInstance(operationClass, constructorArguments);
		_operation.addCompleteListener(operationComplete);
		_operation.addErrorListener(operationError);
		
		if (Std.is(_operation, IProgressOperation)) {
			cast(_operation, IProgressOperation).addProgressListener(operationProgress);
		}
		
		return true;
	}

	function operationComplete(event:OperationEvent){
		removeListeners();
		dispatchCompleteEvent(event.operation.result);
	}

	function operationError(event:OperationEvent){
		removeListeners();
		dispatchErrorEvent(event.operation.error);
	}

	function operationProgress(event:OperationEvent) {
		var operation:IProgressOperation = cast(event.operation, IProgressOperation);
		progress = operation.progress;
		total = operation.total;
		dispatchProgressEvent();
	}

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