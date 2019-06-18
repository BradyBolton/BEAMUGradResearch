/**
 * A modification of HX711_full_example, with blue-tooth communication set up
**/
#include <SoftwareSerial.h> // Prefer soft-serial over actual Tx-Rx
                            // to prevent possible conflicts
#include "HX711.h"

#define BLUETOOTH_SPEED 115200    // Baud assumed by MATLAB 

// HX711 circuit wiring & Setup
const int LOADCELL_DOUT_PIN = 2;
const int LOADCELL_SCK_PIN = 3;
HX711 scale;

//   Swap RX/TX connections on bluetooth chip
//   Digital Pin 10 --> Bluetooth TX (Orange)
//   Digital Pin 11 --> Bluetooth RX (Green)
SoftwareSerial mySerial(10, 11);  // RX, TX

void setup() {
  mySerial.begin(BLUETOOTH_SPEED);
  Serial.begin(BLUETOOTH_SPEED);
/* Initialize library with data output pin, clock input pin and gain factor.
*  Channel selection is made by passing the appropriate gain:
*  - With a gain factor of 64 or 128, channel A is selected
*  - With a gain factor of 32, channel B is selected
*  By omitting the gain factor parameter, the library
*  default "128" (Channel A) is used here.
*/
   
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  scale.set_scale(11010.f);                    // this value is obtained by calibrating the scale with known weights; see the README for details
  scale.tare();                               // reset the scale to 0
}

void loop() {
    Serial.println(scale.get_units(10), 1);     // 10 average readings from (ADC - Tare_Weight)/SCALE, prints float to BT HC05
    mySerial.println(scale.get_units(10), 1);     // 10 average readings from (ADC - Tare_Weight)/SCALE, prints float to BT HC05
//  scale.power_down();                           // put the ADC in sleep mode
//  delay(5000);
//  scale.power_up();
}
