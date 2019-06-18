# Encoder and Load-cell Bluetooth Arduino Setup

This folder contains code to use 1 encoder and 2 load-cells, sending data via a single bluetooth HC-05 module to MATLAB at a specified rate of samples per second (default at 10). Note the following folders:

* `BT_configuration`: An Arduino routine to configure the BT module serially via USB (attach the BT module to Arduino, then via the USB A to B cable connect the Arduino to the laptop). Open up the serial command line and communicate to the module from there, using this [reference](https://www.itead.cc/wiki/Serial_Port_Bluetooth_Module_(Master/Slave)_:_HC-05) to do what you'd like
* `encoder_loadcell`: Upload this routine to the Arduino to read the encoder and load-cells
* `encoderBTArduinoOld`: Ignore this for now
* `firmware`: This is useful for setups with only one load-cell per Arduino board. This is library is currently unused, instead we will use `HX711-multi` since there are two load-cells
* `HX711`: Bodge's wonderful library that is unused for reasons stated above. The code is left here for reference
* `HX711-multi`: Minimal re-implementation of Bogde's library for multiple load-cells. This library is used by `encoder_loadcell`

## Setup Instructions:
1.  Note the specific model of your HC-05 BT module, certain models require a different process to get into AT-programming mode for configuration. For more information, read documentation in `BT_configuration`. This step may be optional.
2.  Also note that you have the right encoder. This expects a quadrature encoder with 600 pulses per revolution. Make sure the resolution is sufficient for the expected velocities (Resolution is 360 / 4 * PPR -th of a degree). Avoid detents for continuous applications (incremental encoders). Update parameters in `encoder_loadcell.ino` and your call of `initEncoder()`. The resolution of load cells are trickier to discuss due to many external factors. All you need to know is that resolution depends on the equipment measuring the load cell and how well you handle noise. In our case the DAQ1500 has 24 bit ADC meaning that the load cell's resolution is 24 bits given that the DAQ1500's excitation voltage is 5V so the expected resolution is 5 / 2^24 . This is impossible to achieve due to noise (creep, temperature change, pressure differentials). For further information, see [this](https://www.hardysolutions.com/tenants/hardy/documents/5FactorsA.pdf).

3.  Arduino boards can only handle a certain number of encoders. This is half the maximum number of pins assignable to an interrupt function. E.g. an Arduino UNO only has pins D2 and D3 usable for interrupts, and so only has up to 1 encoder to read from (though you can assign only 1 interrupt to just the A-channel of the encoder to accommodate 2 encoders, but the resolution will be halved). Due to this restriction, the code assumes:

 * The A-channel is attached to the D2 pin
 * The B-channel is attached to the D3 pin

 Otherwise you will receive random garbage data. Larger boards can handle multiple encoders.

4.  Assemble the Arduino/BT, connect the board via USB, then upload `encoder_loadcell.ino` (editing correct parameters)
5.  Run `encoderBT.m` in MATLAB. It will take a minute to pair with the module. Read more about the [Bluetooth MATLAB interface here](https://www.mathworks.com/help/instrument/bluetooth-communication.html)

---

## Trouble-shooting:
A few things could go wrong with the module, some suggestions listed below are common issues:

* You forgot to include a voltage divider in wiring the module to Arduino. The on-board logic may be fried from too much power (e.g. 5V, rather than 3.3V)
*  The encoder and BT module should be in a closed power loop with the Arduino
*  The encoder may not be getting enough power
*  Ensure that the Arduino communicates at the right baud-rate for MATLAB, try 115200 baud
*  Check the BT module's configuration, default baud rate may be too low since some vendors leave their products at 9600 baud, while others at 38400 baud
*  The pins you're using might not be suited for interrupts, or you're using the wrong pins, encoderBTArduino.ino is hard-coded for D2, D3 for A/B signal respectively (since those are what most models have assigned this to)

---

## Demo:

See `encoderBT.m` for a demo. If using a different encoder and/or load-cell you will want to
change the configuration in `encoder_loadcell.ino` and the parameters of `initEncoder.m`, note the following:

1. PPR (pulses per revolution): for the interrupt function, *since the interrupt will be triggered 4 x pulses per revolution, since 2 channels A/B are staggered w/ their own interrupt, from LOW/HIGH states (2 x 2 x PPR)*
2. chA: Digital port for the A-channel of the quadrature, usually D2
3. chB: Digital port for the B-channel of the quadrature, usually D3
