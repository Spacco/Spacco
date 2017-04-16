package org.protelis2.test

import org.protelis2.test.TestWithResult
import org.eclipse.xtend.lib.annotations.Data
import org.protelis2.core.AggregateSupport
import com.google.inject.Inject

@Data abstract class AbstractTest<T> implements TestWithResult<T> {
	val AggregateSupport fc
	@Inject
	new(AggregateSupport fc) {
		this.fc = fc
	}
}