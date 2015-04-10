package org.haxecommons.async.task.impl;
import massive.munit.Assert;
import org.haxecommons.async.task.impl.FunctionConditionProvider;

/**
 * @author SlavaRa
 */
class FunctionConditionProviderTest {

	public function new() {
	}
	
	private var _called:Bool;

	@Test
	public function testGetResult() {
		var fcp = new FunctionConditionProvider(testResult);
		Assert.isTrue(fcp.getResult());
		Assert.isTrue(_called);
	}

	function testResult():Bool {
		_called = true;
		return true;
	}
}