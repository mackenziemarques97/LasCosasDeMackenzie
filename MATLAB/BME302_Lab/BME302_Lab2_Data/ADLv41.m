% ADLv41.m

% Author:  Roger Nightingale, 2/17/16
% 	rev32   1)plot angular data in degrees
%           2)comments to encourage better integration
%           3)thick plot lines
%   rev40   1)added lvm import functionality
%   rev41  - JFL - cleaned up some text and minor alterations to match
%           laboratory protocol - calibration for omega


% Script to analyze triax acceleration data from a WiiMote. 3D velocity and
% displacments are computed by integration of the acceleration signal. This
% starter script assumes that the sampling rate is constant - that is not
% the case.

% filename = the filename in single quotes. This file must be in the same 
% directory the matlab script. If not, you can add a path to indicate the 
% location
clear all
close all


filename = 'WiiChairRotate_part4.lvm'; %'leap.lvm'


% Cal Factors - Accelerometer calibration factor [ m/(s^2), rad/s ]. You
% will need to change the calibration factors for the angular velocity,
% based on the analysis completed in the laboratory.
CalFactorAccel = 9.81;
CalFactorOmegaX = .0081;
CalFactorOmegaY = .0081;
CalFactorOmegaZ = 0.0095;

% Number of leading and trailing points to trim (must be >0)
tl = 15;
tt = 15;

S = lvm_import(filename,0);     % load the data into array, S
S.Segment1.data = S.Segment1.data(tl:(length(S.Segment1.data)-tt),:);
time = S.Segment1.data(:,1);    % make a time array
time=time-time(1);
whos S.Segment1.data
                                           
% Convert the ouput data to acceleration using the calibration factor.
% This would be a good place to assign the polarity of your signal if it
% does not conform to a right-handed coordinate system. Also, do not assume
% that the coordinate system below aligns with the SAE system described in
% the handout - you may need to assign Yacc_Column to accelX and so on....
accelX = S.Segment1.data(:,2) * CalFactorAccel; 
accelY = S.Segment1.data(:,3) * -CalFactorAccel; 
accelZ = S.Segment1.data(:,4) * CalFactorAccel;
aRes = S.Segment1.data(:,5) * CalFactorAccel; 
OmegaX = S.Segment1.data(:,6) * CalFactorOmegaX*2*pi/60;
OmegaY = S.Segment1.data(:,7) * CalFactorOmegaY*2*pi/60; 
OmegaZ = S.Segment1.data(:,8) * CalFactorOmegaZ*2*pi/60; 
RPM = S.Segment1.data(:,12) ;

% Remove any initial DC offset based on an average of the first n data
% points. You really might want to experiment with this - particularly on
% the Stationary Data. Be careful here - you may have initial conditions
% that you do not want to zero-out.
 n=40;
 accelX = accelX - mean(accelX(1:n));
 accelY = accelY - mean(accelY(1:n));
 accelZ = accelZ - mean(accelZ(1:n));
 OmegaX = OmegaX - mean(OmegaX(1:n));
 OmegaY = OmegaY - mean(OmegaY(1:n));
 OmegaZ = OmegaZ - mean(OmegaZ(1:n));

% Compute the velocity as a function of time
%*******************************************************
% Time step for integration - it's actually variable! 
incr = time(2)-time(1);   

veloX = cumtrapz(accelX) * incr; 
veloY = cumtrapz(accelY) * incr; 
veloZ = cumtrapz(accelZ) * incr; 

% compute the displacements as a function of time:
%*******************************************************

displX = cumtrapz(veloX) * incr; 
displY = cumtrapz(veloY) * incr; 
displZ = cumtrapz(veloZ) * incr; 
thetaX = cumtrapz(OmegaX) * incr; 
thetaY = cumtrapz(OmegaY) * incr; 
thetaZ = cumtrapz(OmegaZ) * incr; 

figure(1)
clf
% Plot the linear acceleration data:
subplot(2,2,1), plot(time,accelX,'linewidth', 2)
hold on
subplot(2,2,1), plot(time,accelY, '-r','linewidth', 2)
subplot(2,2,1), plot(time,accelZ, '-g','linewidth', 2)
grid
xlabel('time [sec]'), ylabel('acceleration [m/s^2]')
legend('X','Y','Z','Location','NorthEast')
title(filename)

% plot linear velocity data:
subplot(2,2,2), plot(time(1:end),veloX,'linewidth', 2)
hold on
subplot(2,2,2), plot(time(1:end),veloY, '-r','linewidth', 2)
subplot(2,2,2), plot(time(1:end),veloZ, '-g','linewidth', 2)
grid
xlabel('time [sec]'), ylabel('computed velocity [m/s]')
title(filename)

% plot linear displacement data:
subplot(2,2,3), plot(time(1:end),displX,'linewidth', 2)
hold on
subplot(2,2,3), plot(time(1:end),displY, '-r','linewidth', 2)
subplot(2,2,3), plot(time(1:end),displZ, '-g','linewidth', 2)
grid
xlabel('time [sec]'), ylabel('computed displacement [m]')
title(filename)

% plot position:
subplot(2,2,4), plot(displY,displX, 'o')
grid
xlabel('Y Position [m]'), ylabel('X Position [m]')
title(filename)

figure(2)
clf

% plot angular velocity data:
subplot(1,3,1), plot(time(1:end),OmegaX*180/pi,'linewidth', 2)
hold on
subplot(1,3,1), plot(time(1:end),OmegaY*180/pi, '-r','linewidth', 2)
subplot(1,3,1), plot(time(1:end),OmegaZ*180/pi, '-g','linewidth', 2)
grid
xlabel('time [sec]'), ylabel('Angular velocity [deg/s]')
title(filename)

% plot angular displacement data:
subplot(1,3,2), plot(time(1:end),thetaX*180/pi,'linewidth', 2)
hold on
subplot(1,3,2), plot(time(1:end),thetaY*180/pi, '-r','linewidth', 2)
subplot(1,3,2), plot(time(1:end),thetaZ*180/pi, '-g','linewidth', 2)
grid
xlabel('time [sec]'), ylabel('computed displacement [deg]')
title(filename)

rX = (veloX./(OmegaX.*180./pi))*3.28;
rY = (veloY./(OmegaY.*180./pi))*3.28;
rZ = (veloZ./(OmegaZ.*180./pi))*3.28;

veloR = sqrt(veloX.^2 + veloY.^2 + veloZ.^2);


% plot reach data:
subplot(1,3,3), plot(time(1:end),rX,'linewidth', 2)
hold on
subplot(1,3,3), plot(time(1:end),rY, '-r','linewidth', 2)
subplot(1,3,3), plot(time(1:end),rZ, '-g','linewidth', 2)
grid
xlabel('time [sec]'), ylabel('computed reach [ft]')
title(filename)

%% Calculate jump height
maxVeloX = max(veloX);
minVeloX = min(veloX);
maxTime = find(maxVeloX==veloX);
minTime = find(minVeloX==veloX);
jump = abs(veloX(maxTime:minTime));
roundtrip = cumtrapz(jump) * incr;
jumpheight = max(roundtrip/2);
