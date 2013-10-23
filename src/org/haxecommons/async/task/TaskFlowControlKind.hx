package org.haxecommons.async.task;

/**
 * @author SlavaRa
 */
@:final class TaskFlowControlKind {

	public static var BREAK = new TaskFlowControlKind("break");
	public static var CONTINUE = new TaskFlowControlKind("continue");
	public static var EXIT = new TaskFlowControlKind("exit");
	
	public static function fromName(name:String):TaskFlowControlKind {
		switch (name.toLowerCase()) {
			case "break":
				return BREAK;
			case "continue":
				return CONTINUE;
			case "exit":
				return EXIT;
			default:
				throw "Unknown TaskFlowControlKind value: " + name;
		}
		return null;
	}
	
	function new(name:String) this.name = name;
	
	public var name(default, null):String;

	public function toString():String return name;
}