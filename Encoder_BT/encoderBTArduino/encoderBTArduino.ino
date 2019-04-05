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

#include <SoftwareSerial.h> // Prefer soft-serial over actual Tx-Rx
                            // to prevent possible conflicts

#define BLUETOOTH_SPEED 115200    // Baud assumed by MATLAB 
#define A_PIN 2                   // Green, Digital Pin #
#define B_PIN 3                   // White, Digital Pin #
#define READINGS_PER_SECOND 10

//   Swap RX/TX connections on bluetooth chip
//   Digital Pin 10 --> Bluetooth TX (Blue)
//   Digital Pin 11 --> Bluetooth RX (Green)
SoftwareSerial mySerial(10, 11);  // RX, TX
volatile long long enc_count = 0; // Global for ISR

void setup() {
  mySerial.begin(BLUETOOTH_SPEED);
  Serial.begin(115200);        // Debugging on Serial Monitor via USB

  pinMode(A_PIN, INPUT_PULLUP);
  pinMode(B_PIN, INPUT_PULLUP);

  // UNO handles only two interrupts, Mega or Due can handle more, check specs
  attachInterrupt(digitalPinToInterrupt(A_PIN), encoder_isr, CHANGE);
  attachInterrupt(digitalPinToInterrupt(B_PIN), encoder_isr, CHANGE);
}

// Up to 2^64-1/2400 = 3.8430717e+15 number of rotations before over-flow, use long long
// to locally track enc_count to avoid rounding errors.
void loop() {
    delay(1000/READINGS_PER_SECOND);
    double degree  = ((enc_count % 2400)/2400.0) * 360.0;
    mySerial.println(degree);
}

void encoder_isr() {
    // Note: Assign A-Dig1, B-Dig2 ports only, since bit-shifts and lookup table are port specific!
    static int8_t lookup_table[] = {0,-1,1,0,1,0,0,-1,-1,0,0,1,0,1,-1,0};
    static uint8_t enc_val = 0;       // Initiate once, updated each ISR call
    
    enc_val = enc_val << 2;           // Shift previous 2-bit encoder state to create the next lookup
    enc_val = enc_val | ((PIND & 0b1100) >> 2);  // Bit-mask PIND (port HI/LOW rep. as binary) to update enc_val
 
    enc_count = enc_count + lookup_table[enc_val & 0b1111]; // Bit-mask to read right values, use look-up table
}
