# Load-cell Serial/Bluetooth Arduino Setup

This folder contains code to use a load-cell to interface with MATLAB via either a bluetooth HC-05 module or a serial connection. Note the following files:

* `Arduino Code`:
	* ``BT_Configuration`: An Arduino routine to configure the BT module serially via USB (attach the BT module to Arduino, then via the USB A to B cable connect the Arduino to the laptop). Open up the serial command line and communicate to the module from there, using this [reference](https://www.itead.cc/wiki/Serial_Port_Bluetooth_Module_(Master/Slave\)_:_HC-05) to do what you'd like  
	* `HX711_Calibration`: A quick script by SparkFun to callibrate the cell
	* `loadcellBT_Automatic`: Upload this code to read the load-cell via blue-tooth, sending readings automatically to MATLAB
	* `loadcellBT_Manual`: Upload this code to read the load-cell via blue-tooth by requesting an individual reading only when told to do so (if desirable to have a loop in MATLAB)
	* `loadcellSerial`: Upload this code to read the load-cell via USB

Suggested HX711 Libraries:

* `HX711`: Bodge's HX711 library
* `HX711-multi`: Minimal re-implementation of Bogde's library for multiple load-cells. Use this library if you require multiple load-cells (code refactoring is required since `HX711-multi` is an older fork of `HX711`)

![setup](./setup_1.JPG)

## Setup Instructions:
1. Note the specific model of your HC-05 BT module, certain models require a different process to get into AT-programming mode for configuration. For more information, read documentation in `BT_Configuration`. This step may be optional.
2. Calibrate the load-cell using `HX711_Calibration.ino`, following the instructions as they appear in the commented header in the source file.
3. Assemble the Arduino/BT, connect the board via USB, then upload `loadcellSerial.ino` (edit the parameters based on the situation).
5. Run `encoderBT.m` in MATLAB. It will take a minute to pair with the module. Read more about the [Bluetooth MATLAB interface here](https://www.mathworks.com/help/instrument/bluetooth-communication.html)

---

## Trouble-shooting:
A few things could go wrong with the module, some suggestions listed below are common issues:

* Forgetting a voltage divider while wiring the HC05 to the Arduino. The on-board logic can fry from too much power (via RXD, from 5V rather than 3.3V)
*  The load-cell and HC-05 need to connect to GND on the Arduino
*  Load-cells can operate at levels lower than the excitation voltage on the data-sheet and HX711 ADC will still be able to detect voltage changes. However with lower-voltages you might experience more noise.
*  Ensure that the Arduino communicates at the right baud-rate for MATLAB, try 115200 baud
*  Check the BT module's configuration if the default baud rate is too low. Some vendors leave their products at 9600 baud, while others at 38400 baud
*  The resolution of load cells are trickier to discuss due to many external factors. All you need to know is that resolution depends on the equipment measuring the load cell and how well you handle noise. One case you might have a DAQ1500 which is a 24 bit ADC meaning that the load cell's resolution is 24 bits. Given that the DAQ1500's excitation voltage is 5V we expect a resolution of 5 / 2^24 . This is impossible to achieve due to noise (creep, temperature change, pressure differentials). For further information, see [this resource](https://www.hardysolutions.com/tenants/hardy/documents/5FactorsA.pdf).
*  Sometimes the vendor-specified color-coding for the load-cell wires are not correct (this is a problem with Chinese models), so it might be helpfil to measure/record resistances between each wire to figure out which is which (see `resistences_chart.xlsx` for two examples)

---

## Demo:

See `loadcellBT_Example.m` for a demo. If using a different load-cell then change the configuration in `encoder_loadcell.ino` and the parameters of `initLoadCell.m`.