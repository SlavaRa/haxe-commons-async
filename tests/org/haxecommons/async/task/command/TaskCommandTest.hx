package org.haxecommons.async.task.command;
import massive.munit.Assert;
import org.haxecommons.async.command.impl.MockAsyncCommand;
import org.haxecommons.async.task.command.TaskCommand;

/**
 * @author SlavaRa
 */
class TaskCommandTest {

	public function new() {}

	@Test
	public function testReset() {
		var task = new TaskCommand();
		task.addCommand(new MockAsyncCommand());
		task.addCommand(new MockAsyncCommand());
		Assert.areEqual(2, task.numCommands);
		task.addCompleteListener(function(_) {
			Assert.areEqual(0, task.numCommands);
			task.reset();
			Assert.areEqual(2, task.numCommands);
		});
		task.execute();
	}
}