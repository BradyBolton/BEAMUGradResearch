% Example on using the rotary encoder, if using different model refer to
% initRot.m documentation.
clear all;
model = 'Uno';      % Update depending on the board
port = 'COM3';      % Arduino Port
chA = 'D2';         % digital pin2
chB = 'D3';         % digital pin3
ppr = 600;          % Pulses per revolution, uses the 600BM Model
global edgeCount;   % Edge-count of encoder (based on the optical encoder)
global rEncoder;    % Encoder object

% initRot();  % Initialize encoder before working with encoder
%fprintf('About to try connecting..\n');
%a = arduino('btspp://0018E4400006',model);
%fprintf('I think we connected..\n');
%a = arduino;
edgeCount = 2400;
if exist('a', 'var') == 0 && exist('a', 'var') == 0
   a = arduino('COM3','Uno','Libraries','rotaryEncoder');%,'rotaryEncoder');
   rEncoder = rotaryEncoder(a,chA,chB,ppr);
   %rEncoder = rotaryEncoder(a,chA,chB,ppr);
end
n = 200;
readings = zeros([n, 2]);
count = 1;
while count < n
  [pos,vel] = getRotaryState();    % Get position and velocity
  readings(count, 1) = pos;
  readings(count, 2) = vel;
  fprintf('Pos: %6.2f, Rad/S: %6.2f.\n', pos, vel);
  count = count + 1;
end 
xaxis = 1:n;
% plot(xaxis, readings(:,1).*pi./180); % plot position
% hold;
plot(xaxis, readings(:,2)); % plot velocity