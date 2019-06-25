# Results:

1. `minLatencyTest`, full-round trip sending a single float as char-array yields an average latency of 0.0464 - 0.0475 seconds, offering at the most around 21 readings per second (probably less, though 10 readings per second is enough for our purposes)

2. `minLatencyTestBytes`: Not tested yet, trouble-shooting

3. `minLatencyTest`, full-round trip sending two floats as a char-array yields an average latency of 0.0379 seconds offering at most around 25 readings per second
