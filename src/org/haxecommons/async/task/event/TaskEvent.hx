package org.haxecommons.async.task.event;
import flash.events.Event;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.task.ITask;

/**
 * @author SlavaRa
 */
class TaskEvent extends Event {

	public static var TASK_ERROR = "taskError";
	public static var TASK_ABORTED = "taskAborted";
	public static var TASK_COMPLETE = "taskComplete";
	public static var BEFORE_EXECUTE_COMMAND = "taskBeforeExecuteCommand";
	public static var AFTER_EXECUTE_COMMAND = "taskAfterExecuteCommand";
	
	public function new(type:String, task:ITask, command:ICommand, ?bubbles:Bool, ?cancelable:Bool) {
		super(type, bubbles, cancelable);
		this.command = command;
		this.task = task;
	}

	public var command(default, null):ICommand;
	public var task(default, null):ITask;

	public override function clone():Event return new TaskEvent(type, task, command, bubbles, cancelable);

}