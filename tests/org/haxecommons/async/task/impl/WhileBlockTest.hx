package org.haxecommons.async.task.impl;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.haxecommons.async.command.impl.MockAsyncCommand;
import org.haxecommons.async.operation.impl.MockOperation;
import org.haxecommons.async.task.event.TaskEvent;
import org.haxecommons.async.task.impl.FunctionConditionProvider;
import org.haxecommons.async.task.impl.WhileBlock;

/**
 * @author SlavaRa
 */
class WhileBlockTest {

	public function new() {}

	@Test
	public function testExecute() {
		var i = 0;
		new WhileBlock(new FunctionConditionProvider(function() return i++ < 10))
			.and(new MockAsyncCommand())
			.execute();
	}

	@AsyncTest
	public function testExecuteWithAsync(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function() {}, 300), 200);
		#if ((neko && !display) || cpp)
		t.run();
		#end 
		var i = 0;
		var task = new WhileBlock(new FunctionConditionProvider(function() return i++ < 10))
			.next(MockOperation, ["test1", 100, false, function() Assert.isTrue(i < 11)])
			.end();
		task.addEventListener(TaskEvent.TASK_COMPLETE, function(_) Assert.areEqual(11, i));
		task.execute();
	}
}