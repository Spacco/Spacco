import java.util.List;

class CodePoint {
    int hash
    Object o
    final List<StackTraceElement> stack

    new(Object o) {
        stack = Thread.currentThread.stackTrace
        this.o = o
    }

    override hashCode() {
        if (hash == 0) {
            hash = stack.get(0).hashCode
        }
        hash
    }

    override equals(Object o) {
        if (o instanceof CodePoint) {
            return stack == o.stack && this.o == o.o
        }
        false
    }

}