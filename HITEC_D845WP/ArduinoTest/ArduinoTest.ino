/* Author(s): Brady Bolton and Anshul Nayak
 * Date: 18, June 2019
 * Debugging for Serial communication between Arduino and MATLAB.
 */

#include <String.h>
#include <stdlib.h>

String output;
long tick;

// ===========================[ Parameters ]================================
int baudRate = 9600;        // Baudrate must be the same as MATLAB's parameter
boolean timeOutFlag = false;

long timeout = 5000;
long centerAdjustment;      // Found with ServoCenter.ino, update in MATLAB
//==========================================================================

void setup() {
  
  // Set up serial
  Serial.begin(baudRate);
  while (!Serial) {
    ; // Wait for Serial to establish
  }
  tick = millis();
  Serial.println("Serial established.");
  while(!Serial.available()){
    // Await centering adjustment
    if((millis() - tick) > timeout){
      timeOutFlag = true;
      break;
    }
  }
  if(timeOutFlag){
    Serial.println("Arduino timed out, expected input from MATLAB not recieved");
  } else {
    output = Serial.readString();
    const char *out = output.c_str();
    centerAdjustment = atoi(out);
    strcat(out, " was recieved. Arduino centered.");
    Serial.println(out); 
  }
}

void loop() {
  // Servo control here
}
