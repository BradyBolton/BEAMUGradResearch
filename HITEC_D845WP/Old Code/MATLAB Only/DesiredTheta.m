function out = DesiredTheta(t)
% parameters
T = 0.8; %Time period for one cycle
a1 = 0.6; 
a2 = 0.4;
a3 = 0.00;
a4 = 0.0;
a5 = 0.00;
a6 = 0.00;
w = 2*pi/T;

out = a1*sin(w*t)+a3*sin(2*w*t)+a2*cos(w*t)+a4*cos(2*w*t)+a5*cos(3*w*t)+a6*sin(3*w*t);