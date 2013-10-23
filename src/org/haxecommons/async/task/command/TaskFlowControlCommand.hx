package org.haxecommons.async.task.command;
import flash.events.EventDispatcher;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.task.event.TaskFlowControlEvent;
import org.haxecommons.async.task.ITaskFlowControl;
import org.haxecommons.async.task.TaskFlowControlKind;

/**
 * @author SlavaRa
 */
class TaskFlowControlCommand extends EventDispatcher implements ICommand implements ITaskFlowControl {

	public function new(kind:TaskFlowControlKind) {
		#if debug
		if(kind == null) throw "the kind argument must not be null";
		#end
		
		super();
		
		this.kind = kind;
	}
	
	public var kind(default, null):TaskFlowControlKind;

	public function execute():Dynamic {
		dispatchEvent(new TaskFlowControlEvent(this.kind));
		return this.kind;
	}

}