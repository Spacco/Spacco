package org.protelis2.sensors

import org.protelis2.core.Field

interface DistanceSensor {

    def Field<Double> neighborRange()

}