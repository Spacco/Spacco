package it.unibo.caterva.core

import java.io.Serializable

interface CodePoint extends Serializable {}

interface CodePointGenerator {
	def void refresh()
	def CodePoint enterContext(Object alignOn)
	def void exitContext()
}