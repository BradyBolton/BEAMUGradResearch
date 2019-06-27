function btModule = initBluetooth(module_name)
% initEncoder Returns an initiated bluetooth object for the encoder. If initialization issues occur, try calling clearSerials().

    % 'Module name' should reflect name in InfoAll.RemoteNames()
    btInfoAll = instrhwinfo('Bluetooth');
    disp(btInfoAll.RemoteNames);            % Check module name (e.g. 'HC-05')
    btInfoModule = instrhwinfo('Bluetooth', module_name);
    disp(btInfoModule);
    fprintf('Before the creation of BT object\n');
    btModule = Bluetooth(module_name, 1);   % Assume 115200 baud by MATLAB
    fprintf('After the creation of BT object\n');
    btModule.Timeout = 30;
%   btModule.BytesAvailableFcnMode = 'byte';
%   btModule.Terminator = '';
%     fopen(btModule);
%     fprintf(['Successfully opened BT module. Verify that the HC-05 is ',...
%         'blinking slowly within 2 second intervals.\n']);
end
