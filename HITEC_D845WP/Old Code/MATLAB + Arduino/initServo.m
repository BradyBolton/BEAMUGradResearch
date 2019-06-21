function initServo(SERIAL_PORT, BAUD_RATE)
    global arduinoSerial;
    %% Clean up setup
    close;
    clc;
    % Delete existing serial port (a serial port shouldn't exist, some previous
    % script failed to clean up their existing serial ports otherwise )
    if(size(instrfind) > 0)
        aSerial = instrfind('Type', 'serial', 'Port', SERIAL_PORT);
        fclose(aSerial);
        delete(aSerial);
        clear aSerial;
    end
    %% Setup Serial (configured for Arduino)
    arduinoSerial = serial(SERIAL_PORT, ...
        'BaudRate', BAUD_RATE, ...
        'StopBits', 1, ...
        'Parity', 'none');
        % Assume little-endian by default, s.DataBits = 8
    disp("MATLAB: opening connection, will take 2 seconds.");
    fopen(arduinoSerial);
    disp("MATLAB: opened serial connection.");
    pause(1);
    getResponse(arduinoSerial, 1); % Initial Arduino response
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