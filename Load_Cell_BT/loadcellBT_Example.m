% Initiate the BT module by specifying the name (Check 'Bluetooth & other devices')
initLoadCell('HC-05');
while(true)
    % Get averaged readings (out of 10 individual readings)
    avgReading = readLoadCell();    
    fprintf('Read: %f\n', avgReading);     
end
