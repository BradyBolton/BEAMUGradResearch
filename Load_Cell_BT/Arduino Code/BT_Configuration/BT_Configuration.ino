/*
 * Read through and run this configuration file if your BT script does not play nicely with MATLAB. Note
 * that MATLAB expects to configure your HC-05 to 115200 baud. Ideally this is done in MATLAB via the CL:
 * 
 * > arduinosetup
 * 
 * But unfortunately as of now MATLAB doesn't send the correct serial commands to the board to properly
 * configure the HC-05 on their end. You will never be able to declare an Arduino object to utilize the
 * existing libraries direcly in MATLAB, for example:
 * 
 * > a = arduino('btspp://0018E4400006', 'Uno');
 * > rEncoder = rotaryEncoder(a, 'D2', 'D3', '600');
 * 
 * If it were that simple, then MATLAB probably fixed this issue and you probably wouldn't need to use
 * this code anyways. See this post explaining the issue: 
 * https://www.mathworks.com/matlabcentral/answers/407123-solved-initializing-bluetooth-hc-05-to-arduino-connection-r2018a
 * 
 * Note: Different models like the ZS-040 require different procedures to get into AT-programming mode,
 * see this: http://www.martyncurrey.com/arduino-with-hc-05-bluetooth-module-at-mode/
*/

//  The possible baudrates are (AT commands to modify baud-rate, see BT_Configuration.ino):
//    #define NEW_BAUD "AT+UART=1200,0,0\r\n" //-------1200
//    #define NEW_BAUD "AT+UART=2400,0,0\r\n" //-------2400
//    #define NEW_BAUD "AT+UART=4800,0,0\r\n" //-------4800
//    #define NEW_BAUD "AT+UART=9600,0,0\r\n" //-------9600 - Default for HC-06, possibly for HC-05 too
//    #define NEW_BAUD "AT+UART=19200,0,0\r\n" //------19200
//    #define NEW_BAUD "AT+UART=38400,0,0\r\n" //------38400 - Some HC-05 vendors set this rate as default
//    #define NEW_BAUD "AT+UART=57600,0,0\r\n" //------57600 - Johnny-five speed
      #define NEW_BAUD "AT+UART=115200,0,0\r\n" //-----115200 - MATLAB rate
//    #define NEW_BAUD "AT+UART=230400,0,0\r\n" //-----230400
//    #define NEW_BAUD "AT+UART=460800,0,0\r\n" //-----460800
//    #define NEW_BAUD "AT+UART=921600,0,0\r\n" //-----921600
//    #define NEW_BAUD "AT+UART=1382400,0,0\r\n" //----1382400


#define NEW_NAME "HC-05"  // If this is changed, update the MATLAB script

// If you haven't configured your device before use this
#define BLUETOOTH_SPEED 38400   // This is the default baudrate that HC-05 uses, you'll have to
                                // experiment since some vendors use 9600 baud  

// If you are modifying your existing configuration, try this:
// #define BLUETOOTH_SPEED 57600
// Or try this:
// #define BLUETOOTH_SPEED 9600

// Best practice to prefer soft-serial over actual TX/RX.
#include <SoftwareSerial.h>

// Swap RX/TX connections on bluetooth chip.
//   Pin 10 --> Bluetooth TX (blue)
//   Pin 11 --> Bluetooth RX (green)
SoftwareSerial mySerial(10, 11); // RX, TX

void setup() {
  //pinMode(9, OUTPUT);  // this pin will pull the HC-05 pin 34 (key pin) HIGH to switch module to AT mode
  //digitalWrite(9, HIGH);  // For certain models only
  Serial.begin(38400);
  //while (!Serial) {
  //  ; // Wait for serial port to connect. Needed for Leonardo only
  //}
  Serial.println("Starting config");
  mySerial.begin(BLUETOOTH_SPEED);
  delay(1000);

  // Should respond with OK.
  mySerial.print("AT\r\n");       // Notice both 'newline' and 'carriage return' are required. If using
  waitForResponse();              // serial monitor, ensure baud reflects 'Serial' and ends with Both CR+NL.

  // Should respond with its version.
  mySerial.print("AT+VERSION\r\n");
  waitForResponse();

  // Set pin to 1234 (default PW for any HC-05).
  mySerial.print("AT+PSWD=\"1234\"\r\n"); // This is very important! MATLAB gets this part wrong and
  waitForResponse();                      // forgets the " marks, so the built-in configuration will
                                          // fail and never green-light the 'arduinosetup' directly
                                          // from an HC-05 module (as of 4/5/2019).

  // Set the name to some new name (see top).
  String rnc = String("AT+NAME=") + String(NEW_NAME) + String("\r\n"); 
  mySerial.print(rnc);
  waitForResponse();

//  String settings = String("AT+UART?") + String("\r\n"); 
//  mySerial.print(settings);
//  waitForResponse();

  // Set baudrate to some new baud-rate.
  mySerial.print("AT+UART=115200,0,0\r\n");
  waitForResponse();
 
  Serial.println("Done!");
  /* If all you see on the Serial monitor is "Starting config" and "Done!" the baud-rate
    for either the Serial and/or mySerial are not right. Make sure mySerial reflects the
    settings of your module. */
}

void waitForResponse() {
    delay(1000);
    while (mySerial.available()) {
      Serial.write(mySerial.read());
    }
    Serial.write("\n");
}

void loop() {
  while (mySerial.available()) {
      Serial.write(mySerial.read());
    }
  }
