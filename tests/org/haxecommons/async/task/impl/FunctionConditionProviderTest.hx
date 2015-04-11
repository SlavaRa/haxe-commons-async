package org.haxecommons.async.task.impl;
import massive.munit.Assert;
import org.haxecommons.async.task.impl.FunctionConditionProvider;

/**
 * @author SlavaRa
 */
class FunctionConditionProviderTest {

	public function new() {}
	
	@Test
	public function testGetResult() {
		var called = false;
		var fcp = new FunctionConditionProvider(function() {called = true; return true; });
		Assert.isTrue(fcp.getResult());
		Assert.isTrue(called);
	}
}