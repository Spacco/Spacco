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
import com.google.common.collect.Maps
import com.sun.istack.internal.NotNull
import com.google.common.collect.Table
import com.google.common.collect.Tables
import com.google.common.collect.ImmutableTable

final class Context implements AggregateSupport {

	val Device device
	val Comm comm
	var Set<Device> neighbors
	val Map<CodePoint, Object> nbrs = new LinkedHashMap
	var Map<CodePoint, Object> reps = new LinkedHashMap
	var Map<CodePoint, Object> newreps = new LinkedHashMap
	@NotNull var Table<Device, CodePoint, Object> state

	@Inject
	new(Device d, Comm c) {
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
		nbrs.put(cp, x)
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
		neighbors = state.rowKeySet
		val res = program.apply()
		reps = newreps
		comm.shareState(Collections.unmodifiableMap(nbrs))
		res
	}

}

