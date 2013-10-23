package org.haxecommons.async.operation.trigger;
import org.haxecommons.async.command.IAsyncCommand;

/**
 * @author SlavaRa
 */

interface IOperationCompleteTrigger extends IAsyncCommand/* extends IDisposable */{
	function var isComplete():Bool;
}