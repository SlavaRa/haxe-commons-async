package org.haxecommons.async.rpc;
import org.haxecommons.async.operation.IOperation;

/**
 * @author SlavaRa
 */
interface IService {
	function call(methodName:String, ?parametrs:Array<Dynamic>):IOperation;
}