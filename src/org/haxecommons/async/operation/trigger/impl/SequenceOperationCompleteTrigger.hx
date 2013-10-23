package org.haxecommons.async.operation.trigger.impl;
import org.haxecommons.async.command.CompositeCommandKind;
import org.haxecommons.async.command.impl.CompositeCommand;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.trigger.IOperationCompleteTrigger;

/**
 * @author SlavaRa
 */
class SequenceOperationCompleteTrigger extends AbstractCompositeOperationCompleteTrigger {

	public function new() {
		super();
		_commandQueue = new CompositeCommand(CompositeCommandKind.SEQUENCE);
		_commandQueue.addCompleteListener(commandQueue_completeHandler);
	}
	
	var _commandQueue:CompositeCommand;

	public override function addTrigger(trigger:IOperationCompleteTrigger) {
		super.addTrigger(trigger);
		_commandQueue.addCommand(trigger);
	}

	public override function dispose() {
		if (isDisposed) {
			return;
		}
		
		_commandQueue.removeCompleteListener(commandQueue_completeHandler);
		_commandQueue = null;
		super.dispose();
	}
	
	override function doExecute() _commandQueue.execute();

	function commandQueue_completeHandler(event:OperationEvent) {
		dispose();
		dispatchCompleteEvent();
	}
}