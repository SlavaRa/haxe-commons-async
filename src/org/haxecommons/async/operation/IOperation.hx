package org.haxecommons.async.operation;
import flash.events.Event;
import flash.events.IEventDispatcher;

/**
 * @author SlavaRa
 */
interface IOperation extends IEventDispatcher {
	var result(default, null):Dynamic;
	var error(default, null):Dynamic;
	var timeout(default, default):Int;
	
	function addCompleteListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool):Void;
	function addErrorListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool):Void;
	function addTimeoutListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool):Void;
	function removeCompleteListener(listener:Dynamic -> Void, ?useCapture:Bool):Void;
	function removeErrorListener(listener:Dynamic -> Void, ?useCapture:Bool):Void;
	function removeTimeoutListener(listener:Dynamic -> Void, ?useCapture:Bool):Void;
}