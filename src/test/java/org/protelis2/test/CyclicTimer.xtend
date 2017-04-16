package org.protelis2.test

import org.protelis2.core.AggregateSupport
import javax.inject.Inject
import org.protelis2.lib.Time

class CyclicTimer extends AbstractTest<Boolean> {
	
	val Time t
	
	@Inject
	new(AggregateSupport fc, Time t) {
		super(fc)
		this.t = t
	}
	
	override getExpectedResult(int cycle) {
		cycle % 10 == 0
	}
	override apply() {
		cyclicTimer(10, 1)
	}
	def cyclicTimer(int length, int decay) {
		fc.stateful(length, [
			if (it == 0) {
				length
			} else {
				t.T(length - 1, 0, [it - decay])
			}
		]) == length
	}
}