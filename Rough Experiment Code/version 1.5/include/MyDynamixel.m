classdef MyDynamixel < handle
    %MYDYNAMIXEL Summary of this class goes here
    %   Detailed explanation goes here
    properties(Hidden, Access = private)
        mode = 'JOINT'
    end
    properties
        portNum;
        baudNum;
        libName = 'dynamixel'
        Devices = struct('id',[],'offset',0,'x',0,'xMin',0,'xMax',deg2rad(300),'name','motor1','index',1,'status','active','speed',10,...
            'maxSpeed',114);
        Instruction;
        numDevices = 0;
        
    end
    methods
        function MD = MyDynamixel(port,baud)
            if (nargin == 2)
                MD.portNum = port;
                MD.baudNum = baud;
                res = calllib(MD.libName, 'dxl_initialize',MD.portNum, MD.baudNum);
                if res == 0
                    fprintf('Cannot init dynamixel \n');
                end
            else
                fprintf('Serial port does not configure \n')
            end
            MD.Instruction.PING = hex2dec('01');
            MD.Instruction.READ_DATA = hex2dec('02');
            MD.Instruction.WRITE_DATA = hex2dec('03');
            MD.Instruction.REG_WRITE = hex2dec('04');
            MD.Instruction.ACTION = hex2dec('05');
            MD.Instruction.RESET = hex2dec('06');
            MD.Instruction.SYNC_WRITE = hex2dec('83');
            loadlibrary(MD.libName, 'dynamixel.h')
        end
        function Exit(MD)
            calllib(MD.libName,'dxl_terminate');
            unloadlibrary(MD.libName);
        end
        function init(MD,port,baud)
            if (nargin ==3)
                MD.portNum = port;
                MD.baudNum = baud;
                res = calllib(MD.libName, 'dxl_initialize',MD.portNum, MD.baudNum);
                if res == 0
                    fprintf('Cannot init dynamixel \n');
                end
            else
                res = calllib(MD.libName, 'dxl_initialize',MD.portNum, MD.baudNum);
                if res == 0
                    fprintf('Cannot init dynamixel \n');
                end
            end
        end
        function viewSupportFcn(MD)
            libfunctions(MD.libName);
        end
        function addDevice(MD,id,serial)
            switch(serial)
                case '18A'
                    MD.numDevices = MD.numDevices + 1;
                    MD.Devices(MD.numDevices).id = id;
                    MD.Devices(MD.numDevices).status = 'active';
                    MD.Devices(MD.numDevices).index = MD.numDevices;
                    MD.Devices(MD.numDevices).offset = 150;
                    MD.Devices(MD.numDevices).xMin = 0;
                    MD.Devices(MD.numDevices).xMax = 300;
                    MD.Devices(MD.numDevices).torqueMax = 1.8;
                    MD.Devices(MD.numDevices).x = 0;
                    MD.Devices(MD.numDevices).name = sprintf('Servo %d 18A',MD.numDevices);
                    MD.Devices(MD.numDevices).speed = 10;
                    MD.Devices(MD.numDevices).maxSpeedRPM = 114; %IN RPM
                    MD.Devices(MD.numDevices).maxSpeedRPS = MD.Devices(MD.numDevices).maxSpeedRPM * pi / 30;
                    MD.Devices(MD.numDevices).xMaxReal = 1023;
                    
                    %Position conversion values
                    MD.Devices(MD.numDevices).toDEG = MD.Devices(MD.numDevices).xMax / MD.Devices(MD.numDevices).xMaxReal;
                    MD.Devices(MD.numDevices).fromDEG = 1 / MD.Devices(MD.numDevices).toDEG;
                    MD.Devices(MD.numDevices).toRAD = deg2rad(MD.Devices(MD.numDevices).xMax) / MD.Devices(MD.numDevices).xMaxReal;
                    MD.Devices(MD.numDevices).fromRAD = 1 / MD.Devices(MD.numDevices).toRAD;
                    
                    %Velocity Conversion values
                    MD.Devices(MD.numDevices).toRPS = MD.Devices(MD.numDevices).maxSpeedRPS / MD.Devices(MD.numDevices).xMaxReal;
                    MD.Devices(MD.numDevices).fromRPS = 1 / MD.Devices(MD.numDevices).toRPS;
                    MD.Devices(MD.numDevices).toRPM = MD.Devices(MD.numDevices).maxSpeedRPM / MD.Devices(MD.numDevices).xMaxReal;
                    MD.Devices(MD.numDevices).fromRPM = 1 / MD.Devices(MD.numDevices).toRPM;
                    
                    %Torque readings
                    MD.Devices(MD.numDevices).toTOR = MD.Devices(MD.numDevices).torqueMax / MD.Devices(MD.numDevices).xMaxReal;
                
                case '12A'
                    MD.numDevices = MD.numDevices + 1;
                    MD.Devices(MD.numDevices).id = id;
                    MD.Devices(MD.numDevices).status = 'active';
                    MD.Devices(MD.numDevices).index = MD.numDevices;
                    MD.Devices(MD.numDevices).offset = 150;
                    MD.Devices(MD.numDevices).xMin = 0;
                    MD.Devices(MD.numDevices).xMax = 300;
                    MD.Devices(MD.numDevices).torqueMax = 1.5;
                    MD.Devices(MD.numDevices).x = 0;
                    MD.Devices(MD.numDevices).name = sprintf('Servo %d 12A',MD.numDevices);
                    MD.Devices(MD.numDevices).speed = 10;
                    
                    MD.Devices(MD.numDevices).maxSpeedRPM = 114; %IN RPM
                    MD.Devices(MD.numDevices).maxSpeedRPS = MD.Devices(MD.numDevices).maxSpeedRPM * pi / 30;
                    MD.Devices(MD.numDevices).xMaxReal = 1023;
                    
                    %Position conversion values
                    MD.Devices(MD.numDevices).toDEG = MD.Devices(MD.numDevices).xMax / MD.Devices(MD.numDevices).xMaxReal;
                    MD.Devices(MD.numDevices).fromDEG = 1 / MD.Devices(MD.numDevices).toDEG;
                    MD.Devices(MD.numDevices).toRAD = deg2rad(MD.Devices(MD.numDevices).xMax) / MD.Devices(MD.numDevices).xMaxReal;
                    MD.Devices(MD.numDevices).fromRAD = 1 / MD.Devices(MD.numDevices).toRAD;
                    
                    %Velocity Conversion values
                    MD.Devices(MD.numDevices).toRPS = MD.Devices(MD.numDevices).maxSpeedRPS / MD.Devices(MD.numDevices).xMaxReal;
                    MD.Devices(MD.numDevices).fromRPS = 1 / MD.Devices(MD.numDevices).toRPS;
                    MD.Devices(MD.numDevices).toRPM = MD.Devices(MD.numDevices).maxSpeedRPM / MD.Devices(MD.numDevices).xMaxReal;
                    MD.Devices(MD.numDevices).fromRPM = 1 / MD.Devices(MD.numDevices).toRPM;
                    
                    %Torque readings
                    MD.Devices(MD.numDevices).toTOR = MD.Devices(MD.numDevices).torqueMax / MD.Devices(MD.numDevices).xMaxReal;
                case '64A'

                    MD.numDevices = MD.numDevices + 1;
                    MD.Devices(MD.numDevices).id = id;
                    MD.Devices(MD.numDevices).status = 'active';
                    MD.Devices(MD.numDevices).index = MD.numDevices;
                    MD.Devices(MD.numDevices).offset = 150;
                    MD.Devices(MD.numDevices).xMin = 0;
                    MD.Devices(MD.numDevices).xMax = 300;
                    MD.Devices(MD.numDevices).torqueMax = 6;
                    MD.Devices(MD.numDevices).x = 0;
                    MD.Devices(MD.numDevices).name = sprintf('Servo %d, 64A',MD.numDevices);
                    MD.Devices(MD.numDevices).speed = 10;
                    
                    MD.Devices(MD.numDevices).maxSpeedRPM = 63; %IN RPM
                    MD.Devices(MD.numDevices).maxSpeedRPS = MD.Devices(MD.numDevices).maxSpeedRPM * pi / 30;
                    MD.Devices(MD.numDevices).xMaxReal = 4095;
                    
                    %Position conversion values
                    MD.Devices(MD.numDevices).toDEG = MD.Devices(MD.numDevices).xMax / MD.Devices(MD.numDevices).xMaxReal;
                    MD.Devices(MD.numDevices).fromDEG = 1 / MD.Devices(MD.numDevices).toDEG;
                    MD.Devices(MD.numDevices).toRAD = deg2rad(MD.Devices(MD.numDevices).xMax) / MD.Devices(MD.numDevices).xMaxReal;
                    MD.Devices(MD.numDevices).fromRAD = 1 / MD.Devices(MD.numDevices).toRAD;
                    
                    %Velocity Conversion values
                    MD.Devices(MD.numDevices).toRPS = MD.Devices(MD.numDevices).maxSpeedRPS / MD.Devices(MD.numDevices).xMaxReal;
                    MD.Devices(MD.numDevices).fromRPS = 1 / MD.Devices(MD.numDevices).toRPS;
                    MD.Devices(MD.numDevices).toRPM = MD.Devices(MD.numDevices).maxSpeedRPM / MD.Devices(MD.numDevices).xMaxReal;
                    MD.Devices(MD.numDevices).fromRPM = 1 / MD.Devices(MD.numDevices).toRPM;
                    
                    %Torque readings
                    MD.Devices(MD.numDevices).toTOR = MD.Devices(MD.numDevices).torqueMax / MD.Devices(MD.numDevices).xMaxReal;
                
            end
        end
        function removeDevice(MD,id)
            for i = 1: MD.numDevices
                if (id == MD.Devices(i).id)
                    MD.Devices(i).status = 'inactive';
                end
            end
            
        end
        
        function writeAngle(MD,varargin)
            n = length(varargin);
            i = 1;
            if (n >=3)
                while(i < n)
                    prop = varargin{i};
                    val = varargin{i+1};
                    switch prop
                        case 'id'
                            for j = 1: length(MD.Devices)
                                if MD.Devices(j).id == val
                                    ind = j;
                                    break;
                                end
                            end
                        case 'index'
                            ind = val;
                        case 'deg'
                            val = val + MD.Devices(ind).offset;
                            if val < MD.Devices(ind).xMin
                                val = MD.Devices(ind).xMin;
                            end
                            if val > MD.Devices(ind).xMax
                                val = MD.Devices(ind).xMax;
                            end
                            MD.Devices(ind).x = val;
                            dat = uint16(val*MD.Devices(ind).fromDEG);
                        case 'rad'
                            val = rad2deg(val)+ MD.Devices(ind).offset;
                            if val < MD.Devices(ind).xMin
                                val = MD.Devices(ind).xMin;
                            end
                            if val > MD.Devices(ind).xMax
                                val = MD.Devices(ind).xMax;
                            end
                            MD.Devices(ind).x = val;
                            %prepare real data for dynamixel
                            dat = uint16(val*MD.Devices(ind).fromDEG);
                    end
                    i = i+2;
                end
                calllib(MD.libName,'dxl_write_word',MD.Devices(ind).id,ControlTable.GoalPos_L,dat);
            end
        end
        
        function writeSpeed(MD,id, unit, dat)
            switch(unit)
                case 'RPS'
                    dat = abs(uint16(dat*MD.Devices(id).fromRPS));
                case 'RPM'
                    dat = abs(uint16(val*MD.Devices(id).fromRPM));
            end
            if (dat > MD.Devices(id).xMaxReal)
                dat = MD.Devices(id).xMaxReal;
            elseif(dat < -MD.Devices(id).xMaxReal)
                dat = -MD.Devices(id).xMaxReal;
            end
            
            MD.Devices(id).x = dat;
            
            calllib(MD.libName,'dxl_write_word',id,ControlTable.MovingSpeed_L,dat);
            
            
        end
        
        function setSpeed(MD,varargin)
            n = length(varargin);
            i = 1;
            if (n >=3)
                while(i < n)
                    prop = varargin{i};
                    val = varargin{i+1};
                    switch prop
                        case 'id'
                            for j = 1: length(MD.Devices)
                                if MD.Devices(j).id == val
                                    ind = j;
                                end
                            end
                        case 'index'
                            ind = val;
                        case 'RPM'
                            if val < 1
                                val = 1;
                            end
                            if val > MD.Devices(ind).maxSpeed
                                val = MD.Devices(ind).maxSpeed;
                            end
                            MD.Devices(ind).speed = val;
                            dat = uint16(val*MD.Devices(ind).fromRPM); %1023/144
                        case 'RPS'
                            if val < 1
                                val = 1;
                            end
                            if val > MD.Devices(ind).maxSpeed
                                val = MD.Devices(ind).maxSpeed;
                            end
                            MD.Devices(ind).speed = val;
                            dat = uint16(val*MD.Devices(ind).fromRPS); %1023/12
                        case 'maxSpeed'
                            MD.Devices(ind).speed = MD.Devices(ind).maxSpeedRPM;
                            dat = 1023;
                        case 'maxSpeedNoControl'
                            MD.Devices(ind).speed = 0;
                            dat = 0;
                    end
                    i = i+2;
                end
                calllib(MD.libName,'dxl_write_word',MD.Devices(ind).id,ControlTable.MovingSpeed_L,dat);
            end
        end
        function ledOn(MD)
            calllib(MD.libName,'dxl_write_byte',2,ControlTable.LED,1);
        end
        function ledOff(MD)
            calllib(MD.libName,'dxl_write_byte',2,ControlTable.LED,0);
        end
        function setMode(MD,id,mode)
            switch mode
                case 'WHEEL'
                    calllib(MD.libName,'dxl_write_word',id,ControlTable.CWAngleLimit_L,0);
                    calllib(MD.libName,'dxl_write_word',id,ControlTable.CCWAngleLimit_L,0);
                case 'JOINT'
                    calllib(MD.libName, 'dxl_write_word', id, ControlTable.CCWAngleLimit_L, MD.Devices(id).xMaxReal);
            end
        end
        
        function pos = readPos(MD, id, units)
            reading = calllib(MD.libName, 'dxl_read_word', id, ControlTable.PresentPos_L) - (MD.Devices(id).xMaxReal / 2);
            switch units
                case 'deg'
                    pos = MD.Devices(id).toDEG * reading;
                case 'rad'
                    pos = MD.Devices(id).toRAD * reading;
            end
        end
        
        function vel = readVel(MD, id, units)
            reading = calllib(MD.libName, 'dxl_read_word', id, ControlTable.PresentSpeed_L);
            if reading > 1023
                reading = reading - (MD.Devices(id).xMaxReal);
            end
            
            switch units
                case 'rpm'
                    vel = MD.Devices(id).toRPM * reading;
                case 'rps'
                    vel =  MD.Devices(id).toRPS * reading;
            end
        end
        
        function tor = readTorque(MD, id)
            reading = calllib(MD.libName, 'dxl_read_word', id, ControlTable.PresentLoad_L);
            
            if reading > 1023
                reading = -reading +(1023);
            end
            tor = MD.Devices(id).toTOR * reading;
            
            
        end
        
    end
end

