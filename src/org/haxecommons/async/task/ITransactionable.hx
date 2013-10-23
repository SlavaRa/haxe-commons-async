package org.haxecommons.async.task;

/**
 * @author SlavaRa
 */
interface ITransactionable {
	function commit():Void;
    function rollback():Void;
}