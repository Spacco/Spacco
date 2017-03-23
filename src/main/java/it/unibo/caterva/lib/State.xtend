package it.unibo.caterva.lib

import it.unibo.caterva.core.AggregateSupport
import org.eclipse.xtend.lib.annotations.Data

@Data class State {
	val AggregateSupport fc
	
	def <X> X repByNeed(=>X init, (X)=>X rep) {
		fc.stateful(init, [[rep.apply(it.apply)]]).apply()
	}
}