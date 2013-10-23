package org.haxecommons.async.command.event;
import flash.events.Event;
import org.haxecommons.async.command.ICommand;

/**
 * @author SlavaRa
 */
class CommandEvent extends Event {

	public static var EXECUTE = "executeCommand";

	public function new(type:String, command:ICommand, ?bubbles:Bool, ?cancelable:Bool) {
		super(type, bubbles, cancelable);
		this.command = command;
	}

	public var command(default, null):ICommand;

	public override function clone():Event return new CommandEvent(type, command, bubbles, cancelable);
	
}