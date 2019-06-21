/* Code Developed by : Brady Bolton and Anshul Nayak
 * Date : 11 Jun 2019
 * A Code for controlling Hitec Servo motor 
 */

#include<Servo.h>

Servo hitec;

unsigned long start_time, current_time, period_time; 
float i,per,out,omega,pos_sin,coeff,wave;// omega = angular veocity ; pos_sin = position of motor Range~[-1 1]; out = motor posittion w.r.t centre
static float T, a1, a2, a3, a4, a5, a6, w;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(57600);
  hitec.attach(9,1000,1200);  
  period_time = 1000;        // T = 1000 ms or 1 Sec ( Time period for one cycle) 
  omega = 1*PI/period_time;  // w = 2 (angular velocity)
  start_time = 0;
  
  T = 0.8; 
      a1 = 0.6; 
      a2 = 0.4;
      a3 = 0.05;
      a4 = 0.2;
      a5 = 0.04;
      a6 = 0.03;
      w = 2*PI/T;
  
}

void loop() {
  // put your main code here, to run repeatedly:
  current_time = millis() - start_time;

  out = 1425 + 300 * desiredTheta(((float)current_time)/1000);
  
  hitec.writeMicroseconds(out);
  delay(20);
  Serial.println(out);

  if(millis() >=10000){
    while(true){
      ;
    }
  }
}

float desiredTheta(float t){
  return a1*sin(w*t) + 
    a2*cos(w*t) + 
    a3*sin(2*w*t) + 
    a4*cos(2*w*t) + 
    a5*cos(3*w*t) + 
    a6*sin(3*w*t);  
}
