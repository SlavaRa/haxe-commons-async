package org.haxecommons.async.operation;

/**
 * @author SlavaRa
 */

interface IOperationQueue extends IProgressOperation{
	var name(default, null):String;

	function addOperation(operation:IOperation):Bool;
	function hasOperation(operation:IOperation):Bool;
}