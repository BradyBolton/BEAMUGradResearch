function moveServoTime(pos, time)
    global serialArduino;
    command = [pos, time];
    fprintf(serialArduino, "t%d,%d", command);
end