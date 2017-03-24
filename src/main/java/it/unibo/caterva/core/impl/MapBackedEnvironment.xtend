package it.unibo.caterva.core.impl

import it.unibo.caterva.core.Environment
import java.util.Map
import java.util.LinkedHashMap

class MapBackedEnvironment implements Environment {
	
	val Map<String, Object> core = new LinkedHashMap
	
	override <V> V read(String name) { core.get(name) as V }
	
	override void write(String name, Object value) { core.put(name, value) }
	
	protected def Map<String, Object> getCore() { core }
	
}