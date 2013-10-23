package org.haxecommons.async.operation;

/**
 * @author SlavaRa
 */
interface IProgressOperation extends IOperation {
	var progress(default, null):UInt;
	var total(default, null):UInt;
	
	function addProgressListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool):Void;
	function removeProgressListener(listener:Dynamic -> Void, ?useCapture:Bool):Void;
}