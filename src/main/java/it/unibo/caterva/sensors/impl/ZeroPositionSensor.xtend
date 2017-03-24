package it.unibo.caterva.sensors.impl

import it.unibo.caterva.sensors.PositionSensor

class ZeroPositionSensor implements PositionSensor {
	
	override getCoordinates() {
		#[0d, 0d]
	}
	
}