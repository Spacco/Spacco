package it.unibo.caterva.core.impl

import java.util.List;
import it.unibo.caterva.core.CodePoint
import it.unibo.caterva.core.CodePointGenerator

final class JavaStack implements CodePointGenerator {
	override refresh() { }
	override enterContext(Object alignOn) {
		new JavaStackCodePoint(alignOn)
	}
	override exitContext() {}
}

final class JavaStackCodePoint implements CodePoint {
    int hash
    val Object o
    val List<StackTraceElement> stack

    new(Object o) {
        stack = new Throwable().stackTrace
        this.o = o
    }

    override hashCode() {
        if (hash == 0) {
            hash = stack.size.bitwiseXor((o ?: 0).hashCode)
        }
        hash
    }

    override equals(Object o) {
        if (o instanceof JavaStackCodePoint) {
            return this === o || (this.o == o.o && stack == o.stack)
        }
        false
    }
    
	override toString() {
		'''«o.toString»->«stack.join("->",[it.fileName.replaceAll('\\.java', ''':«it.lineNumber»''')])»'''
	}

}