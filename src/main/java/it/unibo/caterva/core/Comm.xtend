package it.unibo.caterva.core

import java.util.Map
import com.google.common.collect.Table

interface Comm {
    def void shareState(Map<CodePoint, Object> state)
    def Table<Device, CodePoint, Object> getState()
}