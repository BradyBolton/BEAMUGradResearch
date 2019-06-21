function initServoParameters(T, a1, a2, a3, a4, a5, a6)
    global arduinoSerial;
    % Wave-form parameters (single precision, 4B size)
    out = [single(T), ... 
           single(a1),...
           single(a2),...
           single(a3),...
           single(a4),...
           single(a5),...
           single(a6)];
    
    % Write parameters to Arduino
    fwrite(arduinoSerial, out, 'float32');
    getResponse(arduinoSerial,3); % Verify bytes recieved
end

function getResponse(serial, numOfResponses)
    i = 0;
    while i < numOfResponses
        try
            arduinoResponse = fscanf(serial);
        catch E
            disp(E.identifier);
            disp("Closing Arduino.");
            closeServo();
        end
        disp(arduinoResponse);
        i = i + 1;
    end
end