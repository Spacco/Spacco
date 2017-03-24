package it.unibo.caterva.core.impl

import it.unibo.caterva.core.CodePoint
import java.util.Arrays
import java.util.Deque
import java.util.LinkedList
import org.apache.commons.math3.random.RandomGenerator
import com.google.inject.Inject
import org.eclipse.xtend.lib.annotations.Data
import it.unibo.caterva.core.Stack

class SimpleStack implements Stack {

	static val SEED = 0x7f150540ed056752#L
	static val SEQSTART = 0
	val Deque<StackFrame> stack = new LinkedList
	val RandomGenerator rng
	var int seq

	@Inject
	new(RandomGenerator rng) {
		this.rng = rng
		refresh
	}

	final override refresh() {
		if (!stack.isEmpty) {
			throw new IllegalStateException("The computation concluded but the call stack is not empty. This is likely a bug")
		}
		rng.seed = SEED
		seq = SEQSTART
	}
	
	override enterContext(Object alignOn) {
		stack.push(new StackFrame(rng.nextLong, seq++, alignOn))
		new SimpleCodePoint(stack)
	}
	
	override exitContext() {
		stack.pop
	}
	
	override toString() {
		stack.toString
	}
	
	@Data private static class StackFrame {
		val long hash
		val int seq
		val Object align

		override toString() {
			'''[«align.toString»@«seq»/«hash»]'''
		}
		override hashCode() {
			hash as int
		}
	}
	
	private static class SimpleCodePoint implements CodePoint {
		val Object[] repr
		var int hash
		new(Deque<StackFrame> stack) {
			if (stack.size == 0) {
				throw new IllegalStateException("Empty stacks are not allowed")
			}
			hash = stack.peek.hashCode
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