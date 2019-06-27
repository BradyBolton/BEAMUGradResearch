if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
clc
disp('Serial Port Closed')
