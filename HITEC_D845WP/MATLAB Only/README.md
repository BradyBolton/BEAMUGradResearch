# MATLAB-Only Servo Setup

* `DesiredTheta.m`: Calculated the desired angle based on the current time and the fourier definition of the input waveform. The intention is to optimize its parameters.
* `servo.m`: Main script to drive the servo, uses MATLAB's servo library and `DesiredTheta.m`
