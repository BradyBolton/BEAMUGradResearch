% Close/clear previously existing bluetooth modules to prevent interference
clc;
%clear all
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
%close all
clc;
disp('Serial Port Closed');