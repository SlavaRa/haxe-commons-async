package org.haxecommons.async.task.impl;
import massive.munit.Assert;
import org.haxecommons.async.task.impl.FunctionCountProvider;

/**
 * @author SlavaRa
 */
class FunctionCountProviderTest {

	public function new() {}
	
	@Test
	public function testGetResult() {
		var called = false;
		var fcp = new FunctionCountProvider(function() {called = true; return 10;});
		Assert.areEqual(10, fcp.getCount());
		Assert.isTrue(called);
	}
}