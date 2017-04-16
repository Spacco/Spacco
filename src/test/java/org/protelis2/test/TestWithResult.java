package org.protelis2.test;

import org.eclipse.xtext.xbase.lib.Functions.Function0;

public interface TestWithResult<T> extends Function0<T> {
    T getExpectedResult(int cycle);
}
