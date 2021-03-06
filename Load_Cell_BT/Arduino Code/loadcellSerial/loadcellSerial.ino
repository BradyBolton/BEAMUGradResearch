  /**
 *
 * HX711 library for Arduino - example file
 * https://github.com/bogde/HX711
 *
 * MIT License
 * (c) 2018 Bogdan Necula
 *
**/
#include "HX711.h"

// HX711 circuit wiring
const int LOADCELL_DOUT_PIN = 4;
const int LOADCELL_SCK_PIN = 5;

HX711 scale;
float scaleFactor;

void setup() {
  Serial.begin(38400);
  Serial.println("HX711 Demo");

  Serial.println("Initializing the scale");

  // Initialize library with data output pin, clock input pin and gain factor.
  // Channel selection is made by passing the appropriate gain:
  // - With a gain factor of 64 or 128, channel A is selected
  // - With a gain factor of 32, channel B is selected
  // By omitting the gain factor parameter, the library
  // default "128" (Channel A) is used here.
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);

  Serial.println("Before setting up the scale:");
  Serial.print("read: \t\t");
  Serial.println(scale.read());           // print a raw reading from the ADC

  Serial.print("read average: \t\t");
  Serial.println(scale.read_average(20)); // print the average of 20 readings from the ADC

  Serial.print("get value: \t\t");
  Serial.println(scale.get_value(5));     // print the average of 5 readings from the ADC minus the tare weight (not set yet)

  Serial.print("get units: \t\t");
  Serial.println(scale.get_units(5), 1);  // print the average of 5 readings from the ADC minus tare weight (not set) divided
                                          // by the SCALE parameter (not set yet)

  scaleFactor = 470000.0f;
  scale.set_scale(scaleFactor);   // this value is obtained by calibrating the scale with known weights; see the README for details
  scale.tare();                   // reset the scale to 0

  Serial.println("Readings:");
}

void loop() {
  Serial.print("Average of 10 readings:\t");
  Serial.println(scale.get_units(10), 3);

  while (Serial.available() > 0){
    float adjustment = Serial.parseFloat();
    scaleFactor += adjustment;
    Serial.print("Received: ");
    Serial.print(adjustment);
    Serial.print("\tNew Scale: ");
    Serial.println(scaleFactor);
    scale.set_scale(scaleFactor);
    scale.tare();
    delay(30);
    break;
  }
}
