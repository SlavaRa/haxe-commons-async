package org.haxecommons.async.task.command;
import haxe.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.task.command.PauseCommand;

/**
 * @author SlavaRa
 */
class PauseCommandTest {

	public function new() {
	}
	
	@AsyncTest
	public function testExecute(asyncFactory:AsyncFactory) {
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.isFalse(false), 2000);
		var timer = haxe.Timer.delay(handler, 1900);
		
		var pc = new PauseCommand(500);
		var handleError:Void->Void = function() Assert.isTrue(false);
		var timer = Timer.delay(handleError, 1000);
		var handleComplete:OperationEvent->Void = function(event:OperationEvent) {
			Assert.areEqual(pc, event.target);
			timer.stop();
		};
		pc.addCompleteListener(handleComplete);
		pc.execute();
	}
}