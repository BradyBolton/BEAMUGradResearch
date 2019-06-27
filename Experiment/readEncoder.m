function [pos, vel, time] = readEncoder(bluetoothEncoder)
    % READENCODER    Reads the quadrature encoder and returns the current position (range from 0 - 4 x PPR), number of position increments since last reading, and a time stamp for the reading.
    fopen(bluetoothEncoder);
    ping = 1;
    fwrite(bluetoothEncoder, ping, 'uchar');    % Notify that we wish to read
    [pos, vel, time] = fscanf(bluetoothEncoder, '%f,%f,%f', [1,3]);   % Reading
    fclose(bluetoothEncoder);
end
