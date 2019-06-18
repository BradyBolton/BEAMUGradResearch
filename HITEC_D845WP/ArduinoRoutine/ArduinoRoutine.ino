/* Author(s): Brady Bolton and Anshul Nayak
 * Date: 13, June 2019
 * Control the servo-motors through a MATLAB interface via serial communication.
 * MATLAB will send speed and position information via byte-array once serial is
 * finished setting up. Make sure to adjust the servoPort and centerAdjustment
 * parameters before running. See README for more about centering the servo. The
 * byte array is defined:
 *    Offset: 0                        4                   7
 *            +------------------------+-------------------+
 *            | position, deg (4B int) | time, ms (4B int) |
 *            +------------------------+-------------------+
 */

#include<Servo.h>

void parseByteArray(byte arr[8], int *r);

Servo hitec;

// Parameters:
int baudRate = 115200;      // This is necessary to communicate with MATLAB
int servoPort = 9;
static int sizeOfInt = 4;          // Assume an integer is 4 bytes

long centerAdjustment;      // Found with ServoCenter.ino
byte commandBuffer[8];       // [byte arr pos | byte arr time]
int result[2];               // [int pos][int time]

void setup() {

    for(int i = 0; i < sizeof(commandBuffer); i++){
      commandBuffer[i] = 0;
    }
    for(int i = 0; i < sizeof(result); i++){
      result[i] = 0;
    }

    hitec.attach(servoPort);

    // Set up serial
    Serial.begin(baudRate);
    while (!Serial) {
      ; // Wait for Serial to establish
    }
}

void loop() {
    while (Serial.available()) {
        Serial.readBytes(commandBuffer, sizeOfInt * 2);
        parseByteArray(commandBuffer, result);
    }
}   

void parseByteArray(byte arr[8], int *r){
    result[0] = result[1] = 0;
    for(int i = 0; i < sizeOfInt; i++){
        result[0] |= arr[i] << (i*8);
        result[1] |= arr[i + sizeOfInt] << (i*8);
    }
}
