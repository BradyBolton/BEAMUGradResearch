# Setup Instructions

1.  Note the specific model of your HC-05 BT module, certain models require a different process to get into AT-programming mode for configuration. For more information, read documentation in the `.ino` file (and run it on the Arduino once the BT module is wired up) in the `BT_configuration` folder. This step will probably be necessary since vendors set the default baud-rate too low to correctly interface with MATLAB out of the box.
2.  Also check your encoder specifications. The code is written for a quadrature encoder built for 600 pulses per revolution. Make sure the resolution is sufficient for expected velocities (Resolution is 360 / (4 \* PPR) -th of a degree). Avoid detents for continuous applications (incremental encoders). Update parameters in `encoderBTArduino.ino` and your call of `initEncoder()` in your code.
3.  Arduino boards can only handle a certain number of encoders. This is half the maximum number of pins assignable to an interrupt function. E.g. an Arduino UNO only has pins `D2` and `D3` usable for interrupts, and so only has up to 1 encoder to read from (though you can assign only 1 interrupt to just the A-channel of the encoder to accommodate 2 encoders, but the resolution will be halved). Due to this restriction, the code assumes:
 * The A-channel is attached to the `D2` pin
 * The B-channel is attached to the `D3` pin

 Otherwise you will receive random garbage data.
4.  Assemble the Arduino/BT, connect the board via USB, then upload:
    > `encoderBTArduino.ino` (editing correct parameters)
5.  Run `encoderBT.m` in MATLAB. It will take a minute to pair with the module.
    [Read more about the Bluetooth MATLAB interface here.](https://www.mathworks.com/help/instrument/bluetooth-communication.html)
6.  Notice that the position is zeroed everytime the Arduino is powered up

---
# Trouble-shooting:
*   A few things could go wrong with the module, some suggestions listed below are common issues:
 1.  You forgot to include a voltage divider in wiring the module to Arduino. The on-board logic may be fried from too much power (e.g. 5V, rather than 3.3V)
 2.  The encoder and BT module should be in a closed power loop with the Arduino
 3.  The encoder may not be getting enough power
 4.  Ensure that the Arduino communicates at the right baud-rate for MATLAB, try 115200 baud
 5.  Check the BT module's configuration, default baud rate may be too low since some vendors leave their products at 9600 baud, while others at 38400 baud. The configuration is found by interfacing the HC05 via a direct serial connection while it is in AT-mode with the command `AT+UART?` (an example response is `9600,0,0`). To enter AT-mode hold down onto the button near the pins while the Arduino is powered down, and then let go once the board is powered up (the HC05 should be blinking slowly rather than its usual rapid flashing). Then run `BT_configuration.ino`, open up the serial terminal, and type in AT commands (after the included AT commands finish). See [this resource for AT commands](https://www.teachmemicro.com/hc-05-bluetooth-command-list/) and [this resource for AT-mode programming in general for the HC05](http://www.martyncurrey.com/arduino-with-hc-05-bluetooth-module-at-mode/).
 6.  The pins you're using might not be suited for interrupts, or you're using the wrong pins, encoderBTArduino.ino is hard-coded for `D2`, `D3` for A/B signal respectively (since those are what most models have assigned this to)
 7. The HC05 module might be a ZS-040 model, which requires extra steps to get into AT-mode for programming in order to correctly configure the baud-rate. Follow [this advice](http://www.martyncurrey.com/arduino-with-hc-05-bluetooth-module-at-mode/).

---
See `encoderBT.m` for a demo. If using a different encoder you will want to
change the configuration in encoderBTArduino.ino and the parameters of initEncoder, note the following:

1. `PPR` (pulses per revolution): for the interrupt function
   * The interrupt will be triggered 4 \* PPR times per revolution, since 2 channels A/B are staggered w/ their own interrupt, from LOW/HIGH states (2 \* 2 \* PPR)
2. `chA`: Digital port for the A-channel of the quadrature, usually D2
3. `chB`: Digital port for the B-channel of the quadrature, usually D3
