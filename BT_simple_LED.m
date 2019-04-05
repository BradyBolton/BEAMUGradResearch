clear all;
%fclose(instrfind);
%delete(instrfind);
btInfo = instrhwinfo('Bluetooth');
btInfo.RemoteNames
btInfo = instrhwinfo('Bluetooth','Encoder');
encoder = Bluetooth('Encoder', 1);
% encoder.Baudrate=57600;
fopen(encoder); %check if exists?
fprintf("Successfully openned BT module.\n");
% output = '0';
% flip = false;
while(true)
    %{
    pause(5);
    if(flip)
        output = '0';
        flip = false;
    else
        output = '1';
        flip = true;
    end
    fprintf("Trying to send message to BT module.\n");
    fprintf(encoder,output);
    %}
    % A = fread(encoder,1,'char');
    A = fscanf(encoder, '%d');
    fprintf('Recieved %d\n', A);
end
%fopen(encoder);
%fprintf(encoder,'1');
