%% Cache clear
% Side-Note: This code really needs to be tested
clear all;  % reset workspace (avoid cache issues)
%% Initialize Arduino and encoder object
% Globals, pertinent to getRotaryState function
global edgeCount;   % Edge-count of photoelectric rotary encoder (full rev)
global count;
global time;
global rpm;
global readEncoder;

% Definitions
model = 'Uno';      % Update depending on the board
port = 'COM3';      % Arduino Port
chA = 'D2';         % digital pin2
chB = 'D3';         % digital pin3
ppr = 600;          % Pulses per revolution, uses the 600BM Model
sum = 0;            % Summation buffer for the pulse count
edgeCount = 2400;

% Init arduino object, MATLAB R2018b is recommended over R2018a due to
% third party software compatibility issues. Install the rotaryEncoder
% library from HOME->Add-Ons, see further documentation here:
% https://www.mathworks.com/help/supportpkg/arduinoio/ref/arduinoio.rotaryencoder.html
a = arduino(port,model,'Libraries','rotaryEncoder');

% Init encoder object
rEncoder = rotaryEncoder(a,chA,chB,ppr);
%% Infinite loop, reading data
% Uses X4 decoding (for both A/B channels, or use X2 if A or B 'only')
% The speed measurement interval of 20 ms is used to calculate the 
% rotational speed. A custom interrupt script could get around this limit
% for the rotary encoder to adjust the measurement interval to fit hardware

% Node: readCount experiences integer overflow at 2^32-1

fprintf('Arduino and Encoder object intitialized.\n');
[count,time] = readCount(rEncoder,'reset',true);
readEncoder = true;

while readEncoder
  rpm = readSpeed(rEncoder);       % How to verify correct speed??
  [count,time] = readCount(rEncoder,'reset',false);
  % Debugging info
  % fprintf('S: %6.2f, Rad/S: %6.2f, Deg: %6.2f.\n', time, toRadS(rpm), toDeg(count, edgeCount));
end

%{
Write to file
x = 0:.1:1;
A = [t; rpm(t)]; 

fileID = fopen('dataLog.txt','w');
fprintf(fileID,'%6s %12s\n','t','rpm(t)', 'rev');
fprintf(fileID,'%6.2f %12.8f\n',A);
fclose(fileID);
count,time] = readCount(rEncoder,'reset',true);
%}
