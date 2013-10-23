package org.haxecommons.async.operation;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.impl.AbstractOperation;
import org.haxecommons.async.operation.impl.OperationHandler;
import org.haxecommons.async.operation.IOperationHandler;
import org.haxecommons.async.test.AbstractTestWithMockRepository;

/**
 * @author SlavaRa
 */
class OperationHandlerTest extends AbstractTestWithMockRepository {

	public function new() super();
	
	var _operationHandler:IOperationHandler;
	
	@Before
	public function setUp() _operationHandler = new OperationHandler();
	
	@AsyncTest
	public function testHandleOperationWithResultMethod(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 1000);
		var timer = haxe.Timer.delay(handler, 900);
		
		var o = new AbstractOperation();
		var result:Dynamic = {};
		o.result = result;
		var resultMethod:Dynamic->Void = function(res:Dynamic) Assert.areEqual(res, result);
		_operationHandler.handleOperation(o, resultMethod);
		o.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, o));
	}
	
	@AsyncTest
	public function testHandleOperationWithObjectProperty(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 1000);
		var timer = haxe.Timer.delay(handler, 900);
		
		var o = new AbstractOperation();
		var resultObject:Map<String, Dynamic> = new Map<String, Dynamic>();
		resultObject.set("testProperty", {});
		var result:Map<String, Dynamic> = new Map<String, Dynamic>();
		o.result = result;
		_operationHandler.handleOperation(o, null, resultObject, "testProperty");
		o.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, o));
		Assert.areEqual(result, resultObject.get("testProperty"));
	}
	
	@AsyncTest
	public function testHandleOperationWithObjectPropertyAndResultMethod(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 1000);
		var timer = haxe.Timer.delay(handler, 900);
		
		var o = new AbstractOperation();
		var resultObject:Map<String, Dynamic> = new Map<String, Dynamic>();
		var resultMethodObject:Dynamic = {};
		resultObject.set("testProperty", {});
		var result:Map<String, Dynamic> = new Map<String, Dynamic>();
		o.result = result;
		var resultMethod:Dynamic->Dynamic = function(res:Dynamic):Dynamic {
			Assert.areEqual(res, result);
			return resultMethodObject;
		}
		_operationHandler.handleOperation(o, resultMethod, resultObject, "testProperty");
		o.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, o));
		Assert.areEqual(resultMethodObject, resultObject.get("testProperty"));
	}
	
	@AsyncTest
	public function testHandleOperationWithNothing(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 1000);
		var timer = haxe.Timer.delay(handler, 900);
		
		var o = new AbstractOperation();
		_operationHandler.handleOperation(o);
		o.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, o));
	}
}