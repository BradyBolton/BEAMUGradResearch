% Author: Brady Bolton and Anshul Nayak
% Date: 11, June 2019
% Description: The code runs a Hitec D845 (servo code runs digital servo motors
% in general. The parameter section must be tweaked to be motor-specific).
% Conclusions about the Hitec come from a vendor specification sheet here:
% https://www.servocity.com/d845wp-servo
%% Clear and Init
clear all;
clc;
%% Parameters: Change this depending on the setup
COM_PORT =      'COM8';
MODEL =         'MEGA'; 
SERVO_PORT =    'D9';

% The range of the Hitec (by default): 16.775 - 163.225 degrees
minPulse =      870 * 10 ^ -6;    % Factory default minimum PWM (sec)
maxPulse =      2320 * 10 ^ -6;   % Factory default maximuim PWM (sec)
minRange =      16.775;
maxRange =      163.225;         % Based on max travel: 146.45 (deg)
totalRange =    146.45;          % Range of motion (deg)
%totalRange =    180;
travelPerMS =   0.101;        % Travel per microsecond (deg)
speed_coef = 1;

a = arduino(COM_PORT, MODEL, 'Libraries', 'Servo');

hitec = servo(a, SERVO_PORT, 'MinPulseDuration', minPulse, 'MaxPulseDuration', maxPulse);

% figure
% xlim([xLowerBound, xUpperBound]);
% ylim([yLowerBound, yUpperBound]);
% hold on
% for angle  = 0:resolution:1
%     writePosition(hitec, angle);
%     
% end
% TODO: time-dependent loop, define motion be chronological parameters like period

writePosition(hitec, 0.5);
pause(3);
writePosition(hitec, 0);
pause(3);

resolution = 1/1000;
period = 1.5;  % Period is 1.5 seconds

start = cputime;




% while true     
%     fprintf('Current motor position is %d degrees\n', current_pos);
%     writePosition(hitec, angle);
%     pause(period/resolution*1.25);
% end

function scaled_pos = getScaledPos()
    elapsed = cputime - start;
    angle = (elapsed/period)*2*pi; % time to rad [-1,1]
    pos = sin(angle);
    scaled_pos = 0.5 + pos/2;
end
