package org.protelis2.test

import org.protelis2.test.AbstractTest
import org.protelis2.core.AggregateSupport
import com.google.inject.Inject

class Multiline extends AbstractTest<Integer> {
	
	@Inject
	new(AggregateSupport fc) {
		super(fc)
	}
	
	override getExpectedResult(int cycle) {
		3 + cycle
	}
	
	override apply() {
		val one = fc.stateful(1, [it])
		val two = fc.stateful(2, [it])
		one + two + fc.stateful(0, [it + 1])
	}
	
}