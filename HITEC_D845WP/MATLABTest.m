%% Parameters (the user changes this)
% Use vendor specification sheet: https://www.servocity.com/d845wp-servo

SERIAL_PORT = 'COM8';
BAUD_RATE   = 9600;
CENTER_ADJUSTMENT = 145;
LOWER_BOUND = 870;          % Standard PWM Range: 870-2320 ?sec
UPPER_BOUND = 2320;
TRAVEL_PER_MS = 0.101;      % Out of box travel per ?sec, single pres. 4B

% CENTER_ADJUSTMENT = uint16(145);
% LOWER_BOUND = uint16(870);          % Standard PWM Range: 870-2320 ?sec
% UPPER_BOUND = uint16(2320);
% TRAVEL_PER_MS = single(0.101);      % Out of box travel per ?sec, single pres. 4B

%% Clean up setup
close;
clc;
% Delete existing serial port (a serial port shouldn't exist, some previous
% script failed to clean up their existing serial ports otherwise )
if(size(instrfind) > 0)
    aSerial = instrfind('Type', 'serial', 'Port', SERIAL_PORT);
    fclose(aSerial);
    delete(aSerial);
    clear aSerial;
end
%% Setup Serial (configured for Arduino)
arduinoSerial = serial(SERIAL_PORT, ...
    'BaudRate', BAUD_RATE, ...
    'StopBits', 1, ...
    'Parity', 'none');
    % Assume little-endian by default, s.DataBits = 8
disp("MATLAB opening connection, will take 2 seconds.");
    fopen(arduinoSerial);
disp("MATLAB opens serial connection.");
pause(1);

getResponse(arduinoSerial); % Initial Arduino response

% Send information about the servo to Arduino
init = [CENTER_ADJUSTMENT, LOWER_BOUND, UPPER_BOUND, TRAVEL_PER_MS];
fprintf(arduinoSerial, "%4d, %4d, %4d, %01.3f", init);
%fwrite(arduinoSerial, TRAVEL_PER_MS, 'single');
getResponse(arduinoSerial);

%% Clean up serial connections
fclose(arduinoSerial);
delete(arduinoSerial);
clear arduinoSerial;

function getResponse(s)
    arduinoResponse = fscanf(s);
    disp(arduinoResponse);
end