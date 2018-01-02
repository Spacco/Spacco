package org.protelis2.core.impl

import com.google.common.collect.ImmutableTable
import com.google.common.collect.Table
import com.google.inject.Inject
import java.util.Collections
import java.util.LinkedHashMap
import java.util.Map
import java.util.Set
import java.util.Objects
import org.protelis2.core.AggregateSupport
import org.protelis2.core.Comm
import org.protelis2.core.Field
import org.protelis2.core.DeviceUID
import com.google.inject.Singleton
import com.google.common.collect.Maps
import org.protelis2.core.CodePoint
import org.eclipse.xtend.lib.annotations.Data
import org.protelis2.core.Stack

@Singleton
final class Context implements AggregateSupport {
	
	@Data private static class RepToken {
		val Class<?> funtype
		override toString() { "REP_" + funtype.name.substring(funtype.name.lastIndexOf(".") + 1) }
	}
	@Data private static class Wrapper {
		val Object wrapped
		override toString() { '''w(«wrapped»)''' }
	}
	private static class NbrToken {
		static val SINGLETON = new NbrToken
		override equals(Object o) { o instanceof NbrToken }
		override hashCode() { 0 }
		override toString() { 'nbr' }
	}
	
	val DeviceUID device
	val Comm comm
	val Stack stack
	var Set<DeviceUID> neighbors
	val Map<CodePoint, Object> nbrs = new LinkedHashMap
	var Map<CodePoint, Object> reps = new LinkedHashMap
	var Map<CodePoint, Object> newreps = new LinkedHashMap
	var Table<DeviceUID, CodePoint, Object> state

	@Inject
	new(DeviceUID d, Comm c, Stack stack) {
		this.device = Objects.requireNonNull(d)
		comm = Objects.requireNonNull(c)
		this.stack = Objects.requireNonNull(stack)
	}

	override <I, O> O restrictedOn(I x, (I)=>O fun) {
		val oldneighs = neighbors
		val cp = stack.enterContext(x)
		neighbors = state.column(cp).keySet.filter[neighbors.contains(it)].toSet
		try {
			val res = fun.apply(x)
			res
		} finally {
			stack.exitContext
			neighbors = oldneighs
		}
	}

	override  <K> Field<K> neighbor(K x) {
		contextualizeAndRun(nbrs, NbrToken.SINGLETON, [
			if(nbrs.put(it, x) !== null) {
				throw new IllegalStateException('''Aligned cancellation at «it
					»: make sure you have not aligned twice on the same object at the same point in code''')
			}
			new Field(state.column(it).filter[neighbors.contains($0)] as Map<DeviceUID, K>, device, x)
		])
	}

	override <X> stateful(X x, (X)=>X f) {
		contextualizeAndRun(newreps, new RepToken(f.class), [
			val computed = f.apply((reps.get(it) ?: x) as X)
			if (newreps.put(it, computed) !== null) {
				throw new IllegalStateException('''State cancellation at «it
					»: make sure you have not aligned twice on the same object at the same point in code''')
			}
			computed
		])
	}
	
	override self() {
		device
	}

	override <X> cycle(() => X program) {
		newreps = Maps.newLinkedHashMapWithExpectedSize(newreps.size)
		state = ImmutableTable.copyOf(comm.state)
		neighbors = Objects.requireNonNull(state.rowKeySet)
			.reject[device.equals(it)]
			.toSet
		nbrs.clear
		val res = program.apply()
		stack.refresh
		reps = newreps
		comm.shareState(Collections.unmodifiableMap(nbrs))
		res
	}

	def private <X> X contextualizeAndRun(Map<CodePoint, Object> target, Object token, (CodePoint)=>X fun) {
		val cp = stack.enterContext(token)
		if (target.containsKey(cp)) {
			/*
			 * Aligned cancellation: artificially build a "all" structure.
			 */
			 stack.exitContext
			 contextualizeAndRun(target, new Wrapper(token), fun)
		} else {
			try {
				fun.apply(cp)
			} finally {
				stack.exitContext
			}
		}
	}

}

