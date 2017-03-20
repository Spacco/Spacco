package it.unibo.caterva.lib

import org.eclipse.xtend.lib.annotations.Data
import it.unibo.caterva.core.Context
import it.unibo.caterva.core.Device
import it.unibo.caterva.core.Comm
import it.unibo.caterva.sensors.DistanceSensor
import java.util.Map
import it.unibo.caterva.core.CodePoint
import java.util.Collections
import com.google.common.collect.ImmutableTable
import it.unibo.caterva.sensors.impl.EuclideanDistanceSensor
import it.unibo.caterva.sensors.PositionSensor

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

    def static void main(String... a) {
        val device = new Device() { }
        val comm = new Comm() {
            override shareState(Map<CodePoint, Object> state) {
                println(state)
            }
            override getState() {
                ImmutableTable.of()
            }
        }
        val ctx = new Context(device, comm)
        val stdlib = new StandardLib
        val possense = new PositionSensor() {
            override getCoordinates() {
                return #[0, 1, 2]
            }
        }
        val sense = new EuclideanDistanceSensor(ctx, possense)
        new Coord(ctx, stdlib, sense).distanceTo(true)
    }

}