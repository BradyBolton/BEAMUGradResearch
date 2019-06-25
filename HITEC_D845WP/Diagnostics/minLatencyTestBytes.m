clearSerials;
global weight;
module_name = 'HC-05';
btInfoModule = instrhwinfo('Bluetooth', module_name);
bluetoothLoadCell = Bluetooth(module_name, 1);
bluetoothLoadCell.Timeout = 30;
bluetoothLoadCell.BytesAvailableFcnMode = 'byte';       % Necessary to parse
bluetoothLoadCell.BytesAvailableFcnCount = 4;
bluetoothLoadCell.BytesAvailableFnc = @instructionCallBack;
% Stop read after 4B
fopen(bluetoothLoadCell);
flushinput(bluetoothLoadCell);
pause(2);
bluetoothLoadCell.ReadAsyncMode = 'manual';
readasync(bluetoothLoadCell);
fprintf(['Successfully opened BT module. Verify that the HC-05 is ',...
    'blinking slowly within 2 second intervals.\n']);
test = 2; % single byte
i = 1;
weight = single(0);            % Prealloc (avoids the double cast)
fwrite(bluetoothLoadCell, test, 'uchar');
pause(0.5);
disp(weight);

function out = instructionCallBack()
    global weight;
    weight = fread(bluetoothLoadCell, 1, 'single');
end
