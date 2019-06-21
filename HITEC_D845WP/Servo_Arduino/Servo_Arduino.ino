// Note: https://www.microchip.com/wwwproducts/en/ATmega16u2

#include <Servo.h>

// To parse incoming bytes as float or long, reuse a Serial input buffer
union ByteBuffer {
  byte asBytes[4];
  float asFloat;
  long asLong;
};

// ===========================[ Parameters ]================================
int baudRate = 9600;     // Baudrate must be the same as MATLAB's parameter
int servoPort = 9;
int MESSAGE_MAX_SIZE = 100;
long basePWM = 1500;     // Usually libraries assume 1500 microsecond PWM = 90 deg
                         // for a 180 degree properly aligned range of motion
long adjustedBase, centerAdjustment;  // Adjustments to align the servo horn

long timeout = 5000;     // Time-out if we get nothing from MATLAB in 5 seconds (when
                         // information should be recieved serially)
long tick;               // Used for checking timeouts

float microsToDeg;       // Microsecond - Degrees of actuation ratio (vendor specs)

Servo hitec;
//==========================================================================

void setup() {
  hitec.attach(servoPort);
  Serial.begin(baudRate);   // Set up serial
  while (!Serial) {
    ;                       // Wait for Serial to establish
  }
  Serial.println("Arduino: Connection established.");
  char numIncomingBytes = 0;
  char numExpectedBytes = 8;
  delay(500);               // MATLAB is slow, needs time to send initial info
  if(hasTimedOut()){
    Serial.println("Arduino timed out, expected input from MATLAB not recieved");
  } else if ((numIncomingBytes = Serial.available()) == numExpectedBytes) {
    char numBuffersToParse = numIncomingBytes / sizeof(long);
    union ByteBuffer centering_;
    union ByteBuffer microsToDeg_;
    for(int b = 0; b < sizeof(long); b++){
      centering_.asBytes[b] = Serial.read();
    }
    for(int b = 0; b < sizeof(long); b++){
      microsToDeg_.asBytes[b] = Serial.read();
    }
    centerAdjustment = centering_.asLong;
    microsToDeg = microsToDeg_.asFloat;

    adjustedBase = centerAdjustment + basePWM;
    hitec.writeMicroseconds(adjustedBase);

    printFloat(microsToDeg, 1000);
    char *out = calloc(MESSAGE_MAX_SIZE, sizeof(char));
    sprintf(out, ", %ld\n", centerAdjustment);
    Serial.print(out);
    delay(500);   // Allow enough time for the servo to center
    
  } else {
    Serial.println("Not enough bytes recieved.");
  }
}

void loop() {
  while(Serial.available() == sizeof(float)){
    processServoPosition();
  }
}

boolean hasTimedOut(){
  tick = millis();
  while(!Serial.available()){ 
    if((millis() - tick) > timeout){
      return true;
    }
  }
  return false;
}

void processServoPosition(){
  union ByteBuffer posBuffer;
  for(int b = 0; b < sizeof(float); b++){
    posBuffer.asBytes[b] = Serial.read();
  }
  float posInDegrees = posBuffer.asFloat;
  long posInPWM = adjustedBase + microsToDeg * posInDegrees;  // Might need a revision
  hitec.writeMicroseconds(posInPWM);
  delay(20);
}

void printFloat(float val, unsigned int precision){
// prints val with number of decimal places determine by precision
// NOTE: precision is 1 followed by the number of zeros for the desired number of decimial places
// example: printDouble( 3.1415, 100); // prints 3.14 (two decimal places)

   Serial.print("Recieved: "); // print the decimal point
   Serial.print (int(val));  //prints the int part
   Serial.print("."); // print the decimal point
   unsigned int frac;
   if(val >= 0)
       frac = (val - int(val)) * precision;
   else
       frac = (int(val)- val ) * precision;
   Serial.print(frac,DEC) ;
} 
