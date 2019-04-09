%{ 
Initiate the BT/encoder by specifying the following attributes: 
    1. The name of the BT module (Check 'Bluetooth & other devices')
    2. The PPR (pulses per revolution, e.g. 600 pulses a revolution)
    3. The number of samples per second (e.g. a sample every 100 ms)
%}
initEncoder('Encoder', 600, 10);
while(true)
    % Get position (deg) and velocity (rad/s) from most recent reading:
    % Note: to set the current orientation to 0-degrees, press the reset
    %       button on the Arduino itself.
    [pos, vel] = getRotaryState();
    fprintf('Pos: %f, Vel: %f\n', pos, vel);     
end
