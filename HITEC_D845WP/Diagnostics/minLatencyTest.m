global bluetoothLoadCell;
clearSerials;
initLoadCell;
test = 2; % single byte
i = 1;
time = zeros([100, 1]);
weight = zeros([100,2]);
fwrite(bluetoothLoadCell, test, 'uchar');
fscanf(bluetoothLoadCell, '%f,%f');
 while i < 1000
     tic
     fwrite(bluetoothLoadCell, test, 'uchar');
     weight(i,:) = fscanf(bluetoothLoadCell, '%f,%f', [1,2]);
     time(i) = toc;
     i = i + 1;
 end
fprintf('Average round-time latency: %fs\n', mean(time));
xaxis = weight(:,2);
plot(xaxis,weight);

function initLoadCell
    global bluetoothLoadCell;
    module_name = 'HC-05';
    bluetoothLoadCell = Bluetooth(module_name, 1);
    bluetoothLoadCell.Timeout = 30;
    fopen(bluetoothLoadCell);
    fprintf(['Successfully opened BT module. Verify that the HC-05 is ',...
    'blinking slowly within 2 second intervals.\n']);
end