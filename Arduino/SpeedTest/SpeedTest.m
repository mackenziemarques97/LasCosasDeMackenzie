% Delays and Distances that we're examining
delayi = 10; % in microseconds
delayf = 80;
ddelay = 10; 
yi = 0; % in steps
yf = 2000;
dy = 250;
%angleTrials
a = setUpSerial('COM8'); 
secondary_coeffs = speedModelFit(a,delayi,delayf,ddelay,angleTrials);
fclose(a);

function [secondary_coeffs] = speedModelFit(...
    comPort,delayi,delayf,ddelay,angleTrials)

% Communicate with Arduino all the variables
fprintf(comPort,['speedtest:%d:%d:%d:%d:%d:%d'],...
    [delayi,delayf,ddelay,yi,yf,dy]);

while(strcmp(fscanf(comPort,'%s'),'Beginning')~=1)
   disp('Waiting for Experiment Start')
end
ddistance = fscanf(comPort,'%d'); %explain this fscanf thing again? it reads consecutively?
finalDistance = ddistance*angleTrials;

spdLoopDim = floor((delayf-delayi)/ddelay + 1);
angleLoopDim = floor((finalDistance-0)/ddistance + 1);

% Every column will be a different speed
time = zeros(angleLoopDim,spdLoopDim);
delays = delayi:ddelay:delayf;
x = zeros(angleLoopDim,spdLoopDim);
y = zeros(angleLoopDim,spdLoopDim);
speedCount = 0;

while(1)
    waitSignal = fscanf(comPort,'%s')
    if (strcmp(waitSignal,'Done')==1)
        break;
    elseif (strcmp(waitSignal,'Sending')==1)
        for i=1:angleLoopDim
            timeRead = fscanf(comPort,'%d')
            time(i,speedCount+1) = timeRead;
            x(i,speedCount+1) = fscanf(comPort,'%d');
            y(i,speedCount+1) = fscanf(comPort,'%d');
        end
        speedCount=speedCount+1;
    end
end

speedArray = sqrt(x.^2+y.^2)./(time./1000); %in steps/s measured
%speedArray = reshape(speeds,angleLoopDim,spdLoopDim);
angles = atan(y(1:angleLoopDim,1)./x(1:angleLoopDim,1))*180/pi

% Finds model of speed vs angles 
coeffs_angles = zeros(length(delays),4);
for i = 1:length(delays)
    f = fit(angles,speedArray(:,i),'exp2');
    coeffs_angles(i,:) = [f.a,f.b,f.c,f.d];
end

secondary_coeffs = zeros(4,4);
for i = 1:4
    f = fit(transpose(delays),coeffs_angles(:,i),'exp2');
    secondary_coeffs(i,:) = [f.a,f.b,f.c,f.d];
end

end

function [output] = finalModel(coeff_array,delay,angle)
complex_coeffs = [exp2(coeff_array(1,:),delay),...
    exp2(coeff_array(2,:),delay),...
    exp3(coeff_array(3,:),delay),...
    exp4(coeff_array(4,:),delay)];
output = exp2(complex_coeffs,angle);
end

% Two-Term Exponential Function
function [output] = exp2(coeffs,x)
output = coeffs(1).*exp(coeffs(2).*x) + coeffs(3).*exp(coeffs(4).*x);
end