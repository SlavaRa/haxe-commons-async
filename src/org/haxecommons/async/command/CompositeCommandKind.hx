package org.haxecommons.async.command;

/**
 * @author SlavaRa
 */
@:final class CompositeCommandKind {
	
	static var _kinds:Map<String, CompositeCommandKind> = new Map();
	
	public static var SEQUENCE = new CompositeCommandKind("sequence");
	public static var PARALLEL = new CompositeCommandKind("parallel");
	
	public static function fromName(?name:String):CompositeCommandKind {
		if(name == null || name.length == 0) {
			return null;
		}
		
		return _kinds.get(name);
	}
	
	function new(name:String) {
		this.name = name;
		_kinds.set(name, this);
	}
	
	public var name(default, null):String;
	
	public function toString() return name;
}