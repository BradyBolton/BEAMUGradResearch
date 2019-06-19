function result = initEncoder(module_name, p, readings_per_second)
%initEncoder Returns 1 if successfully initiated the encoder, otherwise -1
    clearSerials;   % Run twice if BT issues occur
    global btModule;
    global ppr;
    global readingsPerSecond;
    
    try
        ppr = p;
        readingsPerSecond = readings_per_second;

        % 'Module name' should reflect name in InfoAll.RemoteNames()
        btInfoAll = instrhwinfo('Bluetooth');
        disp(btInfoAll.RemoteNames);     % Check module name (e.g. 'HC-05')
        btInfoModule = instrhwinfo('Bluetooth', module_name);
        disp(btInfoModule);
        fprintf('Before the creation of BT object');
        btModule = Bluetooth(module_name, 1);% Assume 115200 baud by MATLAB
        fprintf('After the creation of BT object');
        fopen(btModule);
        
        fprintf(['Successfully opened BT module. Verify that the HC-05 is ',...
            'blinking slowly within 2 second intervals.\n']);
        result = 1;  % Indicate successful initialization
        
    catch
        warning('Praoblem initiating encoder.  Assigning a value of 0.');
        result = 0;  % Indicate unsucccessful initialization
    end
end