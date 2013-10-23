package org.haxecommons.async.operation.impl;


/**
 * @author SlavaRa
 */
class OperationHandlerData {

	public function new(?resultPropertyName:String, ?resultTargetObject:Map<String, Dynamic>, ?resultMethod:Dynamic -> Dynamic, ?errorMethod:Dynamic -> Void) {
		initOperationHandler(resultPropertyName, resultTargetObject, resultMethod, errorMethod);
	}
	
	public var resultPropertyName(default, null):String;
	public var resultTargetObject(default, null):Map<String, Dynamic>;
	public var errorMethod(default, null):Dynamic -> Void;
	public var resultMethod(default, null):Dynamic -> Dynamic;

	function initOperationHandler(resultPropertyName:String, resultTargetObject:Map<String, Dynamic>, resultMethod:Dynamic -> Dynamic, errorMethod:Dynamic -> Void) {
		this.resultPropertyName = resultPropertyName;
		this.resultTargetObject = resultTargetObject;
		this.resultMethod = resultMethod;
		this.errorMethod = errorMethod;
	}
}