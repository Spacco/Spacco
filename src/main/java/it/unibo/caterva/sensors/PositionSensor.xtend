package it.unibo.caterva.sensors

import java.util.List

interface PositionSensor<N extends Number> {

    def List<N> getCoordinates()

}