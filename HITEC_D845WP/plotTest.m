clear all;
clc;

global start
global period

minPulse =      870 * 10 ^ -6;    % Factory default minimum PWM (sec)
maxPulse =      2320 * 10 ^ -6;   % Factory default maximuim PWM (sec)
minRange =      16.775;
maxRange =      163.225;         % Based on max travel: 146.45 (deg)
totalRange =    146.45;          % Range of motion (deg)
travelPerMS =   0.101;        % Travel per microsecond (deg)
speed_coef = 1;
resolution = 100; % 1000 readings per second
n = 5 * resolution;
figure
xLowerBound = 0;
xUpperBound = 5;
yLowerBound = -0.5;
yUpperBound = 1.5;
xlim([xLowerBound, xUpperBound]);
ylim([yLowerBound, yUpperBound]);
hold on
x = 0:5/n:5;
y = zeros(1, n); 
start = cputime;
period = 5;
timespan = 1/resolution;
for i = 1:n
    tick = cputime;
    y(i) = getScaledPos();
    plot(x(1:i),y(1:i))
    tock = cputime - tick;
    pause(timespan - tock)
end


function scaled_pos = getScaledPos()
    global start;
    global period;
    elapsed = cputime - start;
    angle = (elapsed/period)*2*pi; % time to rad [-1,1]
    pos = sin(angle);
    scaled_pos = 0.5 + pos/2;
end