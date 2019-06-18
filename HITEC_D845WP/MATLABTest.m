%% Parameters (the user changes this)
SERIAL_PORT = 'COM8';
BAUD_RATE   = 9600;
CENTER_ADJUSTMENT = 145;
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
fopen(arduinoSerial);
disp("Serial connection to Arduino complete.");
pause(1);

getResponse(arduinoSerial); % Initial Arduino response

fprintf(arduinoSerial, "%d", CENTER_ADJUSTMENT);
getResponse(arduinoSerial);
fclose(arduinoSerial);
delete(arduinoSerial);
clear arduinoSerial;

function getResponse(s)
    arduinoResponse = fscanf(s);
    disp(arduinoResponse);
end