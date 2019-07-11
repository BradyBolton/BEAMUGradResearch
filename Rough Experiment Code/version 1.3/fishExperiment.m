clearSerials;
close all
COM_PORT = 'COM7';
s = serial(COM_PORT);
set(s,'BaudRate',115200);
fopen(s);
disp('Serial opened');
%% Main Experiment Loop
i = 1;
timer = tic;
fwrite(s, 'r', 'uchar');  % Reset Arduino's time
curTime = 0;
stop = 15;                % Experiment is 15s

time = zeros([n, 1]);
data = zeros([n, 3]);

receiveData(s);

f1 = figure('Name','Encoder Raw Value');
f2 = figure('Name','Load-cell Raw Value');
movegui(f1,'northeast');
movegui(f2,'southwest');

 while curTime <= stop
     tic
     curTime = toc(timer);
     data(i,:) = receiveData(s, "le");  % read both encoder and load-cell
     %fprintf("Reading: %f\n", data(i,1));
     figure(f1);
     plot(data(1:i,1),data(1:i,2).*-1);
     drawnow
     figure(f2);
     plot(data(1:i,1),data(1:i,3).*-1);
     drawnow
     time(i) = toc;
     i = i + 1;
 end
fprintf('Average round-time latency: %fs\n', mean(time));
% xaxis = data(:,2);
% plot(data(1:(n-1),1),data(1:(n-1),2).*-1);
% plot(data(1:(n-1),1),data(1:(n-1),3).*-1);
function out = receiveData(serialDevice, flags)
    time = 0;
    encoderReading = 0;
    loadcellReading = 0;
    loadcell
    loadcellFlag = contains(flags, 'l', 'IgnoreCase', true);
    encoderFlag = contains(flags, 'e', 'IgnoreCase', true);
    if(loadcellFlag && encoderFlag)
        fwrite(serialDevice, 'b', 'uchar');   % Send byte to Arduino
        out = fscanf(serialDevice, '%f,%f,%f\n', [1,3]);
    elseif (loadcellFlag)
        fwrite(serialDevice, 'l', 'uchar');   % Send byte to Arduino
        [time, loadcellReading] = fscanf(serialDevice, '%f,%f\n', [1,2]);
        out = [time, 0, loadcellReading];
    elseif (encoderFlag)
        fwrite(serialDevice, 'e', 'uchar');   % Send byte to Arduino
        [time, encoderReading] = fscanf(serialDevice, '%f,%f\n', [1,2]);
        out = [time, encoderReading, 0];
    else
        fwrite(serialDevice, 'n', 'uchar');   % Send byte to Arduino
        time = fscanf(serialDevice, '%f', [1,1]);
        out = [time, 0, 0];
    end
end