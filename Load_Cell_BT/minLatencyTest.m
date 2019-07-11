global bluetoothLoadCell;
clearSerials;
initLoadCell;
test = 2; % single byte
i = 1;
n = 500;
time = zeros([n, 1]);
weight = zeros([n,2]);
fwrite(bluetoothLoadCell, test, 'uchar');
fscanf(bluetoothLoadCell, '%f,%f');
 while i < n
     tic
     fwrite(bluetoothLoadCell, test, 'uchar');
     weight(i,:) = fscanf(bluetoothLoadCell, '%f,%f', [1,2]);
     fprintf("Load-cell reading: %f\n", weight(i,1));
     plot(weight(1:i,2),weight(1:i,1).*-1);
     drawnow
     time(i) = toc;
     i = i + 1;
 end
fprintf('Average round-time latency: %fs\n', mean(time));
% xaxis = weight(:,2);
% plot(weight(:,2),weight(:,1).*-1);

function initLoadCell
    global bluetoothLoadCell;
    module_name = 'HC-05';
    bluetoothLoadCell = Bluetooth(module_name, 1);
    bluetoothLoadCell.Timeout = 30;
    fopen(bluetoothLoadCell);
    fprintf(['Successfully opened BT module. Verify that the HC-05 is ',...
    'blinking slowly within 2 second intervals.\n']);
end