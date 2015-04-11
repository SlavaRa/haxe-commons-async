package org.haxecommons.async.task.impl;
import org.haxecommons.async.command.impl.MockAsyncCommand;
import org.haxecommons.async.task.impl.IfElseBlock;

/**
 * @author SlavaRa
 */
class IfElseBlockTest {

	public function new() {}
	
	@Test
	public function testExecuteWithTrue() {
		new IfElseBlock(new FunctionConditionProvider(null))
			.and(new MockAsyncCommand())
			.else_()
			.and(new MockAsyncCommand())
			.execute();
	}

	@Test
	public function testExecuteWithFalse() {
		new IfElseBlock(new FunctionConditionProvider(null))
			.and(new MockAsyncCommand())
			.else_()
			.and(new MockAsyncCommand())
			.execute();
	}
}