function moveServoPos(pos)
    global arduinoSerial;
    fprintf(arduinoSerial, "p%d", pos);
end
