% initServo('COM8', 9600, 145, 0.101);
function initServo(sP, bR, c, mTD)
    %% Parameters (the user changes this)
    % Use a vendor specification sheet: https://www.servocity.com/d845wp-servo

    SERIAL_PORT = sP;       % E.g.'COM9'
    BAUD_RATE   = bR;       % See: https://www.mathworks.com/help/matlab/matlab_external/baudrate.html
    centeringOffsetPWM = c; % E.g. 145, PWM offset from 1500 PWM (90 deg) center
    microsToDeg = mTD;      % E.g. 0.101, Microseconds to Degrees (of servo-actuation)
    global serialServo;
    
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
    serialServo = serial(SERIAL_PORT, ...
        'BaudRate', BAUD_RATE, ...
        'StopBits', 1, ...
        'Parity', 'none');
        % Assume little-endian by default, s.DataBits = 8
    disp("MATLAB: opening connection, will take 2 seconds.");
    fopen(serialServo);
    disp("MATLAB: opened serial connection.");
    pause(1);

    getResponse(serialServo, 1); % Initial Arduino response

    fwrite(serialServo, centeringOffsetPWM, 'int32');
    fwrite(serialServo, microsToDeg, 'float32');
    getResponse(serialServo,1); % Verify bytes recieved
    disp(serialServo);
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