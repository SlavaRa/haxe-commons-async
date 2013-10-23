package org.haxecommons.async.command.event;
import flash.events.Event;
import org.haxecommons.async.command.ICommand;

/**
 * @author SlavaRa
 */
class CompositeCommandEvent extends Event {

	public static var COMPLETE = "compositeCommandComplete";
	public static var ERROR = "compositeCommandError";
	public static var BEFORE_EXECUTE_COMMAND = "compositeCommandBeforeExecuteCommand";
	public static var AFTER_EXECUTE_COMMAND = "compositeCommandAfterExecuteCommand";

	public function new(type:String, ?command:ICommand, ?bubbles:Bool, ?cancelable:Bool) {
		super(type, bubbles, cancelable);
		this.command = command;
	}
	
	public var command(default, null):ICommand;
	
	public override function clone():Event return new CompositeCommandEvent(type, command, bubbles, cancelable);
	
}