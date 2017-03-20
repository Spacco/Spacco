package it.unibo.caterva.lib

import org.eclipse.xtend.lib.annotations.Data
import it.unibo.caterva.core.Context
import it.unibo.caterva.sensors.DistanceSensor

@Data class Coord {

    val Context context
    val StandardLib lib
    val DistanceSensor ds

    def distanceTo(boolean source) {
        context.stateful(Double.POSITIVE_INFINITY, [
            val distances = context.neighbor(it)
                .map(ds.neighborRange, [$0 + $1])
            val minDist = lib.minHood(distances, Double.POSITIVE_INFINITY)
            if (source) 0d else minDist
        ])
    }


}