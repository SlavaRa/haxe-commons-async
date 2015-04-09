package org.haxecommons.async.task.command;
import openfl.events.Event;
import massive.munit.Assert;
import org.haxecommons.async.command.ICommand;
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
		var c1 = new MockAsyncCommand();
		var c2 = new MockAsyncCommand();
		var tc = new TaskCommand();
		tc.addCommand(c1);
		tc.addCommand(c2);
		Assert.areEqual(2, tc.numCommands);
		var completeHandler:Event->Void = function(?event:Event) {
			Assert.areEqual(0, tc.numCommands);
			tc.reset();
			Assert.areEqual(2, tc.numCommands);
		};
		tc.addCompleteListener(completeHandler);
		tc.execute();
	}
	
}