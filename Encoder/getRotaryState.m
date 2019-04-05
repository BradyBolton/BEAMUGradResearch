function [pos,vel] = getRotaryState()
%GETROTARYSTATE Returns the current position (deg) and velocity (Rad/s)
%   pos (degrees) is with respect to initial orientation
global rEncoder;
global edgeCount;
rpm = readSpeed(rEncoder);       % How to verify correct speed??
[count,time] = readCount(rEncoder);%,'reset',false);
%fprintf("%d\n", count);
pos = toDeg(count, edgeCount);
vel = toRadS(rpm);
end

%% Utility functions

function rs = toRadS(rpm)
%TORADS Returns the current velocity (Rad/s)
    rs = rpm*2*pi/60;
end

function [deg] = toDeg(count, edgeCount)
%TODEG Returns the current position (deg) relative to initial orientation
    deg = mod(count,edgeCount)/edgeCount*360;
end
