package it.unibo.caterva.sensors.impl

import it.unibo.caterva.core.Context
import it.unibo.caterva.sensors.DistanceSensor
import it.unibo.caterva.sensors.PositionSensor
import org.eclipse.xtend.lib.annotations.Data
import com.google.inject.Inject

@Data class EuclideanDistanceSensor implements DistanceSensor {

    @Inject val Context ctx
    val PositionSensor<?> psense
    
    override neighborRange() {
        val local = psense.coordinates
        ctx.neighbor(local)
            .map[neighPos | Math.sqrt(
                (0 ..< local.size)
                .map[(local.get(it).doubleValue - neighPos.get(it).doubleValue)]
                .map[it * it]
                .fold(0d, [$0 + $1]))
            ]
    }


}