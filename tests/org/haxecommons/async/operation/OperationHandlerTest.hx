package org.haxecommons.async.operation;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.impl.AbstractOperation;
import org.haxecommons.async.operation.impl.OperationHandler;

/**
 * @author SlavaRa
 */
class OperationHandlerTest {

	public function new() {}
	
	@AsyncTest
	public function testHandleOperationWithResultMethod(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 200), 100);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var operation = new AbstractOperation();
		var result = {};
		operation.result = result;
		new OperationHandler().handleOperation(operation, function(res:Dynamic) Assert.areEqual(result, res));
		operation.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, operation));
	}
	
	@AsyncTest
	public function testHandleOperationWithObjectProperty(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 200), 100);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var operation = new AbstractOperation();
		var resultObject:Map<String, Dynamic> = new Map();
		resultObject.set("testProperty", {});
		var result:Map<String, Dynamic> = new Map();
		operation.result = result;
		new OperationHandler().handleOperation(operation, null, resultObject, "testProperty");
		operation.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, operation));
		Assert.areEqual(result, resultObject.get("testProperty"));
	}
	
	@AsyncTest
	public function testHandleOperationWithObjectPropertyAndResultMethod(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 200), 100);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var operation = new AbstractOperation();
		var resultObject:Map<String, Dynamic> = new Map();
		var resultMethodObject = {};
		resultObject.set("testProperty", {});
		var result:Map<String, Dynamic> = new Map();
		operation.result = result;
		var resultMethod:Dynamic->Dynamic = function(res:Dynamic):Dynamic {
			Assert.areEqual(result, res);
			return resultMethodObject;
		}
		new OperationHandler().handleOperation(operation, resultMethod, resultObject, "testProperty");
		operation.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, operation));
		Assert.areEqual(resultMethodObject, resultObject.get("testProperty"));
	}
	
	@AsyncTest
	public function testHandleOperationWithNothing(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function(){}, 200), 100);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var operation = new AbstractOperation();
		new OperationHandler().handleOperation(operation);
		operation.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, operation));
	}
}