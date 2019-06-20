/* Author(s): Brady Bolton and Anshul Nayak
 * Date: 18, June 2019
 * Debugging for Serial communication between Arduino and MATLAB.
 */

#include <String.h> // strcat, c_str
#include <stdlib.h> // atof
#include <stdio.h>  // sscanf
#include <Servo.h>

union {
  byte asBytes[4];
  float asFloat;
} Float;

Servo hitec;
int pos;
long adjustedBase, currentMS, centerAdjustment, tick, lowerPWM, upperPWM;
String initInput;
float travelPerMS;

static float T, a1, a2, a3, a4, a5, a6, w;

//% parameters
//float T, a1, a2, a3, a4, a5, a6, w;
//T = 0.8; %Time period for one cycle
//a1 = 0.3; 
//a2 = 0.3;
//a3 = 0.05;
//a4 = 0.2;
//a5 = 0.04;
//a6 = 0.03;
//w = 2*pi/T;

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
    char numIncomingBytes = 0;
    delay(1000);
    while((numIncomingBytes = Serial.available()) > 0){
      parseSerial(Serial.available());
      break;
    }
    char *outputMessage = calloc(MESSAGE_SIZE, sizeof(char));
    sprintf(outputMessage, "Recieved: %2d bytes of data.", numIncomingBytes); 
    Serial.println(outputMessage);
  }
}

void loop() {
}

void parseSerial(int numBytesToRead){
  switch(numBytesToRead){
    case 4:
      float* recieved = parseFloatArray(numBytesToRead);
      if(recieved == NULL){
        Serial.println("Unsuccessful reading, aborting.");
        return;
      }
      break;
    case 0:
      char com = Serial.read();
      if(com == 'a'){
        activateServo();
        break;
      } else if (com == 'd'){
        deactivateServo();
        break;
      }
      return NULL;
    default:
      break;
  }
}

float* parseFloatArray(int numBytesToRead){
  if(numBytesToRead % sizeof(float) != 0){
    // Return null pointer, indicate unsuccessful parsing
    return NULL;
  } else {
    long floatBuffer = 0; 
    byte *byteBuffer = calloc(numBytesToRead, sizeof(char));
    for(int B = 0; B < 4; B++){
      Float.asBytes[B] = Serial.read();
    }
    printFloat(Float.asFloat, 4);
    if(Float.asFloat == 3.29){
      Serial.println("yes");
    }
    float* out = &Float.asFloat;
    return out;
  }
}

void activateServo(){
  Serial.println("Servo activated");
}

void deactivateServo(){
  Serial.println("Servo deactivated");
}

float desiredTheta(float t){
  return a1*sin(w*t) + 
    a2*cos(w*t) + 
    a3*sin(2*w*t) + 
    a4*cos(2*w*t) + 
    a5*cos(3*w*t) + 
    a6*sin(3*w*t);  
}


//  % parameters
//T = 0.8; %Time period for one cycle
//a1 = 0.3; 
//a2 = 0.3;
//a3 = 0.05;
//a4 = 0.2;
//a5 = 0.04;
//a6 = 0.03;
//w = 2*pi/T;

void printFloat( float val, unsigned int precision){
// prints val with number of decimal places determine by precision
// NOTE: precision is 1 followed by the number of zeros for the desired number of decimial places
// example: printDouble( 3.1415, 100); // prints 3.14 (two decimal places)

   Serial.print (int(val));  //prints the int part
   Serial.print("."); // print the decimal point
   unsigned int frac;
   if(val >= 0)
       frac = (val - int(val)) * precision;
   else
       frac = (int(val)- val ) * precision;
   Serial.println(frac,DEC) ;
} 
