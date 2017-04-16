package org.protelis2.core

import java.util.Map
import com.google.common.collect.Table

interface Comm {
    def void shareState(Map<CodePoint, Object> state)
    def Table<DeviceUID, CodePoint, Object> getState()
}