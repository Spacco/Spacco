package it.unibo.caterva.core.impl

import it.unibo.caterva.core.Comm
import java.util.Map
import it.unibo.caterva.core.CodePoint
import com.google.common.collect.ImmutableTable
import com.google.inject.Singleton

@Singleton class NoCommunication implements Comm {
	override shareState(Map<CodePoint, Object> state) {  }
	override getState() { ImmutableTable.of }
}