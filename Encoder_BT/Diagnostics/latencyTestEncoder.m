global bluetoothEncoder;
global reading;
% clearSerials;
% initEncoder('Encoder', 600, 10);
test = 1; % single byte
i = 1;
roundTripLatencyTime = zeros(10000, 1);
reading = zeros(10000,3);
fwrite(bluetoothEncoder, test, 'uchar');
fscanf(bluetoothEncoder, '%f,%f,%f');
initialTime = tic;
timeSpan = 10;
 while toc(initialTime) < timeSpan
     fwrite(bluetoothEncoder, test, 'uchar');
     reading(i,:) = fscanf(bluetoothEncoder, '%f,%f,%f', [1,3]);
     fprintf("Pos (Deg): %f\n", reading(i,1)/2400*-360);
     i = i + 1;
 end
plotGraphs;

function plotGraphs
    global reading;
    time = reading(:,3);
    pos = reading(:,1)./-2400.*2.*pi;
    dy = diff(pos);%./diff(time);
    dT = diff(time);
    omega = dy./dT;
    sumDT = zeros(size(dT));
    runningSum = 0;
    for i = 1:size(dT)
        runningSum  = runningSum + 0.5 * dT(i);
        sumDT(i) = runningSum;
        runningSum  = runningSum + 0.5 * dT(i);
    end
    start = time(1);
    actualTime = time-start;
    plot(actualTime, pos);
    hold;
    plot(sumDT,omega);
    plot(sumDT,zeros(size(sumDT)));
    axis([0 10 -1.25 1.25])
end