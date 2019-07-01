% Author: Anshul Nayak and Brady Bolton
% Date: 19, June 2019
% Description: The code runs a Hitec D845 (servo code runs digital servo motors
% in general. The parameter section must be tweaked for specific application).

%% Clear and Init
clearSerials;
clear all
clc
close all
%% Parameters: Change this depending on the setup
COM_PORT =      'COM8';
MODEL =         'Mega2560';
SERVO_PORT =    'D9';
ENCODER_NAME =  'Encoder';  % BT module name for Arduino w/ encoder
PPR =           600;        % Pulses per revolution
LOAD_NAME  =    'HC-05';    % BT module name for Arduino w/ load-cell

% Servo PWM : Range for HS-5646 servo (553 - 2520 microseconds) or 146.25
% degrees end to end.
minPulse = 553 * 10^-6;    % Factory default minimum PWM (sec)
maxPulse = 2520 * 10^-6;   % Factory default maximuim PWM (sec)

Theta_min = -73*pi/180;    % Range of the servo is 146.45 degrees: [-73, 73]
Theta_max =  73*pi/180;
Theta_compare   = zeros(1e4,3);

Encoder_Data    = zeros(1e4,3);
LoadCell_Data   = zeros(1e4,2);

%Create objects:
servoArduino = arduino(COM_PORT, MODEL, 'Libraries', 'Servo');
pause(0.5); % This is necessary for initial arduino reset
servo = servo(servoArduino, SERVO_PORT, 'MinPulseDuration', minPulse, ...
    'MaxPulseDuration', maxPulse);
encoder = initBluetooth(ENCODER_NAME);
loadcell = initBluetooth(LOAD_NAME);

%% Sine wave input to the arduino

currentTime = 0;    % Current time =  0 (at start)
stopTime    = 10;   % Stop Time (stop after a 10 second duration) 
startTime   = tic;  % Timer starts
count       = 0;    % Loop counter during time window (start time to stop time)

encoderReading = zeros(3);
loadcellReading = zeros(2);

while currentTime <= stopTime

    % Counter of the loop:
    count = count + 1;

    currentTime = toc(startTime);
    Theta = DesiredTheta(currentTime);


    servoCommand = (Theta - Theta_min) / (Theta_max - Theta_min);
    Theta_compare(count, 1) = currentTime;
    Theta_compare(count, 2) = servoCommand;

    % Write the desired position to servo:
    writePosition (servo, servoCommand);

    % Read the exact position as a feedback from servo:
    Theta_compare(count, 3) = readPosition(servo);

    % Read position and velocity of encoder
    encoderReading = readEncoder(encoder);      % [pos, vel, time]
    Encoder_Data(count, 1) = encoderReading(3);  % Time
    Encoder_Data(count, 2) = encoderReading(1);  % Position

    %Read load-cell
    loadcellReading = readLoadCell(loadcell);     % [pos, time]
    LoadCell_Data(count,1) = loadcellReading(2);  % Time
    LoadCell_Data(count,2) = loadcellReading(1);  % Position

end

% Plot input waveform after the trial
Theta_compare = Theta_compare(1:count,:);
plot(Theta_compare(:,1),Theta_compare(:, 2))

% Plot encoder readings (position-time graph)
plot(Encoder_Data(:, 1),Encoder_Data(:, 2))

% Plot load-cell readings (force-time graph)
plot(LoadCell_Data(:, 1),LoadCell_Data(:, 2))

%Reset to mid position:
pause(0.2);
writePosition(s, 0.5);
