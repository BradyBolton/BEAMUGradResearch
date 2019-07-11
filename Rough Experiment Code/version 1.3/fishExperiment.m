%% Initalization
clearSerials;
initSerials('COM7');

%% Main Experiment Loop
i = 1;
curTime = 0;
stop = 15;                      % Experiment is 15 seconds

expectedAverageReadings = 15;   % Expect around 15 readings per second
n = stop * expectedAverageReadings;            
time = zeros([n, 1]);
data = zeros([n, 3]);

f1 = figure('Name','Encoder Raw Value');
xlabel({'Time','(in seconds)'});
ylabel({'Cumulative Position','(in radians)'});
f2 = figure('Name','Load-cell Raw Value');
xlabel({'Time','(in seconds)'});
ylabel({'Weight','(in kg)'});
movegui(f1,'east');
movegui(f2,'west');

receiveData();  % test connection
timer = tic;

 while curTime <= stop
     disp(curTime)
     currentIterationTime = tic;
     curTime = toc(timer);
     data(i,:) = receiveData();
     figure(f1);
     plot(data(1:i,1),data(1:i,2).*(2*pi)./2400);
     xlabel({'Time','(in seconds)'});
     ylabel({'Cumulative Position','(in radians)'});
     drawnow;
     figure(f2);
     plot(data(1:i,1),data(1:i,3).*-1);
     xlabel({'Time','(in seconds)'});
     ylabel({'Weight','(in kg)'});
     drawnow;
     time(i) = toc(currentIterationTime);
     i = i + 1;
 end
fprintf('Average round-time latency: %fs (%f samples per second)\n', mean(time), 1/mean(time));

%% Helper Functions

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