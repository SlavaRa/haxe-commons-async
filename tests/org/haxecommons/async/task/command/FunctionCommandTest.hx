package org.haxecommons.async.task.command;
import massive.munit.Assert;
import org.haxecommons.async.task.command.FunctionCommand;

/**
 * @author SlavaRa
 */
class FunctionCommandTest {

	public function new() {}
	
	@Test
	public function testExecute() {
		var result:Dynamic = {};
		var command = new FunctionCommand(function() return result);
		Assert.areEqual(result, command.execute());
	}
}