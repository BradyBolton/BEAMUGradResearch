/* Author(s): Brady Bolton and Anshul Nayak
 * Date: 18, June 2019
 * Debugging for Serial communication between Arduino and MATLAB.
 */

#include <String.h> // strcat, c_str
#include <stdlib.h> // atof
#include <stdio.h>  // sscanf
#include <Servo.h>

// To parse incoming bytes as float, read the same memory
union Float {
  byte asBytes[4];
  float asFloat;
};

Servo hitec;
int pos;
long adjustedBase, currentMS, centerAdjustment, tick, lowerPWM, upperPWM;
String initInput;
float travelPerMS;
boolean inMotion = false;

// Parameters for wave-form
static float T, a1, a2, a3, a4, a5, a6, w;

// Anshul Servo code
unsigned long start_time, current_time, period_time; 
float i,per,out,omega,pos_sin,coeff,wave;// omega = angular veocity ; pos_sin = position of motor Range~[-1 1]; out = motor posittion w.r.t centre

// ===========================[ Parameters ]================================
int baudRate = 9600;     // Baudrate must be the same as MATLAB's parameter
int servoPort = 9;
long base = 1500;        // Typically, libraries assume 1500 microsecond PWM to be 90 deg

long timeout = 5000;     // Time-out if we get nothing from MATLAB in 5 seconds
boolean timeOutFlag = false;
int MESSAGE_SIZE = 100;
//==========================================================================

void setup() {

  // Anshul code
  period_time = 1000;        // T = 1000 ms or 1 Sec ( Time period for one cycle) 
  omega = 1*PI/period_time;  // w = 2 (angular velocity)
  start_time = millis();
  // ----------------------------------------------------------------
  
  lowerPWM = upperPWM = -1;

  hitec.attach(servoPort);
  
  // Set up serial
  Serial.begin(baudRate);
  while (!Serial) {
    ; // Wait for Serial to establish
  }
  tick = millis();
  Serial.println("Serial established.");
//  while(!Serial.available()){
//    // Await centering adjustment
//    if((millis() - tick) > timeout){
//      timeOutFlag = true;
//      break;
//    }
//  }
  if(false){
    Serial.println("Arduino timed out, expected input from MATLAB not recieved");
  } else {
    char numIncomingBytes = 0;
    delay(1000);
    float *parameters = calloc(7, sizeof(float));
    while((numIncomingBytes = Serial.available()) > 0){
      parseSerial(Serial.available());
      break;
    }
    char *outputMessage = calloc(MESSAGE_SIZE, sizeof(char));
    sprintf(outputMessage, "Recieved: %2d bytes of data.", numIncomingBytes); 
    Serial.println(outputMessage);

//    Serial.println("Verify parameters");
//    printFloat(T, 100);
//    printFloat(a1, 100);
//    printFloat(a2, 100);
//    printFloat(a3, 100);
//    printFloat(a4, 100);
//    printFloat(a5, 100);
//    printFloat(a6, 100);
//    printFloat(w, 100);
//    Serial.println();
    
  }
}

void loop() {
  current_time = millis() - start_time;

  out = 1425 + 300 * desiredTheta(((float)current_time)/1000);
  
  hitec.writeMicroseconds(out);
  delay(20);

  if(millis() >=10000){
    while(true){
      ;
    }
  }
  
}

void parseSerial(int numBytesToRead){
  switch(numBytesToRead){
    case 28:
      float* parameters = parseFloatArray(numBytesToRead);
      if(parameters == NULL){
        Serial.println("Unsuccessful reading, aborting.");
        return;
      } else {
        //  Register parameters
        T = parameters[0]; // Time period for one cycle
        a1 = parameters[1];
        a2 = parameters[2];
        a3 = parameters[3];
        a4 = parameters[4];
        a5 = parameters[5];
        a6 = parameters[6];
        w = 2*PI/T;
      }
      break;
    case 1:
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
    char numFloatsToParse = numBytesToRead / sizeof(float);
    union Float *buff = calloc(numFloatsToParse, sizeof(Float));
    float *parsedArray = calloc(numFloatsToParse, sizeof(float)); 
    for(int f = 0; f < numFloatsToParse; f++){
      for(int B = 0; B < 4; B++){
        buff[f].asBytes[B] = Serial.read();
      } 
      parsedArray[f] = buff[f].asFloat;
      // printFloat(buff[f].asFloat, 1000);
    }
    free(buff);
    float* out = parsedArray;
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

void printFloat( float val, unsigned int precision){
// prints val with number of decimal places determine by precision
// NOTE: precision is 1 followed by the number of zeros for the desired number of decimial places
// example: printDouble( 3.1415, 100); // prints 3.14 (two decimal places)

   Serial.print(" "); // print the decimal point
   Serial.print (int(val));  //prints the int part
   Serial.print("."); // print the decimal point
   unsigned int frac;
   if(val >= 0)
       frac = (val - int(val)) * precision;
   else
       frac = (int(val)- val ) * precision;
   Serial.print(frac,DEC) ;
   Serial.print(" "); // print the decimal point
} 
