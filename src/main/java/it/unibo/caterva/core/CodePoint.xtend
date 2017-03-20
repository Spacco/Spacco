package it.unibo.caterva.core

import java.util.List;

final class CodePoint {
    int hash
    val Object o
    val List<StackTraceElement> stack

    new(Object o) {
        stack = Thread.currentThread.stackTrace
        this.o = o
    }

    override hashCode() {
        if (hash == 0) {
            hash = (0 ..< Math.min(stack.size, 3))
                .map[stack.get(it).hashCode]
                .fold(o.hashCode, [$0.bitwiseXor($1)])
        }
        hash
    }

    override equals(Object o) {
        if (o instanceof CodePoint) {
            return this.o == o.o && stack == o.stack
        }
        false
    }
    
	override toString() {
		'''«o.toString»->«stack.join("->",[it.fileName.replaceAll('\\.java', ''':«it.lineNumber»''')])»'''
	}

}