function [result] = initRot()
%INITROT Initializes the rotary encoder
%   Only do this once, clear cache afterwards. Change values according to
%   the equipment specification

%% Cache clear
% Side-Note: This is the old code, just for crude testing
clear all;  % reset workspace (avoid cache issues)
%% Initialize Arduino and encoder object
% Globals, pertinent to getRotaryState function
global edgeCount;   % Edge-count of encoder (based on the optical encoder)
global rEncoder;    % Encoder object

% Definitions
model = 'Uno';      % Update depending on the board
port = 'COM3';      % Arduino Port
chA = 'D2';         % digital pin2
chB = 'D3';         % digital pin3
ppr = 600;          % Pulses per revolution, uses the 600BM Model
edgeCount = 2400;
try
    %a = arduino('HC-05',model);
    a = arduino(port,model,'rotaryEncoder');
    %a = arduino('COM3','Uno','Libraries','rotaryEncoder');
    fprintf("got here\n");
    rEncoder = rotaryEncoder(a,chA,chB,ppr);
    result = 1;  % Indicate successful initialization
catch
    warning('Problem using function.  Assigning a value of 0.');
    result = 0;  % Indicate unsucccessful initialization
end


