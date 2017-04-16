package org.protelis2.core

import java.util.Map
import java.util.Collections
import java.util.LinkedHashMap
import com.google.common.base.Optional

final class Field<K> {

	val Map<DeviceUID, K> values
	val DeviceUID local;
	val K localVal;

	new(Map<DeviceUID, K> repr, DeviceUID device, K localVal) {
		values = Collections.unmodifiableMap(repr)
		local = device
		this.localVal = localVal
	}

	def size() {
		values.size
	}

	def <I, O> Field<O> map(Field<I> field, (K, I)=>O fun) {
		if (field.size() != values.size()) {
			throw new IllegalStateException('''Misaligned fields: «this», «field»''')
		}
		val res = new LinkedHashMap(field.size())
		field.values.forEach [ d, v |
			val myval = values.get(d)
			if (myval === null) {
				throw new IllegalStateException('''Misaligned fields: «this», «field»''')
			}
			res.put(d, fun.apply(myval, v))
		]
		new Field(res, local, fun.apply(localVal, field.localVal))
	}

	def <I, O> Field<O> map((K)=>O fun) {
		new Field(values.mapValues([fun.apply(it)]), local, fun.apply(localVal))
	}

	def Optional<K> reduce((K, K)=>K fun) {
		Optional.fromNullable(
			if (values.size > 0) {
				val iterator = values.values.iterator
				var accumulator = iterator.next
				while (iterator.hasNext) {
					accumulator = fun.apply(accumulator, iterator.next)
				}
				accumulator
			}
		)
	}

	def K reduceWithSelf((K, K)=>K fun) {
		reduce(fun).transform[fun.apply(localVal, it)].or(localVal)
	}

	override toString() {
		'''{«local»:«localVal»}, «values»'''
	}

}
