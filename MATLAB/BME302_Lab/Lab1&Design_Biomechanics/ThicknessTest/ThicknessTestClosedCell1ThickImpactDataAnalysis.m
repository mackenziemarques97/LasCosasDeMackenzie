% BME432ImpacLab.m

% This is a modified version of the foam impact lab script based on the
% 2013 version. It is coded to analyze data from BME 302 Lab #1, Foam
% Impact Lab. Final plots are accel, velocity, displ vs. time & Force v.
% displ

% 01/12 to find the pulse to optimize viewing during in-class demos of the
% design projects. HIC, peak accle and pulse duration are calculated to
% discussion purposes. Requires the hicv2.m function. -rwn

% 12/19/13 : modified to use the lvm_import function, which removes the
% need to manually remove headers from the labview files. Also attempts to
% automate the data trimming - this is left as an option for the students
% -rwn
%
% -------------------------------------------------------------------------


% filename = the filename in single quotes. Expected is a labview .lvm file
% - do not include the file extension in the filename. This file must be in
% the same directory the matlab script. If not, you can add a path to
% indicate the location. lvm_import.m must also be in the path
clear all
close all
%initialize storage matrices
pulsedurationVal = zeros(1,3);
Kp = zeros(1,3);%stiffness by pulse duration
Kr = zeros(1,3);%stiffness by regression
R = zeros(1,3);
Er = zeros(1,3);
Ep = zeros(1,3);
Rstat = zeros(1,3);
Ro = [0.1/2 0.102/2 0.102/2];
Ri = [0.021/2 0.02/2 0.021/2];
A = pi.*(Ro.^2-Ri.^2);
A = mean(A);
L = [0.03 0.035 0.03];
L = mean(L);
Eimpact = zeros(1,3);
Estored = zeros(1,3);
Ediss = zeros(1,3);
Erebound = zeros(1,3);
HIC = zeros(1,3);

for w = 1:3
    filename=sprintf('CC40cm1td%d', w);

% cal_factor = Accelerometer calibration factor [ m/(s^2 * V) ]  
% mass = mass of rod-guided impactor  [kg]
% DropHeight = height [m]
% Vo = the initial velocity of the mass at impact [ m/s ]

cal_factor = 974.155;
mass = 1.6758;
DropHeight = 0.4;
Vo = -sqrt(2*9.81*DropHeight);
% Vo = 0;
Do = 0;

S = lvm_import(filename,0);     % load the data into array, S
time = S.Segment1.data(:,1);    % make a time array
incr = time(2) - time(1);       % get sampling time

% convert the voltage data to acceleration using the calibration factor

accel = S.Segment1.data(:,2) * cal_factor; 

% remove any initial DC offset based on the average of the first N points.
% Experiment with this if the leading data if not zero or if your autotrim
% is crashing.


N=10; % Number of leading data points used to establish DC offset
acceloffset=mean(accel(1:N));
accel = accel - acceloffset; 

autotrim = 1;
if autotrim == 1
    
    % -------------------------------------------------------------------------
    % Automated data trimming
    %
    % A method to find the start, peak, and end of the data based on the
    % standard deviation of the first N points. deviation of the first.
    % This automates the trimming process in theory, but it is not robust.
    % You may need to tweak N and nstd for some sampling parameters.
    
    accelstd=std(accel(1:N));
    nstd=10;  %number of std axceeded to define start of data
    accelstart=find(accel>(accelstd*nstd),1,'first');
    [peaka, p_index] = max(accel);
    accelunload=accel((p_index):(length(accel)));
    accelend=accelstart+find(accel(accelstart:(length(accel)))<0,1,'first');
    accel = accel(accelstart:accelend);
    time = time(accelstart:accelend);
    
else
    
    % -------------------------------------------------------------------------
    % Trim the data
    %
    % Here, you manually set the number of leading and trailing
    % points to trim from the acceleration data. Experiment with this - it will
    % reduce errors in the initial velocity assumption and speed up your HIC
    % calculation
    
    tl = 20; % Number of leading points to trim
    tt = 20; % Number of trailing points to trim
    accel =accel(tl:(length(accel)-tt));
    [peaka, p_index] = max(accel);
    time = time(tl:(length(time)-tt));
    
end

time = time - time(1); % Time shift the data so that time 0 is the first index
AccelInGs = [time,accel/9.81]; % Create an array of acceleration in Gs
hicvalue = hicv2(AccelInGs,1); % Calculate a HIC value. hicv2.m must be in the path
HIC(w) = hicvalue(1);
HIC = HIC(:);
pulseduration=time(length(time))-time(1); % Careful - this all depends on trimming
pulsedurationVal(w) = time(length(time))-time(1);
pulsedurationVal = pulsedurationVal(:);
% Plot the acceleration data:
figure(2*w-1)
subplot(2,2,1), plot(time,accel,'linewidth', 2)            
grid
xlabel('time [sec]'), ylabel('Acceleration [m/s^2]')
axval = axis;
h=line([hicvalue(2) hicvalue(2)],[0 axval(4)]);
set(h, 'Color', 'r');
h=line([hicvalue(3) hicvalue(3)],[0 axval(4)]);
set(h, 'Color', 'r');
title(filename)
text(axval(2)*0.7,axval(4)*0.9,sprintf('  HIC = %.2f',hicvalue(1)));
text(axval(2)*0.7,axval(4)*0.8,sprintf('  peak = %.2f',peaka));
% text(axval(2)*0.7,axval(4)*0.7,sprintf('  pulse = %.4f',pulseduration));

% Compute the velocity as a function of time
% -------------------------------------------------------------------------
% Integration method 1: using trapezoidal integration

velo = cumtrapz(accel) * incr; 

% Integration method 2: using summation (discrete) integration
% velo = cumsum(accel) * incr;

% Integration method 3: discrete integral with a for loop...
% velo = zeros(size(accel));
% velo(1) = accel(1) * incr;
% for i = 2:length(accel)
%     velo(i) = velo(i-1)+ (accel(i) * incr);
% end
% -------------------------------------------------------------------------

% Adjust the velocity data for the conditions at impact (equation 3)
velo = velo + Vo;

% plot velocity data:

subplot(2,2,2), plot(time,velo,'linewidth', 2)
grid on
xlabel('Time [sec]'), ylabel('Velocity [m/s]')
title(filename)

% compute the displacement as a function of time:
% -------------------------------------------------------------------------
% Integration method 1: using trapezoidal integration
displ = cumtrapz(velo) * incr; 
displ = (displ - Do);
subplot(2,2,3), plot(time,displ,'linewidth', 2)
grid
xlabel('Time [sec]'), ylabel('Displacement [m]')
title(filename)

% Find a peak displacement. You will use this to split your data into a
% loading phase (positive slope) and an unloading phase (negative slope).
% Be sure to note if the peak is actually the beginning of unloading. If
% not, then p_index may need to be defined manually.

[peaka, pa_index] = max(abs(accel));
[peakd, pd_index] = max(abs(displ));
p_index = pa_index;


% Calculate the force data:
force = accel * mass;
force_loading = force(1:p_index);
displ_loading = displ(1:p_index); 
force_unloading = force(p_index:length(force));
displ_unloading = displ(p_index:length(displ));

subplot(2,2,4), plot(displ_loading,force_loading,displ_unloading,force_unloading,':','linewidth', 2)
axval = axis;
grid
xlabel('Displacement [m]'), ylabel('Force [N]')
title(filename)
text(axval(1)*0.5,axval(4)*0.8,sprintf('  Disp. = %.3f',peakd));
orient tall

%Stiffness
Kp(w) = ((2.*pi./pulseduration).^2).*mass;
Kp = abs(Kp(:));
x = displ_loading(0.5*length(displ_loading):end);
y = force_loading(0.5*length(force_loading):end);
p = polyfit(x, y, 1);
F1 = polyval(p,x);
Kr(w) = p(1);
Kr = abs(Kr(:));
X = [ones(size(x)) x];
[~,~,~,~,stats] = regress(y,X);
Rstat(w) = stats(1);
Ep(w) = Kp(w)*L/A;
Ep = Ep(:);
Er(w) = Kr(w)*L/A;
Er = Er(:);
%Impact Energy
Eimpact(w) = 0.5.*mass.*(velo(end)).^2;
Eimpact = Eimpact(:);
%Rebound Energy
incrx1 = displ_unloading(2)-displ_unloading(1);
Ere = cumtrapz(force_unloading) * incrx1;
Erebound(w) = abs(Ere(end));
Erebound = Erebound(:);
%Stored Energy
incrx2 = displ_loading(2)-displ_loading(1);
Es = cumtrapz(force_loading) * incrx2;
Estored(w) = abs(Es(end)); 
Estored = Estored(:);
%Dissipated Energy
Ediss(w) = Estored(w) - Erebound(w);
Ediss = Ediss(:);

figure(2*w)
plot(displ_loading,force_loading,displ_unloading,force_unloading,x,F1,':','linewidth', 2)
axval = axis;
grid on
xlabel('Displacement [m]'), ylabel('Force [N]')
title(filename)
text(axval(1)*0.5,axval(4)*0.8,sprintf('  Disp. = %.3f',peakd));
text(axval(1)*0.5,axval(4)*0.7,sprintf('  y = %.1fx+%.1f',p(1),p(2)));
text(axval(1)*0.5,axval(4)*0.65,sprintf('  R^2 = %.3f',stats(1)));
hold on
orient tall
end
% Energy stored, returned and dissipated are not calculated by this script.
% That can be done using the commands and principles above and is left as
% an exercise. You can also consider automating the data analysis if you
% are clever with your file naming scheme.