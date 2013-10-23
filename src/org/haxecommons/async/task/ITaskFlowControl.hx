package org.haxecommons.async.task;
import flash.events.IEventDispatcher;

/**
 * @author SlavaRa
 */
interface ITaskFlowControl extends IEventDispatcher {
	var kind(default, null):TaskFlowControlKind;
}