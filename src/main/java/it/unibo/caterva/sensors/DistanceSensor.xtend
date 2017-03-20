package it.unibo.caterva.sensors

import it.unibo.caterva.core.Field

interface DistanceSensor {

    def Field<Double> neighborRange()

}