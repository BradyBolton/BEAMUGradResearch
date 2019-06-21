# Hitec D845 Servo-motor Setup

* `Old Code`: Unused servo setups implemented differently, you can ignore this
* `Resources`: Specification sheets and 2D diagrams for the Hitec servo
* `Servo_Arduino`: Upload this routine to the Arduino to control the servo via MATLAB
* `ServoCenter`: An Arduino routine to center the horn and find the necessary PWM adjustment
* `closeServo.m`: Closes serial connection with the Arduino/Servo pair
* `initServo.m`: Initializes serial connection and sends some parameters to Arduino
* `servo_Example.m`: An example driver for the servo
* `writeServoDeg`: Choose to write a position to the servo (degrees) and/or read from the load-cell. See below for more details


This folder contains code to run any general purpose servo, centering the horn (use `ServoCenter.ino`) which reports the PWM adjustment for the servo. Otherwise, centering the horn and resetting the endpoints of the servo's sweep range can be done using a commercial servo programmer (models such as the HFP-30 field-programmer provided by Hitec would suffice, but programming modules from other vendors like Futaba are also compatible). This repository does not assume that such a programmer is available for use. Try reading `Servo_Manual.pdf` in `Resources` before any experimentation (since ignoring details unique to specific products might destroy them).

---
## Setup Instructions
1. When wiring up the motors, even if the servo is designed to operate at a voltage of 5V or below, it is not recommended to directly power the servo via the 5V pin (do NOT use the VIN nor 3.3V pin either). Power fluctuations in servo motors can stress the integrated voltage regulator included on your board (which should only be used conservatively for powering components with more consistent power consumption). Make sure that the grounding wire of the servo is connected to a GND pin on the Arduino. One may find a wiring example [here](https://www.mathworks.com/help/supportpkg/arduinoio/ug/control-servo-motors.html). Note the effect of input voltage on the speed and stall torque of the servo while in use, consult your servo's data sheet for more information.

2. Upload `CenterServo.ino` and open up the serial monitor, in the bottom right-hand corner set the baudrate to 9600 and remove any options for ending a serial command with a newline or carriage return (or else your commands will be registered twice). Type any number into the prompt and press enter to send adjustments to the Arduino. These numerical adjustments  increase or decrease the PWM. Repeat this process until the horn is centered, record this adjustment. You will find that a range of values will work due to deadband width.
3. In your script, to use the servo first initialize things by calling `initServo(serialPort, baudRate, centerAdjustment, microSecondsToDegrees)`:
 * `serialPort`: Which COM port Arduino is connected to, written as `'COM1'` for COM port 1 (on Windows machines, if on MAC write `/dev/tty.KeySerial1`, or Linux as `/dev/ttyS0`)
 * `baudRate`: This should match the `baudRate` parameter in `Servo_Arduino.ino`, keep this at 9600
 * `centerAdjustment`: Write the adjustment found in step 2
 * `microSecondsToDegrees`: For the Hitec D845-WP the travel (degrees) per microsecond is 0.101° based on [this data-sheet](https://www.servocity.com/d845wp-servo), so a 30° servo sweep rougly correlates to 300 µs PWM written to the servo

 E.g., an Arduino connected via COM port 12 on a 9600 baud serial connection for the Hitec D845-WP is initialized with: `initServo('COM12', 9600, 145, 0.101)`

4. Move the servo by calling `writeServoDeg(angle, mode)`, where `angle` is the angle of the flapper with respect to its resting position (parallel to the spine) in degrees. To control the mode write an `l` or `L` to return a reading from the load-cell, and `s` or `S` to write `angle` to the servo. If no `l` is included then no load-cell reading is taken (returns 0) and if no `s` is included then the servo remains in its current position.

 E.g. moving the flapper 30° to the left while reading from the load-cell is called by:

 `myLoadCellReading = writeServoDeg(30, 'ls')` 

 To only move the flapper one could call `writeServoDeg(30, 's')`, and to only read the load-cell one could call:

 `myLoadCellReading = writeServoDeg(30, 'l')` (which ignores the given `angle`)

5. Close the serial connection with the Arduino by calling `closeServo()`
