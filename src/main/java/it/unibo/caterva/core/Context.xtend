package it.unibo.caterva.core

import java.util.Collections
import java.util.LinkedHashMap
import java.util.LinkedHashSet
import java.util.List
import java.util.Map
import java.util.Set
import com.google.inject.Injector
import com.google.inject.Guice
import com.google.inject.Inject

final class Context implements AggregateProgram {

	private final Device device
	private final Comm comm
	private final Set<Device> neighbors = new LinkedHashSet
	private Map<CodePoint, Field<?>> nbrs
	private Map<CodePoint, Object> reps
	private Map<CodePoint, Object> newreps

	@Inject
	private new(Device d, Comm c) {
		this.device = d
		comm = c
	}

	override synchronized <I, O> O restrictedOn(I x, (I)=>O fun) {
//		fun.apply(
//			ne
//			x
//		)
	}

	override <K> Field<K> neighbor(K x) {
		val cp = new CodePoint(0)
//		comm.share(cp, x);
//		nbrs.put
		null
	}

	// "init" e "complete"? Forse meglio avere una VM da alimentare con una lambda che prende in ingresso il contesto?

	override <X> X stateful(X x, (X)=>X f) {
		val cp = new CodePoint(0)
		val computed = f.apply((reps.get(cp) ?: x) as X)
		newreps.put(cp, computed)
		computed
	}

	override Device self() {
		device
	}
}

