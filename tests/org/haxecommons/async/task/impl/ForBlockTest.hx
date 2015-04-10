package org.haxecommons.async.task.impl;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.haxecommons.async.command.impl.MockAsyncCommand;
import org.haxecommons.async.operation.impl.MockOperation;
import org.haxecommons.async.task.event.TaskEvent;
import org.haxecommons.async.task.impl.ForBlock;
import org.haxecommons.async.test.AbstractTestWithMockRepository;

/**
 * @author SlavaRa
 */
class ForBlockTest extends AbstractTestWithMockRepository {

	public function new() super();

	@Test
	public function testExecute() {
		new ForBlock(new CountProvider())
			.and(new MockAsyncCommand())
			.end()
			.execute();
	}

	@AsyncTest
	public function testExecuteWithAsync(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 300), 200);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var i = 0;
		var task = new ForBlock(new CountProvider(10))
			.next(MockOperation, ["test1", 100, false, function() i++])
			.end();
		task.addEventListener(TaskEvent.TASK_COMPLETE, function(_) Assert.areEqual(10, i));
		task.execute();
	}

	@Test
	public function testExecuteWithBreak() {
		new ForBlock(new CountProvider())
			.and(new MockAsyncCommand())
			.break_()
			.and(new MockAsyncCommand())
			.end()
			.execute();
	}

	@Test
	public function testExecuteWithContinue() {
		new ForBlock(new CountProvider())
			.and(new MockAsyncCommand())
			.continue_()
			.and(new MockAsyncCommand())
			.end()
			.execute();
	}
}