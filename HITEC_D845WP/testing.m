% initServo('COM8', 9600, 145, 0.101); % HITEC D845WP
clearSerials;   % Run twice if BT issues occur
initServo('COM8', 9600, 410, 0.079); % HITEC 5646WP
initLoadCell('HC-05');
i = 100;
while i > 0
    tic;
    reading = writeServoDeg(30, 'ls');  
    disp(reading);
    i = i - 1;
    toc;
end
% closeServo();