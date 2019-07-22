function out = fishHandler(angleRadians, flags)

timeEnc = 0;
dataEnc = 0;
timeLoad = 0;
dataLoad = 0;

% Read flags
encoderFlag = contains(flags, "e", 'IgnoreCase', true);    
loadcellFlag = contains(flags, "l", 'IgnoreCase', true);
servoFlag = contains(flags, "s", 'IgnoreCase', true);

% Update dyn goal position and velocity
if servoFlag
    ang = getAngle(t,  amp, deltaT);
    dyn.writeAngle('id',id,'rad', ang);
    tAng = toc(timer);

    vel = getVelocity(t, amp, deltaT);
    dyn.writeSpeed(id,'RPS', vel);

    tVel = toc(timer);
end

% Read sensors
if encoderFlag && loadcellFlag
    fwrite(serialDevice, 1, 'uchar');   % Time, Encoder, Loadcell (both)
    [timeEnc, dataEnc, timeLoad, dataLoad] = fscanf(serialDevice, '%f,%f,%f,%f', [1,3]);
elseif encoderFlag
    fwrite(serialDevice, 2, 'uchar');   % Time, Encoder (only)
    [timeEnc, dataEnc] = fscanf(serialDevice, '%f,%f', [1,3]);
elseif loadcellFlag
    fwrite(serialDevice, 3, 'uchar');   % Time, Loadcell (only)
    [timeLoad, dataLoad]= fscanf(serialDevice, '%f,%f', [1,3]);
end

% Do nothing if no valid flags exist to act on

out = [timeEnc, dataEnc, timeLoad, dataLoad];

end

%% Update dyn goal position and velocity
function [ang, vel, tAng, tVel] = update(dyn, id, t, timer)
ang = DesiredTheta(t);
dyn.writeAngle('id',id,'rad', ang);
tAng = toc(timer);

vel = getVelocity(t, amp, deltaT);
dyn.writeSpeed(id,'RPS', vel);

tVel = toc(timer);
end

%% Read data
function [ang, vel, tAng, tVel] = read(dyn, id, posUnit, velUnit, timer)

ang = dyn.readPos(id, posUnit); %'rad'
tAng = toc(timer);

vel = dyn.readVel(id, velUnit); %'rps'
tVel = toc(timer);
end