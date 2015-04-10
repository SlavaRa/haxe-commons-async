package org.haxecommons.async.task.command;
import massive.munit.Assert;
import openfl.events.Event;
import org.haxecommons.async.command.impl.MockAsyncCommand;
import org.haxecommons.async.task.command.TaskCommand;
import org.haxecommons.async.test.AbstractTestWithMockRepository;

/**
 * @author SlavaRa
 */
class TaskCommandTest extends AbstractTestWithMockRepository {

	public function new() super();

	@Test
	public function testReset() {
		var task = new TaskCommand();
		task.addCommand(new MockAsyncCommand());
		task.addCommand(new MockAsyncCommand());
		Assert.areEqual(2, task.numCommands);
		var completeHandler:Event->Void = function(_) {
			Assert.areEqual(0, task.numCommands);
			task.reset();
			Assert.areEqual(2, task.numCommands);
		};
		task.addCompleteListener(completeHandler);
		task.execute();
	}
}