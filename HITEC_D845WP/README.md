# Hitec D845 Servo-motor Setup

This folder contains code to run any general purpose servo, centering the horn (use `ServoCenter.ino`) which reports the PWM adjustment for the servo. Otherwise, centering the horn and resetting the endpoints of the servo's sweep range can be done using a commercial servo programmer (models such as the HFP-30 field-programmer provided by Hitec would suffice, but programming modules from other vendors like Futaba are also compatible). This repository does not assume that such a programmer is available for use.

* `ArduinoRoutine`: Upload this routine to the Arduino that is running the servo
* `ArduinoTest`: Ignore this. For debugging serial communication
* `ServoCenter`: Upload this routine to the Arduino that is running the servo, and use the serial monitor to center the horn (record your adjustment for later use when you change the parameters of `MATLABTest.m` when you run the Matlab script)
* `HITEC_D845WP`: MATLAB Script controlling the movement of the Hitec water-proof servo using code from this folder
* `MATLABTest.m`: Demonstrates serial connection between MATLAB and Arduino
* `paste.txt`: Ignore this, unported code from a previous implementation for Arduino
* `README.md`: The file you are reading
---
## Setup Instructions
1. When wiring up the motors, even if the servo is designed to operate at a voltage of 5V or below, it is not recommended to directly power the servo via the 5V pin (do NOT use the VIN nor 3.3V pin either). Power fluctuations in servo motors can stress the integrated voltage regulator included on your board (which should only be used conservatively for powering components with more consistent power consumption). Make sure that the grounding wire of the servo is connected to a GND pin on the Arduino. One may find a wiring example [here](https://www.mathworks.com/help/supportpkg/arduinoio/ug/control-servo-motors.html). Note the effect of input voltage on the speed and stall torque of the servo while in use, consult your servo's data sheet for more information.
2. Upload `CenterServo.ino` and open up the serial monitor, in the bottom right-hand corner set the baudrate to 9600 and remove any options for ending a serial command with a newline or carriage return (or else your commands will be registered twice). Type any number into the prompt and press enter to send adjustments to the Arduino. These numerical adjustments  increase or decrease the PWM (Hz). Repeat this process until the horn is centered, record this adjustment. You will find that a range of values will work due to deadband width.
3. Change the `CENTER_ADJUSTMENT` parameter in `MATLABTest.m` to the adjustment found in step 2.
