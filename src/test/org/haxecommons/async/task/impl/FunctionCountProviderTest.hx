package org.haxecommons.async.task.impl;
import massive.munit.Assert;
import org.haxecommons.async.task.impl.FunctionCountProvider;

/**
 * @author SlavaRa
 */
class FunctionCountProviderTest {

	public function new() {
	}
	
	var _called:Bool;

	@Test
	public function testGetResult() {
		var fcp = new FunctionCountProvider(testResult);
		Assert.areEqual(10, fcp.getCount());
		Assert.isTrue(_called);
	}

	function testResult():Int {
		_called = true;
		return 10;
	}
}