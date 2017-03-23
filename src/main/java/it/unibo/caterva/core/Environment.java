package it.unibo.caterva.core;

public interface Environment<K, V> extends Sensor, Actuator {
    
    V read(K name);

    void write(K name, V value);

}
