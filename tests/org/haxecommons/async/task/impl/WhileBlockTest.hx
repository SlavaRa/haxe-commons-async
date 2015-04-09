package org.haxecommons.async.task.impl;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.haxecommons.async.command.impl.MockAsyncCommand;
import org.haxecommons.async.operation.impl.MockOperation;
import org.haxecommons.async.task.event.TaskEvent;
import org.haxecommons.async.task.impl.FunctionConditionProvider;
import org.haxecommons.async.task.impl.WhileBlock;
import org.haxecommons.async.test.AbstractTestWithMockRepository;

/**
 * @author SlavaRa
 */
class WhileBlockTest extends AbstractTestWithMockRepository {

	public function new() super();

	private var _counter:Int;

	@Before
	public function setUp() _counter = 0;

	@Test
	public function testExecute() {
		var command = new MockAsyncCommand();
		var wb = new WhileBlock(new FunctionConditionProvider(whileFunction));
		wb.and(command);
		wb.execute();
	}

	@AsyncTest
	public function testExecuteWithAsync(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 2000);
		#if (neko && !display)
		haxe.Timer.delay(handler, 1900).run();
		#else
		haxe.Timer.delay(handler, 1900);
		#end 
		var command1:Void->Void = function() Assert.isTrue(_counter < 11);
		var handleComplete:TaskEvent->Void = function(event:TaskEvent) Assert.areEqual(11, _counter);
		var wb = new WhileBlock(new FunctionConditionProvider(whileFunction));
		wb.next(MockOperation, ["test1", 100, false, command1]).end();
		wb.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
		wb.execute();
	}

	function whileFunction():Bool return _counter++ < 10;
}