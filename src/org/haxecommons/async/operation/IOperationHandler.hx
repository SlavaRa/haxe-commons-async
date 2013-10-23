package org.haxecommons.async.operation;
import flash.events.IEventDispatcher;

/**
 * @author SlavaRa
 */
interface IOperationHandler extends IEventDispatcher {
	var busy(get, set):Bool;
	function handleOperation(?operation:IOperation, ?resultMethod:Dynamic -> Dynamic, ?resultTargetObject:Map<String, Dynamic>, ?resultPropertyName:String, ?errorMethod:Dynamic -> Void):Void;
}