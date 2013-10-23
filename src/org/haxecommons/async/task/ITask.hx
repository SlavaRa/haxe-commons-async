package org.haxecommons.async.task;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.operation.IOperation;

/**
 * @author SlavaRa
 */
interface ITask extends ICommand extends IOperation {
	var context(default, default):Dynamic;
	var parent(default, null):ITask;
	var isClosed(default, null):Bool;

	function next(item:Dynamic, ?constructorArgs:Array<Dynamic>):ITask;
	function and(item:Dynamic, ?constructorArgs:Array<Dynamic>):ITask;
	function if_(?condition:IConditionProvider, ?ifElseBlock:IIfElseBlock):IIfElseBlock;
	function else_():IIfElseBlock;
	function while_(?condition:IConditionProvider, ?whileBlock:IWhileBlock):IWhileBlock;
	function for_(count:Int, ?countProvider:ICountProvider, ?forBlock:IForBlock):IForBlock;
	function exit():ITask;
	function reset(?doHardReset:Bool):ITask;
	function pause(duration:Int, ?pauseCommand:ICommand):ITask;
	function end():ITask;
	function break_():ITask;
	function continue_():ITask;
}