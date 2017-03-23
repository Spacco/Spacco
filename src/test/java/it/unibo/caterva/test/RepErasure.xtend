package it.unibo.caterva.test

import it.unibo.caterva.test.AbstractTest
import it.unibo.caterva.core.AggregateSupport
import com.google.inject.Inject
import it.unibo.caterva.lib.Alignment

class RepErasure extends AbstractTest<Integer> {
	
	val Alignment align
	
	@Inject
	new(AggregateSupport fc, Alignment align) {
		super(fc)
		this.align = align
	}
	
	override getExpectedResult(int cycle) {
		2 - cycle % 2
	}
	
	override apply() {
		val ()=>Integer fun = [fc.stateful([0], [it + 1])]
		align.branch(fc.stateful([-1], [it + 1]) % 4 < 2, fun, fun)
	}
	
}