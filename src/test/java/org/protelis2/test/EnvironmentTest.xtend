package org.protelis2.test

import org.protelis2.test.TestWithResult
import org.eclipse.xtend.lib.annotations.Data
import org.protelis2.core.Environment
import com.google.inject.Inject

@Data class EnvironmentTest implements TestWithResult<String> {
	val Environment env
	
	@Inject
	new(Environment env) {
		this.env = env
	}
	
	override getExpectedResult(int cycle) {
		"foobar"
	}
	
	override apply() {
		env.write("a", "foo")
		env.write("b", "bar")
		env.read("a") + env.read("b")
	}
	
}