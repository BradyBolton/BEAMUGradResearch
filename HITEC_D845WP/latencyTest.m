
clearSerials;
module_name = 'HC-05';
btInfoAll = instrhwinfo('Bluetooth');
disp(btInfoAll.RemoteNames);     % Check module name (e.g. 'HC-05')
btInfoModule = instrhwinfo('Bluetooth', module_name);
disp(btInfoModule);
fprintf('Before the creation of BT object\n');
bluetoothLoadCell = Bluetooth(module_name, 1);% Assume 115200 baud by MATLAB
fprintf('After the creation of BT object\n');
bluetoothLoadCell.Timeout = 30;
%bluetoothLoadCell.BytesAvailableFcnMode = 'byte';
%bluetoothLoadCell.Terminator = 10;
fopen(bluetoothLoadCell);
fprintf(['Successfully opened BT module. Verify that the HC-05 is ',...
    'blinking slowly within 2 second intervals.\n']);
test = 2; % single byte 
i = 1;
time = zeros([100, 1]);
weight = zeros([100,1], 'single');
fwrite(bluetoothLoadCell, test, 'uchar');
fscanf(bluetoothLoadCell, '%f');
 while i < 101
     tic
     fwrite(bluetoothLoadCell, test, 'uchar');
     weight(i) = fscanf(bluetoothLoadCell, '%f');
     % weight(i) = single(fread(bluetoothLoadCell,1,'single'));
%      [start,varcount,msg] = fread(bluetoothLoadCell,1,'single');
%      weight(i) = msg;
     % time(i) = fread(bluetoothLoadCell,1,'float32');
     time(i) = toc;
     i = i + 1;
     
     tic
     fwrite(bluetoothLoadCell, test, 'uchar');
     disp(fscanf(bluetoothLoadCell, '%f'));
     toc
 end

disp(mean(time));
xaxis = linspace(1,100,100);
plot(xaxis,weight);
% Seems there's a 0.062034 second latency, we could ping the load-cell
% which might be able to support 10 readings per second if 1 sec / 0.062 is
% about 16.1201921527 readings per second maximum (less probably), we could
% keep calling toc, then use some smoothing function to interpolate the
% data in retrospect. With the modification, the module is less accurate
% but we can get the latency down to 0.0466 seconds or 46 milliseconds 