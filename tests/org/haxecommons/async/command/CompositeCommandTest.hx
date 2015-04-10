package org.haxecommons.async.command;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.haxecommons.async.command.CompositeCommandKind;
import org.haxecommons.async.command.impl.CompositeCommand;
import org.haxecommons.async.command.impl.MockAsyncCommand;
import org.haxecommons.async.operation.impl.MockOperation;
import org.haxecommons.async.test.AbstractTestWithMockRepository;

/**
 * @author SlavaRa
 */
class CompositeCommandTest extends AbstractTestWithMockRepository {

	public function new() super();
	
	@Test
	public function testAddCommandAndOperation() {
		var cc = new CompositeCommand();
		Assert.areEqual(0, cc.numCommands);
		cc.addCommand(new MockAsyncCommand());
		Assert.areEqual(1, cc.numCommands);
		cc.addOperation(Type.getClass(new MockOperation(null)));
		Assert.areEqual(2, cc.numCommands);
	}
	
	@AsyncTest
	public function testSequenceExecute(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 400), 300);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var i = 0;
		new CompositeCommand(CompositeCommandKind.SEQUENCE)
			.addOperation(MockOperation, ["test1", 100, false, function() Assert.areEqual(0, i++)])
			.addOperation(MockOperation, ["test2", 200, false, function() Assert.areEqual(1, i)])
			.execute();
	}
	
	@AsyncTest
	public function testParallelExecute(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 600), 500);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var i = 0;
		new CompositeCommand(CompositeCommandKind.PARALLEL)
			.addOperation(MockOperation, ["test1", 400, false, function() Assert.areEqual(1, i), false])
			.addOperation(MockOperation, ["test2", 100, false, function() Assert.areEqual(0, i++), false])
			.execute();
	}
	
	@AsyncTest
	public function testFailOnFaultIsTrue(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 400), 300);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		new CompositeCommand(CompositeCommandKind.SEQUENCE)
			.setFailOnFault(true)
			.addOperation(MockOperation, ["test1", 200, true, function(){}, false])
			.addOperation(MockOperation, ["test2", 100, false, function() Assert.fail(""), false])
			.execute();
	}
	
	@AsyncTest
	public function testFailOnFaultIsFalse(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 400), 300);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var i = 0;
		new CompositeCommand(CompositeCommandKind.SEQUENCE)
			.setFailOnFault(false)
			.addOperation(MockOperation, ["test1", 200, true, function() Assert.areEqual(0, i++), false])
			.addOperation(MockOperation, ["test2", 100, false, function() Assert.areEqual(1, i), false])
			.execute();
	}
}