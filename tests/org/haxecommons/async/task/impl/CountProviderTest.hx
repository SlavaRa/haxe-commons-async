package org.haxecommons.async.task.impl;
import massive.munit.Assert;
import org.haxecommons.async.task.impl.CountProvider;

class CountProviderTest {

	public function new() {}
	
	@Test
	public function testGetCount() {
		Assert.areEqual(100, new CountProvider(100).getCount());
	}
}