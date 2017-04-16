package org.protelis2.sensors.impl

import org.protelis2.sensors.PositionSensor

class ZeroPositionSensor implements PositionSensor {
	
	override getCoordinates() {
		#[0d, 0d]
	}
	
}