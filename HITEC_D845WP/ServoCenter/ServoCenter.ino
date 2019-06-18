/* Author(s): Brady Bolton and Anshul Nayak
 * Date : 13, June 2019
 * Center the servo motor (adjusting the PWM, in microseconds). To use this,
 * change the parameters beginning on line 17 to reflect your setup and open the
 * serial monitor to interact with the servo and find the adjustment.
 */

#include<Servo.h>

Servo hitec;
int baudRate, servoPort;
long base, adjustment, difference;

// For the Hitec the adjustment is 145 microseconds

void setup() {

  // Parameters:
  baudRate = 9600;
  servoPort = 9;
  base = 1500;  // Typically, libraries assume 1500 microsecond PWM to be 90 deg
  difference = adjustment = 0;

  hitec.attach(servoPort);

  // Set up serial
  Serial.begin(baudRate);
  while (!Serial) {
    ; // Wait for Serial to establish
  }

  Serial.println("Serial connection established...");
  Serial.println("To center the motor, adjust the PWM until the servo horn is 90 degrees.");
  Serial.println("Type in integer increments/decrements until centered (Hz)\n\n");
}

void loop() {
  while (Serial.available() > 0){
    difference = Serial.parseInt();
    adjustment += difference;
    Serial.print("Received: ");
    Serial.print(difference);
    Serial.print("\tAdjustment: ");
    Serial.println(adjustment);
    hitec.writeMicroseconds(base + adjustment);
    delay(1000);
    break;
  }
}
