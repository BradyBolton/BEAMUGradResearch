#include <SoftwareSerial.h> // Prefer soft-serial over actual Tx-Rx
#include "HX711-multi.h"    // Required for multiple load-cell readings

// Encoder
#define A_PIN 2                   // Green, Digital Pin #
#define B_PIN 3                   // White, Digital Pin #

// Load-cells
// 5V -> VCC, GND -> GND (same for encoder and both load-cells, verify this isn't an issue)
#define CLK     A0  // Arduino pin 4 -> HX711 CLK_loadcell_1 + CLK_loadcell_2 
#define DOUT_1  A1  // 1 -> DAT_loadcell_1
#define DOUT_2  A2  // 2 -> DAT_loadcell_2

#define CHANNEL_COUNT 2
byte DOUTS[CHANNEL_COUNT] = {DOUT_1, DOUT_2};
long int load_results[CHANNEL_COUNT];

HX711MULTI scales(CHANNEL_COUNT, DOUTS, CLK);

#define READINGS_PER_SECOND 10
#define PPR 600
#define TOTAL_PULSES 2400
#define BLUETOOTH_SPEED 115200    // Baud assumed by MATLAB 

#define calibration_factor -7050.0 //This value is obtained using the SparkFun_HX711_Calibration sketch

//   Swap RX/TX connections on bluetooth chip
//   Digital Pin 10 --> Bluetooth TX (Blue)
//   Digital Pin 11 --> Bluetooth RX (Green)
SoftwareSerial mySerial(10, 11);  // RX, TX
volatile long long enc_count = 0; // Global for ISR
volatile uint32_t enc_count_period = 0;// Track # counts in a reading period, estimate velocity

// HX711 scale(DOUT, CLK);

void setup() {
  mySerial.begin(BLUETOOTH_SPEED);
  Serial.begin(115200);        // Debugging on Serial Monitor via USB
  enc_count = 0;               // Reset static information

  pinMode(A_PIN, INPUT_PULLUP);
  pinMode(B_PIN, INPUT_PULLUP);

  // UNO handles only two interrupts, Mega or Due can handle more, check specs
  attachInterrupt(digitalPinToInterrupt(A_PIN), encoder_isr, CHANGE);
  attachInterrupt(digitalPinToInterrupt(B_PIN), encoder_isr, CHANGE);

  scale.set_scale(calibration_factor); //This value is obtained by using the SparkFun_HX711_Calibration sketch
  scale.tare();  //Assuming there is no weight on the scale at start up, reset the scale to 0
}

/* Up to 2^64-1/2400 = 3.8430717e+15 number of rotations before over-flow, use long long
 * to locally track enc_count to avoid rounding errors. Opposed to using millis() between 
 * interrupts, count # of interruptions during a uniform reading period (outer-loop)
 */
void loop() {
    
  delay(1000/READINGS_PER_SECOND);

  uint32_t result[3];
    
  // [12 bits waste][20 bits used] : [12 bits waste][AA][BBBB] <- AA: 0-99, tick per time-interval; BBBB:0-2400 current tick
  uint32_t result[0] = enc_count < 0 ? TOTAL_PULSES + (enc_count % TOTAL_PULSES) : (enc_count % TOTAL_PULSES);
  result[0] += enc_count_period < 0 ? enc_count_period * -10000 : enc_count_period * 10000;

  mySerial.println(result);       // Package pos/vel info together
  enc_count_period = 0;
}

void encoder_isr() {
  // Note: Assign A-Dig1, B-Dig2 ports only, since bit-shifts and lookup table are port specific!
  static int8_t lookup_table[] = {0,-1,1,0,1,0,0,-1,-1,0,0,1,0,1,-1,0};
  static uint8_t enc_val = 0;       // Initiate once, updated each ISR call
  
  enc_val = enc_val << 2;           // Shift previous 2-bit encoder state to create the next lookup
  enc_val = enc_val | ((PIND & 0b1100) >> 2);  // Bit-mask PIND (port HI/LOW rep. as binary) to update enc_val

  enc_count += lookup_table[enc_val & 0b1111]; 
  enc_count_period += lookup_table[enc_val & 0b1111];
}

/*
  The possible baudrates are (AT commands to modify baud-rate, see BT_Configuration.ino):
    AT+UART=1200,0,0 -------1200
    AT+UART=2400,0,0 -------2400
    AT+UART=4800,0,0 -------4800
    AT+UART=9600,0,0 -------9600 - Default for HC-06, possibly for HC-05 too
    AT+UART=19200,0,0 ------19200
    AT+UART=38400,0,0 ------38400 - Some HC-05 vendors set this rate as default
    AT+UART=57600,0,0 ------57600 - Johnny-five speed
    AT+UART=115200,0,0 -----115200 - MATLAB rate
    AT+UART=230400,0,0 -----230400
    AT+UART=460800,0,0 -----460800
    AT+UART=921600,0,0 -----921600
    AT+UART=1382400,0,0 ----1382400
*/
