package it.unibo.caterva.lib

import it.unibo.caterva.core.AggregateSupport
import it.unibo.caterva.sensors.DistanceSensor
import org.eclipse.xtend.lib.annotations.Data

@Data class Coord {

    val AggregateSupport context
    val StandardLib lib
    val DistanceSensor ds

    def distanceTo(boolean source) {
        context.stateful(Double.POSITIVE_INFINITY, [
            val distances = context.neighbor(it)
                .map(ds.neighborRange, [$0 + $1])
            val minDist = lib.minHood(distances, Double.POSITIVE_INFINITY)
            lib.mux(source, 0d, minDist)
        ])
    }
}