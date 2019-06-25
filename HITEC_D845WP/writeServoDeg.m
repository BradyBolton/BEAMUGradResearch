function [time, reading] = writeServoDeg(posInDegrees, mode)
    global serialServo;
    global bluetoothLoadCell;
    if contains(mode, "s") || contains(mode, "S")
        fwrite(serialServo, posInDegrees, 'float32');
%         getResponse(serialServo, 1);
    end
    if contains(mode, "l") || contains(mode, "L")
        readRequest = 1;    % Send single byte to Arduino as a read request
        fwrite(bluetoothLoadCell, readRequest, 'uchar');
        [time, reading] = fscanf(bluetoothLoadCell, '%f,%f');
    else
        reading = 0;
    end
end

% function getResponse(serial, numOfResponses)
%     i = 0;
%     while i < numOfResponses
%         try
%             arduinoResponse = fscanf(serial);
%         catch E
%             disp(E.identifier);
%             disp("Closing Arduino.");
%             closeServo();
%         end
%         disp(arduinoResponse);
%         i = i + 1;
%     end
% end