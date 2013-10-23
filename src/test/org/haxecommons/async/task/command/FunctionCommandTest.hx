package org.haxecommons.async.task.command;
import massive.munit.Assert;
import org.haxecommons.async.task.command.FunctionCommand;

/**
 * @author SlavaRa
 */
class FunctionCommandTest {

	public function new() {
	}
	
	@Test
	public function testExecute() {
		var resultObject:Dynamic = {};
		var testFunc:Void->Dynamic = function():Dynamic return resultObject;
		var fc = new FunctionCommand(testFunc);
		Assert.areEqual(resultObject, fc.execute());
	}
	
}