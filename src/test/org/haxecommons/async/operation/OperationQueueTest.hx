package org.haxecommons.async.operation;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.impl.AbstractOperation;
import org.haxecommons.async.operation.impl.OperationQueue;
import org.haxecommons.async.test.AbstractTestWithMockRepository;

/**
 * @author SlavaRa
 */
class OperationQueueTest extends AbstractTestWithMockRepository {

	public function new() super();
	
	var _queue:OperationQueue;

	@Before
	public function setUp() _queue = new OperationQueue();

	@AsyncTest
	public function testQueue(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 1000);
		var timer = haxe.Timer.delay(handler, 900);
		
		var o1 = Type.createInstance(AbstractOperation, []);
		var o2 = Type.createInstance(AbstractOperation, []);
		
		_queue.addOperation(o1);
		_queue.addOperation(o2);
		
		var handleComplete:OperationEvent->Void = function(event:OperationEvent) Assert.areEqual(_queue, event.target);
		_queue.addEventListener(OperationEvent.COMPLETE, handleComplete);
		o1.dispatchCompleteEvent();
		o2.dispatchCompleteEvent();
	}
}