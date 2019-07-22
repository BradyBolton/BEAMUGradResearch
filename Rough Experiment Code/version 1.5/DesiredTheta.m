function out = DesiredTheta(t)
% parameters:

global  Time a1 a2 a3 a4 a5 a6; %Time period for one cycle
Time = 1.6; %Time period for one cycle

%Coefficients for three harmonics (Fourier approximation):
a1 = 0.3; 
a2 = 0.3;
a3 = 0.05;
a4 = 0.2;
a5 = 0.04;
a6 = 0.03;

w = 2*pi/Time;

out = a1*sin(w*t) + ...
      a3*sin(2*w*t) + ...
      a2*cos(w*t) + ...
      a4*cos(2*w*t) + ...
      a5*cos(3*w*t) + ...
      a6*sin(3*w*t);