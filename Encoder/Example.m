% Example on using the rotary encoder, if using different model refer to
% initRot.m documentation.
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
%a = arduino('COM3','Uno');
%rEncoder = rotaryEncoder(a,chA,chB,ppr);

while true
  [pos, vel] = getRotaryState();    % Get position and velocity
  fprintf('Pos: %6.2f, Rad/S: %6.2f.\n', pos, vel);
end 