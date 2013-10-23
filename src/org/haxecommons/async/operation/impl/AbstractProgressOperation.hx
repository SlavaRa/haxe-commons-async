package org.haxecommons.async.operation.impl;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.IProgressOperation;

/**
 * @author SlavaRa
 */
class AbstractProgressOperation extends AbstractOperation implements IProgressOperation {

	public function new(timeoutInMilliseconds:UInt = 0, autoStartTimeout:Bool = true) {
		super(timeoutInMilliseconds, autoStartTimeout);
	}
	
	public var progress(default, default):UInt;
	public var total(default, default):UInt;

	public function addProgressListener(listener:Dynamic -> Void, ?useCapture:Bool, ?priority:Int = 0, ?useWeakReference:Bool) {
		addEventListener(OperationEvent.PROGRESS, listener, useCapture, priority, useWeakReference);
	}

	public function removeProgressListener(listener:Dynamic -> Void, ?useCapture:Bool) {
		removeEventListener(OperationEvent.PROGRESS, listener, useCapture);
	}

	function dispatchProgressEvent() dispatchEvent(OperationEvent.createProgressEvent(this));
}