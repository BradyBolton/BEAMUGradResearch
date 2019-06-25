% initServo('COM8', 9600, 145, 0.101); % HITEC D845WP
clearSerials;   % Run twice if BT issues occur
% Baud rates that work: 9600, 14400
% Untested rates: 19200
% Baud rates that do not work: 38400, 115200
initServo('COM8', 14400, 430, 0.079); % HITEC 5646WP
initLoadCell('HC-05');

i = 1;
time = zeros([100, 1]);
weight = zeros([100,2]);
writeServoDeg(30, 's');
 while i < 1000
     tic
     weight(i,:) = writeServoDeg(30, 'ls');
     time(i) = toc;
     i = i + 1;
 end
fprintf('Average round-time latency: %fs\n', mean(time));
plot(weight(:,2),weight(:,1));
% closeServo();