function out = DesiredTheta(t)

% Wave-form Parameters:
T = 0.8;    % Time period for one cycle
a1 = 0.3;
a2 = 0.3;
a3 = 0.05;
a4 = 0.2;
a5 = 0.04;
a6 = 0.03;
w = 2*pi/T;

out = a1*sin(w*t) + ...
      a3*sin(2*w*t) + ...
      a2*cos(w*t)   + ...
      a4*cos(2*w*t) + ...
      a5*cos(3*w*t) + ...
      a6*sin(3*w*t);
