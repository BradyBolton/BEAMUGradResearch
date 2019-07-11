% Author: Andrew Chan
% Instatution: Virginia Tech
% Desc: Dynamixel servo control

clear;  clc;
%Setup dynamixel
dyn = init();
pi = 3.1415926535897932384626433832795041;
start = 0;
stop = 2 * pi;
inc = .05;
timeSet = [start : inc: stop];

%User angle input
while 1
	k = input('(Enter q to quit) angle=: ', 's');
	%Max seems to be 150~-150
	if ~strcmp(k,'q')
		dyn.writeAngle('id',1,'deg',str2double(k));
	else
		break;
	end
	
end
%Exit protocal
cleanUp(dyn);

function dyn = init()
%% Initialize Dynamixels
dyn = MyDynamixel();
%o.viewSupportFcn();
dyn.portNum = 14; % COM1
dyn.baudNum = 1; % baud = 1000000 bps
dyn.init()
dyn.addDevice(1); % ID = 1

%% Set Speed
% dyn.setSpeed('id',2,'RPM',10); % set speed 10 rpm
% dyn.setSpeed('id',8,'RPM',10);
  dyn.setSpeed('id', 1,'RPM',10);
% dyn.setSpeed('id',5,'maxSpeed');
% dyn.setSpeed('id',5,'maxSpeedNoControl');
% dyn.setSpeed('id',254,'RPM',10); % Set Speed for all devices

%%% Write Command
%dyn.writeAngle('id',7,'deg',10);  %Set starting angle to 10
end

function stop = update(dyn, timer)


end

function cleanUp(dyn)
%Optional reset to certain angle on exit
% dyn.writeAngle('id',1,'rad',pi);
% dyn.writeAngle('index',2,'deg',100);
% dyn.writeAngle('index',2,'rad',pi);

dyn.Exit();
disp('Done... exiting');
end