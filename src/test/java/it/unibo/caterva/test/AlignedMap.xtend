package it.unibo.caterva.test

import it.unibo.caterva.test.AbstractTest
import com.google.inject.Inject
import it.unibo.caterva.lib.Alignment
import static it.unibo.caterva.lib.Standard.minHoodWithSelf

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
			minHoodWithSelf(align.alignedMap(fc.neighbor(it), [1], [v, k | v + 1]))
		])
	}
	
}