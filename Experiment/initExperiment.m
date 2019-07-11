function initExperiment()
    %% Clear and Init
    clearSerials;
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

end

function clearSerials
    if ~isempty(instrfind)
        fclose(instrfind);
        delete(instrfind);
    end
    clc
    disp('Serial Port Closed')
end