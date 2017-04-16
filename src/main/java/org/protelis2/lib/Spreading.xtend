package org.protelis2.lib

import org.protelis2.core.AggregateSupport
import org.protelis2.sensors.DistanceSensor
import org.eclipse.xtend.lib.annotations.Data
import static org.protelis2.lib.Standard.*

@Data class Spreading {

    val AggregateSupport context
    val DistanceSensor ds

    def distanceTo(boolean source) {
        context.stateful(Double.POSITIVE_INFINITY, [
            val distances = context.neighbor(it)
                .map(ds.neighborRange, [$0 + $1])
            val minDist = minHood(distances, Double.POSITIVE_INFINITY)
            mux(source, 0d, minDist)
        ])
    }
}