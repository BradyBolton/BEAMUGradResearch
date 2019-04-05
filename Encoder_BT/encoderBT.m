define MODULE_NAME 'Encoder' % This should reflect name in RemoteNames call

clear all;
clearSerials;

% Survey and open proper bluetooth module
btInfoAll = instrhwinfo('Bluetooth');
btInfoAll.RemoteNames;                     % Check module name (e.g. 'HC-05')
btInfoModule = instrhwinfo('Bluetooth', MODULE_NAME);
btInfoModule;
btModule = Bluetooth(MODULE_NAME, 1);  % Assume 115200 baud by MATLAB
fopen(btModule);
fprintf(['Successfully opened BT module. Verify that the HC-05 is ',...
    'blinking slowly within 2 second intervals.\n']);

while(true)
    A = fscanf(encoder, '%d');      % Prefer fscanf() over fread()
    fprintf('Recieved %d\n', A);
end
