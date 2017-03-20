package it.unibo.caterva.core.impl

import com.google.common.collect.ImmutableTable
import com.google.common.collect.Table
import com.google.inject.Inject
import java.util.Collections
import java.util.LinkedHashMap
import java.util.Map
import java.util.Set
import java.util.Objects
import it.unibo.caterva.core.AggregateSupport
import it.unibo.caterva.core.Comm
import it.unibo.caterva.core.CodePoint
import it.unibo.caterva.core.Field
import it.unibo.caterva.core.DeviceUID

final class Context implements AggregateSupport {

	val DeviceUID device
	val Comm comm
	var Set<DeviceUID> neighbors
	val Map<CodePoint, Object> nbrs = new LinkedHashMap
	var Map<CodePoint, Object> reps = new LinkedHashMap
	var Map<CodePoint, Object> newreps = new LinkedHashMap
	var Table<DeviceUID, CodePoint, Object> state

	@Inject
	new(DeviceUID d, Comm c) {
		this.device = d
		comm = c
	}

	override <I, O> O restrictedOn(I x, (I)=>O fun) {
		val oldneighs = neighbors
		val cp = new CodePoint(x)
		neighbors = state.column(cp).keySet.filter[neighbors.contains(it)].toSet
		val res = fun.apply(x)
		neighbors = oldneighs
		res
	}

	override  <K> Field<K> neighbor(K x) {
		val cp = new CodePoint(0)
		if(nbrs.put(cp, x) !== null) {
			throw new IllegalStateException('''Aligned cancellation at «cp
				»: make sure you have not aligned twice on the same object at the same point in code''')
		}
		new Field(state.column(cp).filter[neighbors.contains($0)], device, x)
	}

	override <X> stateful(X x, (X)=>X f) {
		val cp = new CodePoint(0)
		val computed = f.apply((reps.get(cp) ?: x) as X)
		newreps.put(cp, computed)
		computed
	}

	override self() {
		device
	}

	override <X> cycle(() => X program) {
		newreps.clear
		state = ImmutableTable.copyOf(comm.state)
		neighbors = Objects.requireNonNull(state.rowKeySet)
			.filter[!device.equals(it)]
			.toSet
		val res = program.apply()
		reps = newreps
		comm.shareState(Collections.unmodifiableMap(nbrs))
		res
	}

}

