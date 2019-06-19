/* Author(s): Brady Bolton and Anshul Nayak
 * Date: 18, June 2019
 * Debugging for Serial communication between Arduino and MATLAB.
 */

#include <String.h> // strcat, c_str
#include <stdlib.h> // atof
#include <stdio.h>  // sscanf
#include<Servo.h>

Servo hitec;
int pos;
long adjustedBase, centerAdjustment, tick, lowerPWM, upperPWM;
String initInput;
float travelPerMS;

// ===========================[ Parameters ]================================
int baudRate = 9600;     // Baudrate must be the same as MATLAB's parameter
int servoPort = 9;
long base = 1500;        // Typically, libraries assume 1500 microsecond PWM to be 90 deg

long timeout = 5000;     // Time-out if we get nothing from MATLAB in 5 seconds
boolean timeOutFlag = false;
int MESSAGE_SIZE = 100;
//==========================================================================

void setup() {

  lowerPWM = upperPWM = -1;

  hitec.attach(servoPort);
  
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
    initInput = Serial.readString();
    
    char *initInputCStr = calloc(MESSAGE_SIZE, sizeof(char));
    char *rangeInfo = calloc(16 + 1, sizeof(char));
    char *resInfo = calloc(5 + 1, sizeof(char));
    char *outMessage = calloc(MESSAGE_SIZE, sizeof(char));
    
    strcpy(initInputCStr, initInput.c_str());
    strncpy(rangeInfo, initInputCStr, 16);
    strncpy(resInfo, initInputCStr + 18, 5);
    
    // Parse data
    sscanf(rangeInfo, "%ld,%ld,%ld", &centerAdjustment, &lowerPWM, &upperPWM);
    travelPerMS = atof(resInfo);  
    // Arduino printf doesn't support float for performance reasons, I surmise sscanf behaves similarly
    
    snprintf(outMessage, MESSAGE_SIZE, "Center: %3ld, PWM Range: %4ld-%4ld. Centering Arduino.\n", 
      centerAdjustment, 
      lowerPWM, 
      upperPWM);
    Serial.print(outMessage); 
    adjustedBase = base + centerAdjustment;
    hitec.writeMicroseconds(adjustedBase);
    delay(1000);
    free(outMessage);
  }
}

void loop() {
//  while (Serial.available() > 0){
//    pos = Serial.parseInt();
//    hitec.writeMicroseconds(base + adjustment);
//    delay(15);
//    break;
//  }
}

long posToPWM(int pos){
  
}
