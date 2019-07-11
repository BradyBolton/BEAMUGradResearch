function out = DesiredVelocity(t)
% parameters:

global Time a1 a2 a3 a4 a5 a6;
% Time = 0.8; %Time period for one cycle
w = 2*pi/Time;

out = a1*w*cos(w*t)+a3*2*w*cos(2*w*t)-a2*w*sin(w*t)-a4*2*w*sin(2*w*t)-a5*3*w*sin(3*w*t)+a6*3*w*cos(3*w*t);