#include <SoftwareSerial.h> // Prefer soft-serial over actual Tx-Rx
#include "HX711-multi.h"    // Required for multiple load-cell readings

// Load-cells
// 5V -> VCC, GND -> GND (same for encoder and both load-cells, verify this isn't an issue)
#define CLK     A0  // Arduino pin 4 -> HX711 CLK_loadcell_1 + CLK_loadcell_2 
#define DOUT_1  A1  // 1 -> DAT_loadcell_1
#define DOUT_2  A2  // 2 -> DAT_loadcell_2

#define CHANNEL_COUNT 1// 2
byte DOUTS[CHANNEL_COUNT] = {DOUT_1}; // , DOUT_2};
long int results[CHANNEL_COUNT];

HX711MULTI scales(CHANNEL_COUNT, DOUTS, CLK);

#define READINGS_PER_SECOND 10
#define BLUETOOTH_SPEED 115200    // Baud assumed by MATLAB 

void setup() {
  Serial.begin(115200);        // Debugging on Serial Monitor via USB
}

void sendRawData() {
  scales.read(results);
  for (int i=0; i<scales.get_count(); ++i) {;
    Serial.print( -results[i]);  
    Serial.print( (i!=scales.get_count()-1)?"\t":"\n");
  }  
  delay(100);
}

void loop() {
  sendRawData();
}
