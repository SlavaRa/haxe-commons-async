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

	public function new() {}
	
	@AsyncTest
	public function testExecute(factory:AsyncFactory) {
		var t = Timer.delay(factory.createHandler(this, function(){}, 2000), 1900);
		#if ((neko && !display) || cpp)
		t.run();
		#end
		var command = new PauseCommand(500);
		var timer = Timer.delay(function() Assert.fail(""), 1000);
		command.addCompleteListener(function(event:OperationEvent) {
			Assert.areEqual(command, event.target);
			timer.stop();
		});
		command.execute();
	}
}