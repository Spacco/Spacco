package org.protelis2.test

import org.junit.Assert
import org.junit.Test
import org.reflections.Reflections
import java.lang.reflect.Modifier
import org.protelis2.VM

class BaseLangTest {
	static val Iterable<Class<? extends TestWithResult>> TESTS =
		new Reflections(typeof(BaseLangTest).package)
			.getSubTypesOf(typeof(TestWithResult))
			.reject[Modifier.isAbstract(it.modifiers)]
	@Test
	def void test() {
		TESTS.forEach[test |
			val toTest = VM.Builder.withDefault.build.makeProgram(test)
			Assert.assertNotNull(toTest)
			Assert.assertNotNull(toTest.program)
			(1..100).forEach[
				val res = toTest.apply
//				println(res)
				Assert.assertEquals('''Failure for «test» at cycle «it»''',toTest.program.getExpectedResult(it), res)
			]
		]
	}
}