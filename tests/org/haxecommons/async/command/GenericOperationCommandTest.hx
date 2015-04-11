package org.haxecommons.async.command;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.haxecommons.async.command.impl.GenericOperationCommand;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.impl.MockOperation;

/**
 * @author SlavaRa
 */
class GenericOperationCommandTest {

	public function new() {}
	
	@Test
	public function testConstructor() {
		var o = new MockOperation(null);
		var gc = new GenericOperationCommand(Type.getClass(o), ["test1", 1, null]);
		Assert.areEqual(Type.getClass(o), gc.operationClass);
		Assert.areEqual(3, gc.constructorArguments.length);
		Assert.areEqual("test1", gc.constructorArguments[0]);
		Assert.areEqual(1, gc.constructorArguments[1]);
		Assert.areEqual(null, gc.constructorArguments[2]);
	}
	
	@AsyncTest
	public function testExecute(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 200), 100);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var result = [];
		var gc = new GenericOperationCommand(MockOperation, result);
		gc.addCompleteListener(function(event:OperationEvent) Assert.areNotEqual(result, event.result));
		gc.execute();
	}
}