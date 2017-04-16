package org.protelis2.sensors.impl

import org.protelis2.sensors.DistanceSensor
import org.protelis2.sensors.PositionSensor
import org.eclipse.xtend.lib.annotations.Data
import com.google.inject.Inject
import org.protelis2.core.AggregateSupport

@Data class EuclideanDistanceSensor implements DistanceSensor {

    val AggregateSupport ctx
    val PositionSensor psense
    
    @Inject
    new(AggregateSupport context, PositionSensor pos) {
    	ctx = context
    	psense = pos
    }
    
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