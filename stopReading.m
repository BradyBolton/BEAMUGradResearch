function [] = stopReading()
%stopReading Halts reading the rotary encoder
    global readEncoder;
    readEncoder = false;
end

