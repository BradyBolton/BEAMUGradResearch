See Example.m for a demonstration. If using a different encoder you will want to
change the configuration in the initRot.m file, noting the following specs:

1. Edge-count: number of edges per revolution (for optical encoder)
2. PPR (pulses per revolution): for the built-in interrupt function
3. COM: the port of the board itself
4. chA: Digital port for the A-channel of the quadrature
5. chB: Digital port for the B-channel of the quadrature
