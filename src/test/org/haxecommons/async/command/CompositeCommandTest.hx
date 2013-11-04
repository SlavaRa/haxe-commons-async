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
		Assert.areEqual(cc.numCommands, 0);
		cc.addCommand(c);
		Assert.areEqual(cc.numCommands, 1);
		cc.addOperation(Type.getClass(o));
		Assert.areEqual(cc.numCommands, 2);
	}
	
	@AsyncTest
	public function testSequenceExecute(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isNull(null), 4000);
		haxe.Timer.delay(handler, 3900);
		
		var cc = new CompositeCommand(CompositeCommandKind.SEQUENCE);
		var counter = 0;
		var command1:Void->Void = function() {
			Assert.areEqual(counter, 0);
			counter++;
		}
		var command2:Void->Void = function() Assert.areEqual(counter, 1);
		
		cc.addOperation(MockOperation, ["test1", 1000, false, command1]).addOperation(MockOperation, ["test2", 2000, false, command2]);
		cc.execute();
	}
	
	@AsyncTest
	public function testParallelExecute(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isNull(null), 6000);
		haxe.Timer.delay(handler, 5900);
		
		var cc = new CompositeCommand(CompositeCommandKind.PARALLEL);
		var counter = 0;
		var command1:Void->Void = function() Assert.areEqual(counter, 1);
		var command2:Void->Void = function() {
			Assert.areEqual(counter, 0);
			counter++;
		}
		cc.addOperation(MockOperation, ["test1", 4000, false, command1, false]).addOperation(MockOperation, ["test2", 1000, false, command2, false]);
		cc.execute();
	}
	
	@AsyncTest
	public function testFailOnFaultIsTrue(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isNull(null), 4000);
		haxe.Timer.delay(handler, 3900);
		
		var cc = new CompositeCommand(CompositeCommandKind.SEQUENCE);
		var command1:Void->Void = function() Assert.isTrue(true);
		var command2:Void->Void = function() Assert.isTrue(false);
		cc.addOperation(MockOperation, ["test1", 2000, true, command1, false]).addOperation(MockOperation, ["test2", 1000, false, command2, false]);
		cc.failOnFault = true;
		cc.execute();
	}
	
	@AsyncTest
	public function testFailOnFaultIsFalse(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isNull(null), 4000);
		haxe.Timer.delay(handler, 3900);
		
		var cc = new CompositeCommand(CompositeCommandKind.SEQUENCE);
		var counter = 0;
		var command1:Void->Void = function() {
			Assert.areEqual(counter, 0);
			counter++;
		}
		
		var command2:Void->Void = function() {
			Assert.areEqual(counter, 1);
		}
		cc.addOperation(MockOperation, ["test1", 2000, true, command1, false]).addOperation(MockOperation, ["test2", 1000, false, command2, false]);
		cc.failOnFault = false;
		cc.execute();
	}
	
}