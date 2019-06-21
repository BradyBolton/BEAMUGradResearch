%% Parameters (the user changes this)
% Use a vendor specification sheet: https://www.servocity.com/d845wp-servo

SERIAL_PORT = 'COM9';
BAUD_RATE   = 9600;

% Wave-form parameters (single precision, 4B size)
T  = single(0.8);       %Time period for one cycle
a1 = single(0.6);
a2 = single(0.4);
a3 = single(0);
a4 = single(0);
a5 = single(0);
a6 = single(0);         % Note: w is calculated seperately

out = [T, a1, a2, a3, a4, a5, a6];

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
disp("MATLAB: opening connection, will take 2 seconds.");
fopen(arduinoSerial);
disp("MATLAB: opened serial connection.");
pause(1);

getResponse(arduinoSerial, 1); % Initial Arduino response

fwrite(arduinoSerial, out, 'float32');
% getResponse(arduinoSerial,3); % Verify bytes recieved
%% Clean up serial connections
fclose(arduinoSerial);
delete(arduinoSerial);
clear arduinoSerial;

function getResponse(serial, numOfResponses)
    i = 0;
    while i < numOfResponses
        arduinoResponse = fscanf(serial);
        disp(arduinoResponse);
        i = i + 1;
    end
end
