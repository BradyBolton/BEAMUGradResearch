%% Cache clear
% Side-Note: This is the old code, just for crude testing
clear all;  % reset workspace (avoid cache issues)
%% Initialize Arduino and encoder object
% Globals, pertinent to getRotaryState function

% Definitions
model = 'Uno';      % Update depending on the board
port = 'COM3';      % Arduino Port
chA = 'D2';         % digital pin2
chB = 'D3';         % digital pin3
ppr = 600;          % Pulses per revolution, uses the 600BM Model
edgeCount = 2400;

a = arduino(port,model,'Libraries','rotaryEncoder');
rEncoder = rotaryEncoder(a,chA,chB,ppr);

fprintf('Arduino and Encoder object intitialized.\n');
[count,time] = readCount(rEncoder,'reset',true);
readEncoder = true;

while readEncoder
  rpm = readSpeed(rEncoder);       % How to verify correct speed??
  [count,time] = readCount(rEncoder,'reset',false);
  fprintf('S: %6.2f, Rad/S: %6.2f, Deg: %6.2f.\n', time, toRadS(rpm), toDeg(count, edgeCount));
end

function rs = toRadS(rpm)
    rs = rpm*2*pi/60;
end

function [deg] = toDeg(count, edgeCount)
    deg = mod(count,edgeCount)/edgeCount*360;
end
