classdef ControlTable_64
    %CONTROLTABLE_64 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        ModelNumber_L = 0;              %RD
        ModelNumber_H = 1;              %RD
        FirmwareVersion = 6;            %RD
        ID = 7;                         %RD,WR
        BaudRate = 8;                   %RD,WR
        ReturnDelayTime = 9;            %RD,WR
        DriveMode = 10;
        OperatingMode = 11;
        ID2 = 12;
        ProtocalVersion = 13;
        HomingOffset = 20;
        Moving_threshold = 24;
        HighestLimitTem  = 31;          %RD,WR
        LowestLimitVoltage = 32;        %RD,WR
        HighestLimitVoltage = 34;       %RD,WR
        PWMLimit = 36;
        CurLimit = 38;
        AccLimit = 40;
        VelLimit=44;
        PosLimit_L = 48;
        PosLimit_H = 52;
        Shutdown = 63;
        TorqueEnable = 64;              %RD,WR
        LED = 65;                       %RD,WR
        StatusReturnLevel = 68;         %RD,WR
        RegisteredInstruction = 69;     %RD,WR
        HardwareErrorCode = 70;
        Vel_I_Gain = 76;
        Vel_P_Gain = 78;
        Pos_D_Gain = 80;
        Pos_I_Gain = 82;
        Pos_P_Gain = 84;
        FF_1 = 90;
        FF_2 = 88;
        Bus_W = 98;
        GoalPWM = 100;
        GoalCur = 102;
        GoalVel = 104;
        ProfAcc = 108;
        ProfVel = 112;
        GoalPos = 116;
        Tick = 120;
        Moving  = 122;                   %RD
        Moving_Status = 123;
        PresentPWM = 123;
        PresentCur = 126;
        PresentVel = 128;
        PresentPos_L = 132;              %RD
        Vel_Traj = 136;
        Pos_Traj = 140;
        PresentVol = 144;
        PresentTem = 146;                %RD
        
        %{
        CWAngleLimit_L = 6;             %RD,WR
        CWAngleLimit_H = 7;             %RD,WR
        CCWAngleLimit_L = 8;            %RD,WR
        CCWAngleLimit_H = 9;            %RD,WR
               MaxTorque_L = 14;               %RD,WR
        MaxTorque_H = 15;               %RD,WR
        AlarmLED = 17;                  %RD,WR
        AlarmShutdown = 18;             %RD,WR
        DownCalib_L = 20;               %RD
        DownCalib_H = 21;               %RD
        UpCalib_L = 22;                 %RD
        UpCalib_H = 23;                 %RD
        CWMargin = 26;                  %RD,WR
        CCWMargin = 27;                 %RD,WR
        CWSlope = 28;                   %RD,WR
        CCWSlope = 29;                  %RD,WR
        MovingSpeed_L = 32;             %RD,WR
        MovingSpeed_H = 33;             %RD,WRpos
        TorqueLimit_L = 34;             %RD,WR
        TorqueLimit_H = 35;             %RD,WR
        PresentPos_H = 37;              %RD
        PresentSpeed_L = 38;            %RD
        PresentSpeed_H = 39;            %RD
        PresentLoad_L = 40;             %RD
        PresentLoad_H = 41;             %RD
        PresentVoltage = 42;            %RD
      Lock = 47;                      %RD,WR
        Punch_L = 48;                   %RD,WR
        Punch_H = 49;                   %RD,WR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ModelNumber_L = 0;              %RD
        ModelNumber_H = 1;              %RD
        FirmwareVersion = 6;            %RD
        ID = 7;                         %RD,WR
        BaudRate = 8;                   %RD,WR
        ReturnDelayTime = 9;            %RD,WR
        
        
        ShadowID = 12;
        
        
        MovingThreshold = 24;
        
        HighestLimitTem  = 31;          %RD,WR
        
        HighestLimitVoltage = 32;       %RD,WR
        LowestLimitVoltage = 34;        %RD,WR
        
        
        
        
        MaxPosition = 48;
        MinPosition = 52;
        Shutdown = 63;
        TorqueEnable = 64;              %RD,WR
        LED = 65;                       %RD,WR
        StatusReturnLevel = 68;         %RD,WR
        RegisteredInstruction = 69;     %RD,WR
        
        CWAngleLimit_L = 48;             %RD,WR
        CWAngleLimit_H = 49;             %RD,WR
        CCWAngleLimit_L = 52;            %RD,WR
        CCWAngleLimit_H = 53;            %RD,WR
        
        
        MaxTorque_L = 14;               %RD,WR
        MaxTorque_H = 15;               %RD,WR
        
        AlarmLED = 65;                  %RD,WR
        AlarmShutdown = 18;             %RD,WR
        DownCalib_L = 20;               %RD
        DownCalib_H = 21;               %RD
        UpCalib_L = 22;                 %RD
        UpCalib_H = 23;                 %RD
        

        CWMargin = 26;                  %RD,WR
        CCWMargin = 27;                 %RD,WR
        CWSlope = 28;                   %RD,WR
        CCWSlope = 29;                  %RD,WR
        GoalPos_L = 30;                 %RD,WR
        GoalPos_H = 31;                 %RD,WR
        MovingSpeed_L = 32;             %RD,WR
        MovingSpeed_H = 33;             %RD,WRpos
        TorqueLimit_L = 34;             %RD,WR
        TorqueLimit_H = 35;             %RD,WR
        PresentPos_L = 36;              %RD
        PresentPos_H = 37;              %RD
        PresentSpeed_L = 38;            %RD
        PresentSpeed_H = 39;            %RD
        PresentLoad_L = 40;             %RD
        PresentLoad_H = 41;             %RD
        PresentVoltage = 42;            %RD
        PresentTem = 43;                %RD
        
        Moving  = 46;                   %RD
        Lock = 47;                      %RD,WR
        Punch_L = 48;                   %RD,WR
        Punch_H = 49;                   %RD,WR
        %}
    end
    
end

