%% sendCoeffsTimingTest.m
% use this script to isolate things
% & determine root of problem sending forward_ & reverse_coeffs

a = serial('COM8','BaudRate',9600,'DataBits',8,'StopBits',1,'Parity','none');
fopen(a);

SerialInit = 'b';
while (SerialInit~='a')
        SerialInit=fread(a,1,'uchar'); %be ready to receive any incoming data
end
if (SerialInit=='a')
        disp('Serial read')
end

fprintf(a,'%c','a'); %MATLAB sending 'a'
            %response to Arduino's "Type the letter a, then hit enter."
            %equivalent of typing 'a' into Serial monitor
mbox = msgbox('Serial Communication setup'); uiwait(mbox);
 
fscanf(a, '%u')
 %%
 
 sendCoeffs(a,forward_coeffs)

 sendCoeffs(a,reverse_coeffs)
 
 fscanf(a, '%s')
         %% sendCoeffs function
        %takes in matrix of coeffcients
        %converts matrix to a string that with : delimiter
        %sends string to Arduino
        
        function sendCoeffs(a, coeffs)
            while (strcmp(fscanf(a,'%s'),'ReadyToReceiveCoeffs') == 1)
                disp('Preparing to Send Coeffs');
            end 
            str = inputname(2);
            strList = sprintf(':%d', coeffs);
            strToSend = [str strList]
            fprintf(a, strToSend);
            fscanf(a, '%u')
            while (strcmp(fscanf(a,'%s'),'CoeffsReceived') == 1)
                disp('Arduino Received Coeffs');
            end 
        end