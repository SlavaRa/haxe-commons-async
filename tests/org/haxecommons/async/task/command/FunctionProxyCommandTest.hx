package org.haxecommons.async.task.command;
import massive.munit.Assert;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.task.command.FunctionProxyCommand;

/**
 * @author SlavaRa
 */
class FunctionProxyCommandTest {

	public function new() {}
	
	@Test
	public function testExecute() {
		var result:Dynamic = {};
		var command:ICommand = new FunctionProxyCommand(this, "testFunc", [result]);
		Assert.areEqual(result, command.execute());
	}

	public function testFunc(arg:Dynamic):Dynamic return arg;
}