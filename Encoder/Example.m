% Example on using the rotary encoder, if using different model refer to
% initRot.m documentation.

initRot();  % Initialize encoder before working with encoder

while true
  [pos, vel] = getRotaryState();    % Get position and velocity
  fprintf('Pos: %6.2f, Rad/S: %6.2f.\n', pos, vel);
end 