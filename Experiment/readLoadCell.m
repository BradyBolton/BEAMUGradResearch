function [reading, time] = readLoadCell(bluetoothLoadCell)
% READLOADCELL    Reads the load-cell via the ADC-HX711 and returns the reading and a time stamp for when the reading was taken. The callibration is loaded on the Arduino, see loadcellBTArduino. 
    fopen(bluetoothLoadCell);
    ping = 1;
    fwrite(bluetoothLoadCell, ping, 'uchar');
    [reading, time] = fscanf(bluetoothLoadCell, '%f,%f', [1,2]);
    fclose(bluetoothLoadCell);
end
