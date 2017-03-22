package it.unibo.caterva.test

import it.unibo.caterva.core.impl.AggregateProgramFactory
import java.util.Collections
import org.junit.Assert
import org.junit.Test
import org.reflections.Reflections
import java.lang.reflect.Modifier

class BaseLangTest {
	static val Iterable<Class<? extends TestWithResult>> TESTS =
		new Reflections().getSubTypesOf(typeof(TestWithResult)).filter[!Modifier.isAbstract(it.modifiers)]
//		#{typeof(RepErasure)}

	@Test
	def void test() {
		TESTS.forEach[test |
			val toTest = AggregateProgramFactory.createProgram(test, Collections.emptyMap)
			Assert.assertNotNull(toTest)
			Assert.assertNotNull(toTest.program)
			(1..100).forEach[
				val res = toTest.apply
				println(res)
				Assert.assertEquals('''Failure for «test» at cycle «it»''',toTest.program.getExpectedResult(it), res)
			]
		]
	}
}