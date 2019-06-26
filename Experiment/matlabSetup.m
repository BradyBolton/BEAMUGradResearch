% Author: Anshul Nayak and Brady Bolton
% Date: 19, June 2019
% Description: The code runs a Hitec D845 (servo code runs digital servo motors
% in general. The parameter section must be tweaked for specific application).
% Conclusions about the Hitec come from a vendor specification sheet here:
% https://www.servocity.com/d845wp-servo
%% Clear and Init
clear all
clc
close all
%% Parameters: Change this depending on the setup
COM_PORT =      'COM8';
MODEL =         'Mega2560'; 
SERVO_PORT =    'D9';
ENCODER_NAME =  'Encoder';  % BT module name for Arduino w/ encoder
PPR =           600;        % Pulses per revolution
SPS =           10;         % Samples per second
LOAD_NAME  =    'HC-05';

%Servo PWM : Range for HS-5646 servo (553 - 2520) microseconds or 146.25
%degrees end to end
minPulse = 553 * 10^-6;    % Factory default minimum PWM (sec)
maxPulse = 2520 * 10^-6;   % Factory default maximuim PWM (sec)

Theta_min = -73*pi/180; % Range of the servo is 146.45deg:[-73 73]
Theta_max =  73*pi/180;
Theta2PD  = 1/(Theta_max-Theta_min);
Theta_compare = zeros(1e4,3);

Encoder_Data = zeros(1e4,2);
LoadCell_Data = zeros(1e4,1);

%Create objects:
a = arduino(COM_PORT, MODEL, 'Libraries', 'Servo');
pause(0.5); %This is necessary for initial arduino reset
s = servo(a, SERVO_PORT, 'MinPulseDuration', minPulse, 'MaxPulseDuration', maxPulse);
initEncoder(ENCODER_NAME, PPR, SPS);
initLoadCell(LOAD_NAME);

%% Sine wave input to the arduino

t = 0;       % Current time =  0 (at start)
stop = 10;   % Stop Time
timer = tic; % Timer starts
count = 0;   %Number of times the loop is travesed from start time to stop 

while t <= stop 
    
    % Counter of the loop:
    count = count+1; 
    
    t = toc(timer);
    Theta = DesiredTheta(t);
    
    
    out = Theta2PD*(Theta-Theta_min); %Range in MATLAB library is  [0 1]
    Theta_compare(count,1) = t;
    Theta_compare(count,2) = out;
    
    %Write the desired position to servo:
    writePosition (s,out);
%     pause(0.01);
    
    %Read the exact position as a feedback from servo:
    pos = readPosition(s);
    Theta_compare(count,3) = pos;
    
    %Read position and velocity of encoder
    encoderReading = getRotaryState(); %[pos, vel]
    Encoder_Data(count,1) = encoderReading(1);
    Encoder_Data(count,2) = encoderReading(2);
    
    %Read load-cell
    LoadCell_Data(count,1) = readLoadCell();
 
end

% Plot input waveform after the trial
Theta_compare = Theta_compare(1:count,:);
plot(Theta_compare(:,1),Theta_compare(:,2))

%Reset to mid position:
pause(0.2);
writePosition(s,0.45);

