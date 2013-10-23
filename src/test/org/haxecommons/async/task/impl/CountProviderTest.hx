package org.haxecommons.async.task.impl;
import massive.munit.Assert;
import org.haxecommons.async.task.impl.CountProvider;

/**
 * @author SlavaRa
 */
class CountProviderTest {

	public function new() {
	}
	
	@Test
	public function testGetCount() {
		var cp = new CountProvider(100);
		Assert.areEqual(100, cp.getCount());
	}
}