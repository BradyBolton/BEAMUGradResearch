% Author: Andrew Chan
% Institution: Virginia Tech
% Desc: Dynamixel servo control
clearSerials;
close all
clear;  clc;

global s

%Movement constants
amp = pi/4; %Amplitude of motion
w = 8; %speed of servo

%Time Constants
min = -amp;
max = amp;
start = 0;
stop = 3*pi; %Time duration 

%Data collection variables
defaultSize = length(start : pi/64 : stop);

%Number of servos
ids = 1:1;
numberOfServos = length(ids);

% Actual Data
actualPos = NaN(2*numberOfServos, defaultSize); % why NaN is used
actualVel = NaN(2*numberOfServos, defaultSize);
%realTor = NaN(2*numberOfServos, defaultSize);
% Theoretical Data
desiredPos = NaN(2*numberOfServos, defaultSize);
desiredVel = NaN(2*numberOfServos, defaultSize);

%Setup dynamixel
dyn = init();

%Setup Arduino
setupFish('COM7')

%Loop variables
deltaT = .15;
timeIndex = 0;
timer = tic;
curTime = 0;

%% Update loop
while curTime <= stop
    %Update timer
    curTime = toc(timer);
    %Update array index
    timeIndex = timeIndex +1; %what is time index
    for i = ids
        %Update theoretical Data
        [desiredPos(i * 2, timeIndex), desiredVel(i * 2, timeIndex), desiredPos(2*i -1, timeIndex), desiredVel(2*i -1, timeIndex)] = update(dyn, i, curTime, w, amp, deltaT, timer);
        % Real data gathering
        [actualPos(i * 2, timeIndex), actualVel(i * 2, timeIndex), actualPos(2*i -1, timeIndex), actualVel(2*i -1, timeIndex)] = read(dyn, i, 'rad', 'rps', timer); % why 2*i -1
    end
    
    %Update deltaT
    deltaT = toc(timer) - curTime;
end

%% Exit protocal
% Optional reset to certain angle on exit
for i = ids
    dyn.writeAngle('id',i,'rad',0.6);
end
cleanUp(dyn);

%% Graphing titles and variables
t = 'Time (s)';
p = 'Angle (rad)';
v = 'Velocity (rad/s)';
T = 'Torque(N)';
posFig = figure;
velFig = figure;
%torFig = figure;
%Note that best fit curve is disabled in this version.
powerFit = 15;


%Offset lab
for i = ids
    lag = .1;
    actualVel(2*ids -1, :) = actualVel(2*ids -1, :) - 2*lag;%What is the use of lag
    actualPos(2*ids -1, :) = actualPos(2*ids -1, :) - lag;
end

%Graph data
for i = ids
    Polyfiter(actualPos(2*i-1:2*i, :), powerFit, t, sprintf('Actual position of servo %d', i), posFig);
    Polyfiter(desiredPos(2*i-1:2*i, :), powerFit, t, sprintf('Desired position of servo %d', i), posFig);
    Polyfiter(actualVel(2*i-1:2*i, :), powerFit, t, sprintf('Actual Position of servo %d', i), velFig);
    Polyfiter(desiredVel(2*i-1:2*i, :), powerFit, t, sprintf('Desired Velocity of servo %d', i), velFig);
    %Polyfiter(realTor(2*i-1:2*i, :), powerFit, t, sprintf('Actual Torque of servo %d', i), torFig);
end

%% Initialize Dynamixels
function dyn = init()
dyn = MyDynamixel();
% o.viewSupportFcn();
dyn.portNum = 7; % COM5
%dyn.portNum = 4; % COM4
dyn.baudNum = 1; % baud = 1000000 bps
dyn.init();
dyn.addDevice(1, '18A'); % ID = 1
% dyn.addDevice(1, '12A'); % ID = 2
%dyn.addDevice(1, '64A'); % ID = 3
end

%% Update dyn goal position and velocity
function [ang, vel, tAng, tVel] = update(dyn, id, t, w, amp, deltaT, timer)
ang = getAngle(t, w, amp, deltaT)+0.6;
dyn.writeAngle('id',id,'rad', ang);
tAng = toc(timer);

vel = getVelocity(t, w, amp, deltaT);
dyn.writeSpeed(id,'RPS', vel);

tVel = toc(timer);
end

%% Read data
function [ang, vel, tAng, tVel] = read(dyn, id, posUnit, velUnit, timer)

ang = dyn.readPos(id, posUnit); %'rad'
tAng = toc(timer);

vel = dyn.readVel(id, velUnit); %'rps'
tVel = toc(timer);
end

%% Theoretical data
function a = getAngle(t, w, amp, deltaT)
a = amp * (sin(w*(t + deltaT)));
end

function v =  getVelocity(t, w, amp, deltaT)
v = abs(w *amp* (cos(w * (t + deltaT)))*1.15);
end

%% Exit protocal
function cleanUp(dyn)
dyn.Exit();
disp('Done... exiting');
end

function setupFish(COM_PORT)
    global s
    s = serial(COM_PORT);
    set(s,'BaudRate',115200);
    fopen(s);
    disp('Serial opened');
end
