function reading = writeServoDeg(posInDegrees, mode)
    global serialServo;
    global bluetoothLoadCell;

    if contains(mode, "s") || contains(mode, "S")
        fwrite(serialServo, posInDegrees, 'float32');
    end
    if contains(mode, "l") || contains(mode, "L")
        reading = fscanf(bluetoothLoadCell, '%f');
    else
        reading = 0;
    end
end