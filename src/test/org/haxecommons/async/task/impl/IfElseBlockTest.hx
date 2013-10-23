package org.haxecommons.async.task.impl;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.command.impl.MockAsyncCommand;
import org.haxecommons.async.task.IConditionProvider;
import org.haxecommons.async.task.impl.IfElseBlock;
import org.haxecommons.async.test.AbstractTestWithMockRepository;

/**
 * @author SlavaRa
 */
class IfElseBlockTest extends AbstractTestWithMockRepository {

	public function new() super();
	
	@Test
	public function testExecuteWithTrue() {
		var condition = new FunctionConditionProvider(null);
		var command = new MockAsyncCommand();
		var command2 = new MockAsyncCommand();
		
		var ifelse = new IfElseBlock(condition);
		ifelse.and(command).else_().and(command2);
		ifelse.execute();
	}

	@Test
	public function testExecuteWithFalse() {
		var condition = new FunctionConditionProvider(null);
		var command = new MockAsyncCommand();
		var command2 = new MockAsyncCommand();
		
		var ifelse = new IfElseBlock(condition);
		ifelse.and(command).else_().and(command2);
		ifelse.execute();
	}
}