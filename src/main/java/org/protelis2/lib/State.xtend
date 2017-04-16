package org.protelis2.lib

import org.protelis2.core.AggregateSupport
import org.eclipse.xtend.lib.annotations.Data

@Data class State {
	val AggregateSupport fc
	
	def <X> X repByNeed(=>X init, (X)=>X rep) {
		fc.stateful(init, [[rep.apply(it.apply)]]).apply()
	}
}