package org.haxecommons.async.task.impl;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.haxecommons.async.command.impl.MockAsyncCommand;
import org.haxecommons.async.operation.impl.MockOperation;
import org.haxecommons.async.task.event.TaskEvent;
import org.haxecommons.async.task.impl.FunctionConditionProvider;
import org.haxecommons.async.task.impl.Task;
import org.haxecommons.async.test.AbstractTestWithMockRepository;

/**
 * @author SlavaRa
 */
class TaskTest extends AbstractTestWithMockRepository {

	public function new() super();
	
	@Test
	public function testAnd() {
		new Task()
			.and(new MockAsyncCommand())
			.execute();
	}

	@AsyncTest
	public function testAndAsync(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 200), 100);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var i = 0;
		var task = new Task()
			.and(new MockAsyncCommand(false, 1, function() {i++; return null;}));
		task.addEventListener(TaskEvent.TASK_COMPLETE, function(_) Assert.areEqual(1, i));
		task.execute();
	}

	@AsyncTest
	public function testAndMultipleAsync(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 6000), 5900);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var i = 0;
		var task = new Task()
			.and(MockOperation, ["test1", 4000, false, function() Assert.areEqual(1, i)])
			.and(MockOperation, ["test2", 1000, false, function() Assert.areEqual(0, i++)]);
		task.addEventListener(TaskEvent.TASK_COMPLETE, function(_) Assert.areEqual(1, i));
		task.execute();
	}

	@Test
	public function testAndAsyncNotAsyncMixed() {
		var i = 0;
		var task = new Task()
			.and(new MockAsyncCommand(false, 1, function() {i++; return null;}))
			.and(new MockAsyncCommand());
		task.addEventListener(TaskEvent.TASK_COMPLETE, function(_) Assert.areEqual(1, i));
		task.execute();
	}

	@Test
	public function testNext() {
		new Task()
			.next(new MockAsyncCommand())
			.execute();
	}

	@AsyncTest
	public function testNextAsync(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 500), 400);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var i = 0;
		var task = new Task()
			.next(new MockAsyncCommand(false, 1, function() {i++; return null;}));
		task.addEventListener(TaskEvent.TASK_COMPLETE, function(_) Assert.areEqual(1, i));
		task.execute();
	}

	@AsyncTest
	public function testNextMultipleAsync(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 6000), 5900);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var i = 0;
		var task = new Task()
			.next(MockOperation, ["test1", 4000, false, function() Assert.areEqual(0, i++)])
			.next(MockOperation, ["test2", 1000, false, function() Assert.areEqual(1, i)]);
		task.addEventListener(TaskEvent.TASK_COMPLETE, function(_) Assert.areEqual(1, i));
		task.execute();
	}

	@Test
	public function testForLoopWithCountProvider() {
		var task = new Task()
			.for_(0, new CountProvider())
			.and(new MockAsyncCommand())
			.end();
		task.addEventListener(TaskEvent.TASK_COMPLETE, function(_) Assert.isTrue(true));
		task.execute();
	}

	@Test
	public function testForLoopWithFixedCount() {
		var task = new Task()
			.for_(10)
			.and(new MockAsyncCommand())
			.end();
		task.addEventListener(TaskEvent.TASK_COMPLETE, function(_) Assert.isTrue(true));
		task.execute();
	}

	@AsyncTest
	public function testForLoopWithAsyncCommand(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 300), 200);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var i = 0;
		var task = new Task()
			.for_(10)
			.next(MockOperation, ["test1", 100, false, function() i++])
			.end();
		task.addEventListener(TaskEvent.TASK_COMPLETE, function(_) Assert.areEqual(10, i));
		task.execute();
	}

	@Test
	public function testWhileLoop() {
		var i = 0;
		var task = new Task()
			.while_(new FunctionConditionProvider(function() return i++ != 10))
			.and(new MockAsyncCommand())
			.end();
		task.addEventListener(TaskEvent.TASK_COMPLETE, function(_) Assert.isTrue(true));
		task.execute();
	}

	@AsyncTest
	public function testWhileLoopWithAsync(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 2000), 1900);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var i = 0;
		var task = new Task()
			.while_(new FunctionConditionProvider(function() return i != 10))
			.next(MockOperation, ["test1", 100, false, function() i++])
			.end();
		task.addEventListener(TaskEvent.TASK_COMPLETE, function(_) Assert.areEqual(10, i));
		task.execute();
	}
}