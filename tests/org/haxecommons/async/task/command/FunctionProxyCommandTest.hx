package org.haxecommons.async.task.command;
import massive.munit.Assert;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.task.command.FunctionProxyCommand;

/**
 * @author SlavaRa
 */
class FunctionProxyCommandTest {

	public function new() {
	}
	
	@Test
	public function testExecute() {
		var resultObject:Dynamic = {};
		var fc:ICommand = new FunctionProxyCommand(this, "testFunc", [resultObject]);
		Assert.areEqual(resultObject, fc.execute());
	}

	public function testFunc(arg:Dynamic):Dynamic return arg;
	
}