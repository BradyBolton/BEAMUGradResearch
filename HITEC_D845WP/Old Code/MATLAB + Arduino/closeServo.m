function closeServo()
    global arduinoSerial;
    % Clean up serial connections
    fclose(arduinoSerial);
    delete(arduinoSerial);
    clear arduinoSerial;
end