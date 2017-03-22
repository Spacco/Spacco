package it.unibo.caterva.test

import it.unibo.caterva.test.TestWithResult
import org.eclipse.xtend.lib.annotations.Data
import it.unibo.caterva.core.AggregateSupport
import com.google.inject.Inject

@Data abstract class AbstractTest<T> implements TestWithResult<T> {
	val AggregateSupport fc
	@Inject
	new(AggregateSupport fc) {
		this.fc = fc
	}
}