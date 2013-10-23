package org.haxecommons.async.task.impl;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.command.impl.MockAsyncCommand;
import org.haxecommons.async.operation.impl.MockOperation;
import org.haxecommons.async.task.event.TaskEvent;
import org.haxecommons.async.task.ICountProvider;
import org.haxecommons.async.task.impl.ForBlock;
import org.haxecommons.async.test.AbstractTestWithMockRepository;

/**
 * @author SlavaRa
 */
class ForBlockTest extends AbstractTestWithMockRepository {

	public function new() super();

	private var _counter:Int;

	@Before
	public function setUp() _counter = 0;

	@Test
	public function testExecute() {
		var count = new CountProvider();
		var command = new MockAsyncCommand();
		
		var fb:ForBlock = new ForBlock(count);
		fb.and(command).end();
		fb.execute();
	}

	@AsyncTest
	public function testExecuteWithAsync(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 2000);
		var timer = haxe.Timer.delay(handler, 1900);
		
		var count = new CountProvider();
		var command1:Void->Void = function() _counter++;
		var handleComplete:TaskEvent->Void = function(event:TaskEvent) Assert.areEqual(10, _counter);
		
		var fb:ForBlock = new ForBlock(count);
		fb.next(MockOperation, ["test1", 100, false, command1]).end();
		fb.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
		fb.execute();
	}

	@Test
	public function testExecuteWithBreak() {
		var count = new CountProvider();
		var command = new MockAsyncCommand();
		var command2 = new MockAsyncCommand();
		
		var fb:ForBlock = new ForBlock(count);
		fb.and(command).break_().and(command2).end();
		fb.execute();
	}

	@Test
	public function testExecuteWithContinue() {
		var count:ICountProvider = new CountProvider();
		var command:ICommand = new MockAsyncCommand();
		var command2:ICommand = new MockAsyncCommand();
		
		var fb:ForBlock = new ForBlock(count);
		fb.and(command).continue_().and(command2).end();
		fb.execute();
	}
	
}