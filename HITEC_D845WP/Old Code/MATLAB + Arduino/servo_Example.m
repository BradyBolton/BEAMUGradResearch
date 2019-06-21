SERIAL_PORT = 'COM9';
BAUD_RATE   = 9600;

initServo(SERIAL_PORT, BAUD_RATE);    
%initServoParameters: T,  a1,  a2,a3,a4,a5,a6 (w is implied)
initServoParameters(0.8, 0.6, 0.4, 0, 0, 0, 0);
closeServo();
