package it.unibo.caterva.sensors

import java.util.List

interface PositionSensor<Number> {

    def List<Number> getCoordinates()

}