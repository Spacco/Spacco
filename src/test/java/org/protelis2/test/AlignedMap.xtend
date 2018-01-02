package org.protelis2.test

import org.protelis2.test.AbstractTest
import com.google.inject.Inject
import org.protelis2.lib.Alignment
import static org.protelis2.lib.Standard.minHoodWithSelf

class AlignedMap extends AbstractTest<Integer> {
	
	val Alignment align
	
	@Inject
	new(Alignment align) {
		super(align.fc)
		this.align = align
	}
	
	override getExpectedResult(int cycle) {
		cycle + 1
	}
	
	override apply() {
		fc.stateful(1, [
			minHoodWithSelf(align.alignedMap(fc.neighbor(it), [1], [$0 + 1]))
		])
	}
	
}