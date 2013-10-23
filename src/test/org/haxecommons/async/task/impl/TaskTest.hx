package org.haxecommons.async.task.impl;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.command.impl.MockAsyncCommand;
import org.haxecommons.async.operation.impl.MockOperation;
import org.haxecommons.async.task.event.TaskEvent;
import org.haxecommons.async.task.IConditionProvider;
import org.haxecommons.async.task.ICountProvider;
import org.haxecommons.async.task.impl.FunctionConditionProvider;
import org.haxecommons.async.task.impl.Task;
import org.haxecommons.async.test.AbstractTestWithMockRepository;

/**
 * @author SlavaRa
 */
class TaskTest extends AbstractTestWithMockRepository {

	public function new() super();
	
	private var _counter:Int;

	@Before
	public function setUp() _counter = 0;

	function incCounter():Dynamic {
		_counter++;
		return null;
	}

	@Test
	public function testAnd() {
		var c = new MockAsyncCommand();
		
		var task = new Task();
		task.and(c);
		task.execute();
	}

	@AsyncTest
	public function testAndAsync(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 500);
		var timer = haxe.Timer.delay(handler, 400);
		
		var task = new Task();
		task.and(new MockAsyncCommand(false, 1, incCounter));
		task.addEventListener(TaskEvent.TASK_COMPLETE, onTaskComplete);
		task.execute();
	}

	@AsyncTest
	public function testAndMultipleAsync(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 6000);
		var timer = haxe.Timer.delay(handler, 5900);
		
		var counter:Int = 0;
		var command1:Void->Void = function() Assert.areEqual(1, counter);
		var command2:Void->Void = function() {
			Assert.areEqual(0, counter);
			counter++;
		}
		var handleComplete:TaskEvent->Void = function(event:TaskEvent) Assert.areEqual(1, counter);
		var task = new Task();
		task.and(MockOperation, ["test1", 5000, false, command1]).and(MockOperation, ["test2", 1000, false, command2]);
		task.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
		task.execute();
	}

	function onTaskComplete(event:TaskEvent) Assert.areEqual(1, _counter);

	@Test
	public function testAndAsyncNotAsyncMixed() {
		var c = new MockAsyncCommand();
		
		var task = new Task();
		task.and(new MockAsyncCommand(false, 1, incCounter)).and(c);
		task.addEventListener(TaskEvent.TASK_COMPLETE, onTaskComplete);
		task.execute();
	}

	@Test
	public function testNext() {
		var c = new MockAsyncCommand();
		
		var task = new Task();
		task.next(c);
		task.execute();
	}

	@AsyncTest
	public function testNextAsync(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 500);
		var timer = haxe.Timer.delay(handler, 400);
		
		var task = new Task();
		task.next(new MockAsyncCommand(false, 1, incCounter));
		task.addEventListener(TaskEvent.TASK_COMPLETE, onTaskComplete);
		task.execute();
	}

	@AsyncTest
	public function testNextMultipleAsync(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 6000);
		var timer = haxe.Timer.delay(handler, 5900);
		
		var counter:Int = 0;
		var command1:Void->Void = function() {
			Assert.areEqual(0, counter);
			counter++;
		}
		var command2:Void->Void = function() Assert.areEqual(1, counter);
		var handleComplete:TaskEvent->Void = function(event:TaskEvent) Assert.areEqual(1, counter);
		var task = new Task();
		task.next(MockOperation,["test1", 5000, false, command1]).next(MockOperation, ["test2", 1000, false, command2]);
		task.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
		task.execute();
	}

	@Test
	public function testForLoopWithCountProvider() {
		var count = new CountProvider();
		var command = new MockAsyncCommand();
		
		var handleComplete:TaskEvent->Void = function(event:TaskEvent) Assert.isTrue(true);
		
		var task = new Task();
		task.for_(0, count).and(command).end();
		task.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
		task.execute();
	}

	@Test
	public function testForLoopWithFixedCount() {
		var command = new MockAsyncCommand();
		
		var handleComplete:TaskEvent->Void = function(event:TaskEvent) Assert.isTrue(true);
		var task:Task = new Task();
		task.for_(10).and(command).end();
		task.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
		task.execute();
	}

	@AsyncTest
	public function testForLoopWithAsyncCommand(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 2000);
		var timer = haxe.Timer.delay(handler, 1900);
		
		var command1:Void->Void= function() _counter++;
		var handleComplete:TaskEvent->Void = function(event:TaskEvent) Assert.areEqual(10, _counter);
		var task:Task = new Task();
		task.for_(10).next(MockOperation, ["test1", 100, false, command1]).end();
		task.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
		task.execute();
	}

	@Test
	public function testWhileLoop() {
		var returnResult:Void->Bool = function():Bool return (_counter++ != 10);
		var condition = new FunctionConditionProvider(returnResult);
		var command = new MockAsyncCommand();
		
		var handleComplete:TaskEvent->Void = function(event:TaskEvent) Assert.isTrue(true);
		var task:Task = new Task();
		task.while_(condition).and(command).end();
		task.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
		task.execute();
		
	}

	@AsyncTest
	public function testWhileLoopWithAsync(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 2000);
		var timer = haxe.Timer.delay(handler, 1900);
		
		var returnResult:Void->Bool = function() return (_counter != 10);
		var condition:IConditionProvider = new FunctionConditionProvider(returnResult);
		var handleComplete:TaskEvent->Void = function(event:TaskEvent) Assert.areEqual(10, _counter);
		var command1:Void->Void = function() _counter++;
		var task:Task = new Task();
		task.while_(condition).next(MockOperation, ["test1", 100, false, command1]).end();
		task.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
		task.execute();
	}
}