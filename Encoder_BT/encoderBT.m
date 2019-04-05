clear all;
clearSerials;   % Run program at least twice if BT issues


MODULE_NAME = 'Encoder'; % This should reflect name in RemoteNames call

% Survey and open proper bluetooth module
btInfoAll = instrhwinfo('Bluetooth');
btInfoAll.RemoteNames;                 % Check module name (e.g. 'HC-05')
btInfoModule = instrhwinfo('Bluetooth', MODULE_NAME);
btInfoModule;
btModule = Bluetooth(MODULE_NAME, 1);  % Assume 115200 baud by MATLAB
fopen(btModule);
fprintf(['Successfully opened BT module. Verify that the HC-05 is ',...
    'blinking slowly within 2 second intervals.\n']);

while(true)
    % Blocking methods do not interfere with timing of actual data.
    A = fscanf(btModule, '%f');      % Use fscanf() over fread() if the
    fprintf('Recieved %f\n', A);     % overhead is not an issue.
end
