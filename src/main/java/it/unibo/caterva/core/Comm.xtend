package it.unibo.caterva.core

import java.util.Map

interface Comm {
    def void shareState(Map<CodePoint, Object> state)
    def Map<Device, Map<CodePoint, Object>> getState(Map<CodePoint, Object> state)
}