package it.unibo.caterva.lib

import com.google.common.collect.ImmutableTable
import it.unibo.caterva.core.CodePoint
import it.unibo.caterva.core.Comm
import it.unibo.caterva.core.Context
import it.unibo.caterva.core.Device
import it.unibo.caterva.sensors.DistanceSensor
import it.unibo.caterva.sensors.PositionSensor
import it.unibo.caterva.sensors.impl.EuclideanDistanceSensor
import java.util.Map
import org.eclipse.xtend.lib.annotations.Data

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
        val possense = new PositionSensor<Double>() {
            override getCoordinates() {
                return #[0d, 1d, 2d]
            }
        }
        val sense = new EuclideanDistanceSensor(ctx, possense)
        ctx.cycle[new Coord(ctx, stdlib, sense).distanceTo(true)]
    }

}