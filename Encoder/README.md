# Setup
---
* It is recommended to use `MATLAB 2018b` since `MATLAB 2018a` has some issues with downloading the proper encoder library (downloading 3rd-party software)
* Install the Encoder library by: `Home` > `Add-Ons` > Search for:
`MATLAB Support Package for Arduino Hardware`
* Then select `Install`
* Make sure MATLAB can recognize the board properly. Connect the Arduino board via USB, and the computer should recognize the board via `COM` port (in my case it is `COM3`). This is important because you'll have to change `port` in `initRot.m` to the right `COM` port (check in Windows Device Manager under Ports(COM & LPT)
* Check the data-sheet for the encoder to wire the A-channel to digital port 2 and the B-channel to digital port 3 (do not use `D0` or `D1`) of the quadrature
* Then connect the black wire to `GND` on the 'power' side and the red wire to the 5V port for the encoder
* Run `Example.m` to test it

See `Example.m` for a demonstration. If using a different encoder you will want to change the configuration in the `initRot.m` file, noting the following specifications:

1. `Edge-count`: number of edges per revolution (for optical encoder)
2. `PPR` (pulses per revolution): for the built-in interrupt function
3. `COM`: the port of the board itself
4. `chA`: Digital port for the A-channel of the quadrature
5. `chB`: Digital port for the B-channel of the quadrature
