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
import it.unibo.caterva.core.Field
import it.unibo.caterva.core.DeviceUID
import com.google.inject.Singleton
import com.google.common.collect.Maps
import it.unibo.caterva.core.CodePointGenerator
import it.unibo.caterva.core.CodePoint

@Singleton
final class Context implements AggregateSupport {
	
	private static class RepToken {}
	private static class NbrToken {}
	
	val DeviceUID device
	val Comm comm
	val CodePointGenerator stack
	var Set<DeviceUID> neighbors
	val Map<CodePoint, Object> nbrs = new LinkedHashMap
	var Map<CodePoint, Object> reps = new LinkedHashMap
	var Map<CodePoint, Object> newreps = new LinkedHashMap
	var Table<DeviceUID, CodePoint, Object> state

	@Inject
	new(DeviceUID d, Comm c, CodePointGenerator stack) {
		this.device = Objects.requireNonNull(d)
		comm = Objects.requireNonNull(c)
		this.stack = Objects.requireNonNull(stack)
	}

	override <I, O> O restrictedOn(I x, (I)=>O fun) {
		val oldneighs = neighbors
		val cp = stack.enterContext(x)
		neighbors = state.column(cp).keySet.filter[neighbors.contains(it)].toSet
		val res = fun.apply(x)
		stack.exitContext
		neighbors = oldneighs
		res
	}

	override  <K> Field<K> neighbor(K x) {
		val cp = stack.enterContext(typeof(NbrToken))
		if(nbrs.put(cp, x) !== null) {
			throw new IllegalStateException('''Aligned cancellation at «cp
				»: make sure you have not aligned twice on the same object at the same point in code''')
		}
		stack.exitContext
		new Field(state.column(cp).filter[neighbors.contains($0)], device, x)
	}

	override <X> stateful(X x, (X)=>X f) {
		val cp = stack.enterContext(typeof(RepToken))
		val computed = f.apply((reps.get(cp) ?: x) as X)
		if (newreps.put(cp, computed) !== null) {
			throw new IllegalStateException('''State cancellation at «cp
				»: make sure you have not aligned twice on the same object at the same point in code''')
		}
		stack.exitContext
		computed
	}

	override self() {
		device
	}

	override <X> cycle(() => X program) {
		newreps = Maps.newLinkedHashMapWithExpectedSize(newreps.size)
		state = ImmutableTable.copyOf(comm.state)
		neighbors = Objects.requireNonNull(state.rowKeySet)
			.filter[!device.equals(it)]
			.toSet
		val res = program.apply()
		stack.refresh
		reps = newreps
		comm.shareState(Collections.unmodifiableMap(nbrs))
		res
	}

}

