#include <SoftwareSerial.h> // Prefer soft-serial over actual Tx-Rx
#include "HX711.h"
#include "stdlib.h"

#define BLUETOOTH_SPEED 115200    // Baud assumed by MATLAB 
#define LOADCELL_DOUT_PIN 2
#define LOADCELL_SCK_PIN 3
#define MESSAGE_SIZE 100

HX711 scale;

//   Swap RX/TX connections on bluetooth chip
//   Digital Pin 10 --> Bluetooth TX (Orange)
//   Digital Pin 11 --> Bluetooth RX (Green)
SoftwareSerial mySerial(10, 11);  // RX, TX


void setup() {
  mySerial.begin(BLUETOOTH_SPEED);
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  scale.set_scale(11010.f);                    // this value is obtained by calibrating the scale with known weights; see the README for details
  scale.tare(); 
}

void loop() {
  if(mySerial.available()){
    while(mySerial.available()){
      mySerial.read();
    }
    mySerial.print(scale.get_units(1));
    mySerial.print(",");
    mySerial.println((millis())/1000.0);
  }
}
