package org.haxecommons.async.task;

/**
 * @author SlavaRa
 */
interface ITransaction extends ITask {
	function startTransaction():ITransaction;
	function commit():ITransaction;
	function rollback():ITransaction;
}