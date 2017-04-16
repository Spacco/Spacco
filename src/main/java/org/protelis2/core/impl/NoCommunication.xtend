package org.protelis2.core.impl

import org.protelis2.core.Comm
import java.util.Map
import org.protelis2.core.CodePoint
import com.google.common.collect.ImmutableTable
import com.google.inject.Singleton

@Singleton class NoCommunication implements Comm {
	override shareState(Map<CodePoint, Object> state) {  }
	override getState() { ImmutableTable.of }
}