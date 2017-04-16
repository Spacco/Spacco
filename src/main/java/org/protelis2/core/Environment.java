package org.protelis2.core;

public interface Environment extends Sensor, Actuator {
    
    <V> V read(String name);

    void write(String name, Object value);

}
