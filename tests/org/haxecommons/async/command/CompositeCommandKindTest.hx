package org.haxecommons.async.command;
import massive.munit.Assert;
import org.haxecommons.async.command.CompositeCommandKind;

/**
 * @author SlavaRa
 */
class CompositeCommandKindTest {

	public function new() {}
	
	@Test
	public function testEnumMembers() {
		Assert.isNotNull(CompositeCommandKind.PARALLEL);
		Assert.isNotNull(CompositeCommandKind.SEQUENCE);
	}

	@Test
	public function testFromNameWithUnknownName() {
		Assert.isNull(CompositeCommandKind.fromName("unknown"));
		Assert.isNull(CompositeCommandKind.fromName(null));
	}

	@Test
	public function testFromNameWithValidNames() {
		Assert.areEqual(CompositeCommandKind.SEQUENCE, CompositeCommandKind.fromName("sequence"));
		Assert.areEqual(CompositeCommandKind.PARALLEL, CompositeCommandKind.fromName("parallel"));
		Assert.areNotEqual(CompositeCommandKind.SEQUENCE, CompositeCommandKind.fromName("SEQUENCE"));
		Assert.areNotEqual(CompositeCommandKind.PARALLEL, CompositeCommandKind.fromName("PARALLEL"));
	}
}