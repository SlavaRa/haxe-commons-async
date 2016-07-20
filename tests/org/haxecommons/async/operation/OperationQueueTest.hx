package org.haxecommons.async.operation;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.impl.AbstractOperation;
import org.haxecommons.async.operation.impl.OperationQueue;

/**
 * @author SlavaRa
 */
class OperationQueueTest {

	public function new() {}
	
	@AsyncTest
	public function testQueue(factory:AsyncFactory) {
		var t = haxe.Timer.delay(factory.createHandler(this, function() {}, 200), 100);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var queue = new OperationQueue();
		var operation0 = Type.createInstance(AbstractOperation, []);
		var operation1 = Type.createInstance(AbstractOperation, []);
		queue.addOperation(operation0);
		queue.addOperation(operation1);
		queue.addEventListener(OperationEvent.COMPLETE, function(event:OperationEvent) Assert.areEqual(queue, event.target));
		operation0.dispatchCompleteEvent();
		operation1.dispatchCompleteEvent();
	}
}