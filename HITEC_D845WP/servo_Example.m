% initServo('COM8', 9600, 145, 0.101); % HITEC D845WP
clearSerials;   % Run twice if BT issues occur
% Baud rates that work: 9600, 14400
% Untested rates: 19200
% Baud rates that do not work: 38400, 115200
initServo('COM8', 14400, 430, 0.079); % HITEC 5646WP
initLoadCell('HC-05');

i = 0;
time = zeros([100, 1]);
weight = zeros([100,2]);
writeServoDeg(0, 's');      % Servo is straight

servoTime = tic;
stopTime = 10;              % 10 seconds runtime

 while t < stopTime
     t = toc(servoTime);
     angleInDeg = 180*DesiredTheta(i)/pi;
     latencyTime = tic;
     weight(i,:) = writeServoDeg(angleInDeg, 'ls');
     time(i) = toc(latencyTime);
     i = i + 1;
 end
fprintf('Average round-time latency: %fs\n', mean(time));
plot(weight(:,2),weight(:,1));
% closeServo();



function out = DesiredTheta(t)
% parameters
T = 0.8; %Time period for one cycle
a1 = 0.3; 
a2 = 0.3;
a3 = 0.05;
a4 = 0.2;
a5 = 0.04;
a6 = 0.03;
w = 2*pi/T;
out = a1*sin(w*t)+a3*sin(2*w*t)+a2*cos(w*t)+ ...
    a4*cos(2*w*t)+a5*cos(3*w*t)+a6*sin(3*w*t);
end