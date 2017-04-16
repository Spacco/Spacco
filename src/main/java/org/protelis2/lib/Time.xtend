package org.protelis2.lib

import org.eclipse.xtend.lib.annotations.Data
import com.google.inject.Singleton
import org.protelis2.core.AggregateSupport
import static org.protelis2.lib.Standard.*

@Data @Singleton class Time {
	
	val AggregateSupport fc
	
	def <V extends Comparable<V>> V T(V initial, V zero, (V)=>V decay) {
		fc.stateful(initial, [min(initial, max(zero, decay.apply(it)))])
	}
	
}