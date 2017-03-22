package it.unibo.caterva.core.impl

import it.unibo.caterva.core.CodePoint
import it.unibo.caterva.core.CodePointGenerator
import java.util.Arrays
import java.util.Deque
import java.util.LinkedList

class SimpleStack implements CodePointGenerator {

	val Deque<Object> stack = new LinkedList

	override refresh() {
		if (!stack.isEmpty) {
			throw new IllegalStateException
		}
	}
	
	override enterContext(Object alignOn) {
		stack.push(alignOn)
		new SimpleCodePoint(stack)
	}
	
	override exitContext() {
		stack.pop
	}
	
	override toString() {
		stack.toString
	}
	
	private static class SimpleCodePoint implements CodePoint {
		val Object[] repr
		var int hash
		new(Deque<Object> stack) {
			repr = stack.toArray
		}
		override equals(Object obj) {
			if (obj === this) {
				return true
			}
			if (obj instanceof SimpleCodePoint) {
				return Arrays.equals(repr, obj.repr)
			}
			false
		}
		override hashCode() {
			if (hash == 0) {
				hash = repr.length.bitwiseXor((repr.get(0) ?: 0).hashCode)
			}
			hash
		}
		override toString() {
			repr.join('->')
		}
	}
}