package org.haxecommons.async.command;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.haxecommons.async.command.impl.GenericOperationCommand;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.impl.MockOperation;
import org.haxecommons.async.test.AbstractTestWithMockRepository;

/**
 * @author SlavaRa
 */
class GenericOperationCommandTest extends AbstractTestWithMockRepository {

	public function new() super();
	
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
	public function testExecute(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 2000);
		var timer = haxe.Timer.delay(handler, 1900);
		
		var result = [];
		var completeListener:OperationEvent->Void = function(event:OperationEvent) Assert.areNotEqual(event.result, result);
		var gc = new GenericOperationCommand(MockOperation, result);
		gc.addCompleteListener(completeListener);
		gc.execute();
	}
	
}