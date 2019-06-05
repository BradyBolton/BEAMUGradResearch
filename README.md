# Setup
* `Encoder`: interfaces MATLAB with a quadrature/Arduino setup via USB. See folder for more documentation.
* `Encoder_BT`: interfaces MATLAB with a quadrature/Arduino setup via HC05 Bluetooth module. This implementation does not use MATLAB's existing HC05 library due to [existing configuration issues](https://www.mathworks.com/matlabcentral/answers/407123-solved-initializing-bluetooth-hc-05-to-arduino-connection-r2018a). See folder for more documentation
* `Load_Cell_BT`: interfaces MATLAB with a load-cell/Arduino setup via HC05 Bluetooth module using a HX711 amplifier to amplify small voltage differentials to detectable levels for the MCU. See folder for more documentation. 
