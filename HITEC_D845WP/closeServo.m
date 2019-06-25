function closeServo()
    global serialServo;
    % Clean up serial connections
    fclose(serialServo);
    delete(serialServo);
    clear serialServo;
end