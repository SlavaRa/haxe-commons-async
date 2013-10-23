package org.haxecommons.async.task.impl;
import org.haxecommons.async.task.ICountProvider;

/**
 * @author SlavaRa
 */
class CountProvider implements ICountProvider {

	public function new(count:Int = 0) _count = count;
	
	var _count:Int;
	
	public function getCount():Int return _count;
	
}