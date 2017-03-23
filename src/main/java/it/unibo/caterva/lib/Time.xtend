package it.unibo.caterva.lib

import org.eclipse.xtend.lib.annotations.Data
import com.google.inject.Singleton
import it.unibo.caterva.core.AggregateSupport
import static it.unibo.caterva.lib.Standard.*

@Data @Singleton class Time {
	
	val AggregateSupport fc
	
	def <V extends Comparable<V>> V T(V initial, V zero, (V)=>V decay) {
		fc.stateful(initial, [min(initial, max(zero, decay.apply(it)))])
	}
	
}