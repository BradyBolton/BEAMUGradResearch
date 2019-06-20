%% Parameters (the user changes this)
% Use vendor specification sheet: https://www.servocity.com/d845wp-servo

SERIAL_PORT = 'COM8';
BAUD_RATE   = 9600;

a = single(1.21);           % single pres. 4B
b = single(2.22);
c = single(3.02);
d = single(6.56);
e = single(34.322);
f = single(3.29);

% out = [a,b,c,d,e,f];
out = [f];

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

fwrite(arduinoSerial, out, 'float32');
getResponse(arduinoSerial);
getResponse(arduinoSerial);
%% Clean up serial connections
fclose(arduinoSerial);
delete(arduinoSerial);
clear arduinoSerial;

function getResponse(s)
    arduinoResponse = fscanf(s);
    disp(arduinoResponse);
end