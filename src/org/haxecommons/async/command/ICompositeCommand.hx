package org.haxecommons.async.command;
import org.haxecommons.async.command.CompositeCommandKind;
import org.haxecommons.async.operation.IOperation;

/**
 * @author SlavaRa
 */
interface ICompositeCommand extends ICommand extends IOperation {
	var numCommands(get, null):Int;
	var kind(default, null):CompositeCommandKind;
	
	function addCommandAt(command:ICommand, index:Int):ICompositeCommand;
	function addCommand(command:ICommand):ICompositeCommand;
	function addOperation(operationClass:Class<Dynamic>, ?constructorArgs:Array<Dynamic>):ICompositeCommand;
	function addOperationAt(operationClass:Class<Dynamic>, index:Int, ?constructorArgs:Array<Dynamic>):ICompositeCommand;
}