# Spacco

Spatial Abstract Common Context

# Idea

Building a common abstraction of execution context to be used by any aggregate computing language, and to be implemented by any aggregate-computing oriented back-end.
It should make extremely easy to port any compliant aggregate program to any concrete backend.

# Bootstrap

* Two main parts: VM and Device API

# Entities

* Sensor
* Actuator
* Device
* Neighborhood
* NeighborhoodState
* Context
* Export?

# Relations

* Context contains device
* Context provides NeighborhoodState
* Neighborhoodstate maps devices to Exports
* The Neighborhood is the device set in the neighborhoodstate
* Context provides access to actuators
* Context provides access to sensor
