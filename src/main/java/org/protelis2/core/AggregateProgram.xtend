package org.protelis2.core

import org.eclipse.xtext.xbase.lib.Functions.Function0

interface AggregateProgram<P, T> extends Function0<T> {
	
	def P getProgram()

}