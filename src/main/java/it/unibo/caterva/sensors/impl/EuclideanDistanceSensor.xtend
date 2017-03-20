package it.unibo.caterva.sensors.impl

import it.unibo.caterva.sensors.DistanceSensor
import org.eclipse.xtend.lib.annotations.Data
import it.unibo.caterva.sensors.PositionSensor
import it.unibo.caterva.core.Context
import java.util.List

@Data class EuclideanDistanceSensor implements DistanceSensor {

    val Context ctx
    val PositionSensor psense

    override neighborRange() {
        val List<Number> local = psense.coordinates
        ctx.neighbor(local)
            .map[neighPos | Math.sqrt(
                (0 ..< local.size)
                .map[local.get(it).doubleValue - neighPos.get(it).doubleValue]
                .map[it ** 2]
                .fold(0d, [$0 + $1]))
            ]
    }


}