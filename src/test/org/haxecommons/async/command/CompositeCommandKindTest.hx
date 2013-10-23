package org.haxecommons.async.command;
import massive.munit.Assert;
import org.haxecommons.async.command.CompositeCommandKind;

/**
 * @author SlavaRa
 */
class CompositeCommandKindTest {

	public function new() {
		
	}
	
	@Test
	public function testEnumMembers() {
		Assert.isNotNull(CompositeCommandKind.PARALLEL);
		Assert.isNotNull(CompositeCommandKind.SEQUENCE);
	}

	@Test
	public function testFromNameWithUnknownName() {
		var kind = CompositeCommandKind.fromName("unknown");
		Assert.isNull(kind);
	}

	@Test
	public function testFromNameWithValidNames() {
		var kind = CompositeCommandKind.fromName("sequence");
		Assert.areEqual(kind, CompositeCommandKind.SEQUENCE);
		
		kind = CompositeCommandKind.fromName("parallel");
		Assert.areEqual(kind, CompositeCommandKind.PARALLEL);
		
		kind = CompositeCommandKind.fromName("SEQUENCE");
		Assert.areNotEqual(kind, CompositeCommandKind.SEQUENCE);
		
		kind = CompositeCommandKind.fromName("PARALLEL");
		Assert.areNotEqual(kind, CompositeCommandKind.PARALLEL);
	}
	
}