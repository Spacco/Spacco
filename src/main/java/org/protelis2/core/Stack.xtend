package org.protelis2.core

interface Stack {
	def void refresh()
	def CodePoint enterContext(Object alignOn)
	def void exitContext()
}

