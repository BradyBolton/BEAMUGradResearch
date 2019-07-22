% Author: Andrew Chan 
% Institution: Virginia Tech
% Desc: Dynamixel servo control

%% Initalization
clearSerials;
clear;
initSerials('COM7');

%% Parameters

% Movement constants
amp = pi/4; %Amplitude of motion
% per = 0.8;
% w = 2*pi/per; %speed of servo

%Time Constants
min = -amp;
max = amp;
start = 0;
stop = 3*pi; %Time duration 

%Data collection variables
defaultSize = length(start : pi/128 : stop);

%Number of servos
ids = 1:1;
numberOfServos = length(ids);

% Actual Data
actualPos = NaN(2*numberOfServos, defaultSize); % why NaN is used
actualVel = NaN(2*numberOfServos, defaultSize);
%realTor = NaN(2*numberOfServos, defaultSize);
expectedAverageReadings = 15;   % Expect around 15 readings per second
n = ceil(stop) * expectedAverageReadings;            
time = zeros([n, 1]);
data = zeros([n, 3]);

% Theoretical Data
desiredPos = NaN(2*numberOfServos, defaultSize);
desiredVel = NaN(2*numberOfServos, defaultSize);

%Setup dynamixel
dyn = init();

f1 = figure('Name','Encoder Raw Value');
xlabel({'Time','(in seconds)'});
ylabel({'Cumulative Position','(in radians)'});
f2 = figure('Name','Load-cell Raw Value');
xlabel({'Time','(in seconds)'});
ylabel({'Weight','(in kg)'});
movegui(f1,'east');
movegui(f2,'west');

receiveData();  % test connection

%Loop variables
deltaT = .15;
timeIndex = 0;
timer = tic;
curTime = 0;
j = 1;

%% Update loop
while curTime <= stop
    %Update timer
    curTime = toc(timer);
    
    %Update array index
    timeIndex = timeIndex +1; %what is time index
    
    data(timeIndex,:) = receiveData();
    
    for i = ids
        %Update theoretical Data
        [desiredPos(i * 2, timeIndex), ...
         desiredVel(i * 2, timeIndex), ...
         desiredPos(2*i -1, timeIndex), ...
         desiredVel(2*i -1, timeIndex)] = update(dyn, i, curTime,  amp, deltaT, timer);
        % Real data gathering
        [actualPos(i * 2, timeIndex), ...
         actualVel(i * 2, timeIndex), ...
         actualPos(2*i -1, timeIndex), ...
         actualVel(2*i -1, timeIndex)] = read(dyn, i, 'rad', 'rps', timer); % why 2*i -1
    end
    
    %Update deltaT
    deltaT = toc(timer) - curTime;
end

%% Exit protocal
% Optional reset to certain angle on exit
for i = ids
    dyn.writeAngle('id',i,'rad',0);
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
  
figure(f1);
plot(data(1:(timeIndex-1),1),data(1:(timeIndex-1),2).*(2*pi)./2400);
xlabel({'Time','(in seconds)'});
ylabel({'Cumulative Position','(in radians)'});
drawnow;
figure(f2);
plot(data(1:(timeIndex-1),1),data(1:(timeIndex-1),3).*-1);
xlabel({'Time','(in seconds)'});
ylabel({'Weight','(in kg)'});
drawnow;

%% Initialize Dynamixels
function dyn = init()
dyn = MyDynamixel();
% o.viewSupportFcn();
dyn.portNum = 10; % COM10
%dyn.portNum = 4; % COM4
dyn.baudNum = 1; % baud = 1000000 bps
dyn.init();
% dyn.addDevice(1, '18A'); % ID = 1
dyn.addDevice(1, '12A'); % ID = 2
%dyn.addDevice(1, '64A'); % ID = 3
end

%% Update dyn goal position and velocity
function [ang, vel, tAng, tVel] = update(dyn, id, t,  amp, deltaT, timer)
ang = getAngle(t,  amp, deltaT);
dyn.writeAngle('id',id,'rad', ang);
tAng = toc(timer);

vel = getVelocity(t, amp, deltaT);
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
function a = getAngle(t, amp, deltaT)
global Time
a = amp * DesiredTheta(t);
end

function v =  getVelocity(t, amp, deltaT)
M  = DesiredVelocity(t);
% global Time
% float w
% 
% w = 2*pi/Time;
v = amp * M;
end

%% Exit protocal
function cleanUp(dyn)
dyn.Exit();
disp('Done... exiting');
end

%% Sensor helper funtions

function out = receiveData()
    global serialDevice;
    fwrite(serialDevice, 1, 'uchar');   % Send byte to Arduino
    out = fscanf(serialDevice, '%f,%f,%f', [1,3]);
end

function initSerials(COM_PORT)
    global serialDevice;
    serialDevice = serial(COM_PORT);
    set(serialDevice,'BaudRate',115200);
    fopen(serialDevice);
    disp('Serial opened');
end

function clearSerials()
    if ~isempty(instrfind)
        fclose(instrfind);
        delete(instrfind);
    end
    clc;
    disp('Serial Port Closed');
end
