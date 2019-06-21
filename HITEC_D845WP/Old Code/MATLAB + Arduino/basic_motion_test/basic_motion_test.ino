/* Code Developed by : Brady Bolton and Anshul Nayak
 * Date : 11 Jun 2019
 * A Code for controlling Hitec Servo motor 
 */

#include<Servo.h>

Servo hitec;

unsigned long start_time, current_time, period_time; 
float i,per,out,omega,pos_sin,coeff,wave;// omega = angular veocity ; pos_sin = position of motor Range~[-1 1]; out = motor posittion w.r.t centre
 

void setup() {
  // put your setup code here, to run once:
  Serial.begin(57600);
  hitec.attach(9,1000,1200);  
  period_time = 1000;        // T = 1000 ms or 1 Sec ( Time period for one cycle) 
  omega = 1*PI/period_time;  // w = 2 (angular velocity)
  start_time = 0;
  

  
}

void loop() {
  // put your main code here, to run repeatedly:

//  current_time = millis() - start_time;
//  
//  per = omega*current_time;
//  pos_sin = 0;
//  
//  for (i=1;i<=4;i++){
//  
//    coeff = 1/(2*i-1);
//    wave = 1*coeff*sin((2*i-1)*per);
//    pos_sin = pos_sin+wave;
//    
// 
//  }
//  
////  pos_sin1 =  sin(per);
////  pos_sin2 =  (0.3333)*sin(3*per);
////  pos_sin3 =  (0.2)*sin(5*per);
////  pos_sin4 =  (0.1428)*sin(7*per);
////  pos_sin5 =  (0.1111)*sin(9*per);
//  
//  out = (1425 + 200*(pos_sin));
//  
//  hitec.writeMicroseconds(out);
//  delay(20);
//  Serial.println(out);
  
 
   current_time = millis() - start_time;

  out = 1425 + 300 * desiredTheta(current_time/1000);
  
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
