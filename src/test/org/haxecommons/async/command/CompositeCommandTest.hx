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
		var c = new MockAsyncCommand();
        var o = new MockOperation(null);
		var cc = new CompositeCommand();
		Assert.areEqual(0, cc.numCommands);
		cc.addCommand(c);
		Assert.areEqual(1, cc.numCommands);
		cc.addOperation(Type.getClass(o));
		Assert.areEqual(2, cc.numCommands);
	}
	
	@AsyncTest
	public function testSequenceExecute(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 4000);
		var timer = haxe.Timer.delay(handler, 3900);
		
		var cc = new CompositeCommand(CompositeCommandKind.SEQUENCE);
		var counter = 0;
		var command1:Void->Void = function() {
			Assert.areEqual(0, counter);
			counter++;
		}
		var command2:Void->Void = function() Assert.areEqual(1, counter);
		cc.addOperation(MockOperation, ["test1", 2000, false, command1]).addOperation(MockOperation, ["test2", 1000, false, command2]);
		cc.execute();
	}
	
	@AsyncTest
	public function testParallelExecute(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 6000);
		var timer = haxe.Timer.delay(handler, 5900);
		
		var cc = new CompositeCommand(CompositeCommandKind.PARALLEL);
		var counter = 0;
		var command1:Void->Void = function() Assert.areEqual(1, counter);
		var command2:Void->Void = function() {
			Assert.areEqual(0, counter);
			counter++;
		}
		cc.addOperation(MockOperation, ["test1", 4000, false, command1, false]).addOperation(MockOperation, ["test2", 1000, false, command2, false]);
		cc.execute();
	}
	
	@AsyncTest
	public function testFailOnfaultIsTrue(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 4000);
		var timer = haxe.Timer.delay(handler, 3900);
		
		var cc = new CompositeCommand(CompositeCommandKind.SEQUENCE);
		var counter = 0;
		var command1:Void->Void = function() Assert.isTrue(true);
		var command2:Void->Void = function() Assert.isTrue(false);
		cc.addOperation(MockOperation, ["test1", 2000, true, command1, false]).addOperation(MockOperation, ["test2", 1000, false, command2, false]);
		cc.failOnFault = true;
		cc.execute();
	}
	
	@AsyncTest
	public function testFailOnfaultIsFalse(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 4000);
		var timer = haxe.Timer.delay(handler, 3900);
		
		var cc = new CompositeCommand(CompositeCommandKind.SEQUENCE);
		var counter:Int = 0;
		var command1:Void->Void = function() {
			Assert.areEqual(0, counter);
			counter++;
		}
		
		var command2:Void->Void = function() Assert.areEqual(1, counter);
		cc.addOperation(MockOperation, ["test1", 2000, true, command1, false]).addOperation(MockOperation, ["test2", 1000, false, command2, false]);
		cc.failOnFault = false;
		cc.execute();
	}
}