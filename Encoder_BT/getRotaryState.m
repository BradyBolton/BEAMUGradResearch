function [pos,vel] = getRotaryState()
%GETROTARYSTATE Returns the current position (deg) and velocity (Rad/s)
%   pos (degrees) is with respect to initial orientation
    global btModule;

    rawReading = fscanf(btModule, '%f');    % Use fscanf() over fread(),
    pos = getPosition(rawReading);          % overhead is not an issue.
    vel = toRadS(rawReading, pos);
end
%% Utility functions

function pos = getPosition(rawReading)
    % Position is abs(-----XXX.XXXXXX) in rawReading
    if rawReading < 0
        pos = -1 * mod(rawReading, -1000);
    else
        pos = mod(rawReading, 1000);
    end
end

function rs = toRadS(rawReading, pos)
%TORADS Returns the current velocity (Rad/s)
    global ppr;
    global readingsPerSecond;
    
    % Retrieve the number of interrupt occurances within the user specified 
    % reading window to approximate velocity. Count is a multiple of 10^3 
    % in rawReading.
    
    if rawReading < 0
        encoderCountPeriod = (rawReading + pos)/1000;
    else
        encoderCountPeriod = (rawReading - pos)/1000;
    end
    
    currentDuration = 1/readingsPerSecond;    
    rs = encoderCountPeriod / (4 * ppr) * 2 * pi / currentDuration;
end