clear all
clc
close all

step = 0.01;
stopTime = 10; 
n = stopTime / step;
waveform = zeros([n,2]);
x = 1;
high = -100;
low = 100;

for i = 0:step:stopTime
    waveform(x,1) = i;
%     waveform(x,2) = 180*2*(DesiredTheta(i);
    waveform(x,2) = 180*DesiredTheta(i)/pi;
    
    if waveform(x,2) > high
        high = waveform(x,2);
    end
    if waveform(x,2) < low
        low = waveform(x,2);
    end
    x = x + 1;
end
plot(waveform(:,1),waveform(:,2));
fprintf('UpperBound: %f\n', high);
fprintf('LowerBound: %f\n', low);
