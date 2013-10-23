package org.haxecommons.async.task.event;
import flash.events.Event;
import org.haxecommons.async.task.TaskFlowControlKind;

/**
 * @author SlavaRa
 */
class TaskFlowControlEvent extends Event{

	public static var BREAK = TaskFlowControlKind.BREAK.name;
	public static var CONTINUE = TaskFlowControlKind.CONTINUE.name;
	public static var EXIT = TaskFlowControlKind.EXIT.name;
	
	public function new(kind:TaskFlowControlKind, ?bubbles:Bool, ?cancelable:Bool) {
		super(kind.name, bubbles, cancelable);
	}
	
	public override function clone():Event return new TaskFlowControlEvent(TaskFlowControlKind.fromName(type), bubbles, cancelable);
}