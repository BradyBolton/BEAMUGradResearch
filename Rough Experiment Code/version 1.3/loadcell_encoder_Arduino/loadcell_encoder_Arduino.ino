#define BLUETOOTH_SPEED 115200    // Baud assumed by MATLAB 
#define SERIAL_MONITOR_SPEED 115200

// Encoder parameters
#define A_PIN 2                   // Green, Digital Pin #
#define B_PIN 3                   // White, Digital Pin #

// HX711/Loadcell parameters
#define LOADCELL_DOUT_PIN 4
#define LOADCELL_SCK_PIN 5
#define LOADCELL_SCALE 470000.00f // Obtain this calibration w/ known weights, see README

// Libraries
#include "HX711.h"
#include <SoftwareSerial.h> // Prefer soft-serial over actual Tx-Rx
                            // to prevent possible conflicts

HX711 scale;
volatile long long enc_count = 0;     // Global for ISR
volatile long start;

void setup() {
  Serial.begin(BLUETOOTH_SPEED);
  // Serial.begin(SERIAL_MONITOR_SPEED);     // Debugging on Serial Monitor via USB
  enc_count = 0;                          // Reset static information

  pinMode(A_PIN, INPUT_PULLUP);
  pinMode(B_PIN, INPUT_PULLUP);

  // UNO handles only two interrupts, Mega or Due can handle more, check specs
  attachInterrupt(digitalPinToInterrupt(A_PIN), encoder_isr, CHANGE);
  attachInterrupt(digitalPinToInterrupt(B_PIN), encoder_isr, CHANGE);

  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  scale.set_scale(LOADCELL_SCALE);              
  scale.tare();                                // reset the scale to 0

  while(!Serial.available()){
    ;
  }
  char command;
  if((command = Serial.read()) == 'r'){
    start = millis();
  }
}

/* Up to 2^64-1/2400 = 3.8430717e+15 number of rotations before over-flow, use long long
 * to locally track enc_count to avoid rounding errors. Opposed to using millis() between 
 * interrupts, count # of interruptions during a uniform reading period (outer-loop)
 */
void loop() {
  if(Serial.available()){
    Serial.print((millis()-start)/1000.0);
    switch(Serial.read()){
      case 'e':
        Serial.print(",");
        Serial.println((long)(enc_count)); // 0 - INF
        break;
      case 'l':
        Serial.print(",");
        Serial.println(scale.get_units(1), 1);       // (ADC - Tare_Weight)/SCALE   
        break;
      case 'b':
        Serial.print(",");
        Serial.print((long)(enc_count)); // 0 - INF
        Serial.print(",");
        Serial.println(scale.get_units(1), 1);       // (ADC - Tare_Weight)/SCALE   
        break;
    }
  }
}

void encoder_isr() {
  // Note: Assign A-Dig1, B-Dig2 ports only, since bit-shifts and lookup table are port specific!
  static int8_t lookup_table[] = {0,-1,1,0,1,0,0,-1,-1,0,0,1,0,1,-1,0};
  static uint8_t enc_val = 0;       // Initiate once, updated each ISR call
  
  enc_val = enc_val << 2;           // Shift previous 2-bit encoder state to create the next lookup
  enc_val = enc_val | ((PIND & 0b1100) >> 2);  // Bit-mask PIND (port HI/LOW rep. as binary) to update enc_val

  enc_count += lookup_table[enc_val & 0b1111]; 
}
