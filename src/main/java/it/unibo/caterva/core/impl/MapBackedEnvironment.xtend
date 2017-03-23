package it.unibo.caterva.core.impl

import it.unibo.caterva.core.Environment
import java.util.Map
import java.util.LinkedHashMap

class MapBackedEnvironment<K, V> implements Environment<K, V> {
	
	val Map<K,V> core = new LinkedHashMap
	
	override read(K name) { core.get(name) }
	
	override write(K name, V value) { core.put(name, value) }
	
	protected def Map<K, V> getCore() {	core }
	
}