package it.unibo.caterva.core.impl

import java.util.Objects

final class QuickThrowable extends Throwable {
	static val MIN_DEPTH = 0
	static val UNINITIALIZED_DEPTH = -1
	static val GET_STACKTRACE_DEPTH = {
		val method = typeof(Throwable).getDeclaredMethod("getStackTraceDepth")
		method.accessible = true
		method
	}
	static val GET_STACKTRACE_ELEMENT = {
		val method = typeof(Throwable).getDeclaredMethod("getStackTraceElement", typeof(int))
		method.accessible = true
		method
	}
	var int hash
	var depth = UNINITIALIZED_DEPTH
	val StackTraceElement[] stack
	val Object o
	new(Object o) {
		stack = newArrayOfSize(stackTraceDepth - MIN_DEPTH)
		this.o = Objects.requireNonNull(o)
	}
//	override fillInStackTrace() {
//		this
//	}
	private def stackTraceDepth() {
		if (depth == UNINITIALIZED_DEPTH) {
			depth = GET_STACKTRACE_DEPTH.invoke(this) as Integer - MIN_DEPTH
		}
		depth
	}
	private def stackTraceElement(int i) {
		if (i >= depth) {
			throw new IllegalArgumentException('''«i» ouf of stack size(«depth»)''')
		}
		stack.get(i) ?: stack.set(i, GET_STACKTRACE_ELEMENT.invoke(this, i + MIN_DEPTH) as StackTraceElement)
	}
	override toString() {
		'''«o.toString»->«
			(0..<depth)
				.map[stackTraceElement]
				.join("->", [it.fileName.replaceAll('\\.java', ''':«it.lineNumber»''')])
		»'''
	}
	
	override equals(Object obj) {
		if (obj instanceof QuickThrowable) {
			this === this || (
				depth == obj.depth
				&& o == obj.o
				&& (0 ..< depth).forall[obj.stackTraceElement(it).equals(stackTraceElement(it))]
			)
		} else {
			false
		}
	}
	
	override hashCode() {
		if (hash == 0) {
			hash = depth.bitwiseXor(o.hashCode)
		}
		hash
	}
	
}