package org.haxecommons.async.task;

/**
 * @author SlavaRa
 */
interface IIfElseBlock extends ITaskBlock extends IConditionProviderAware {
	function switchToElseBlock():Void;
}