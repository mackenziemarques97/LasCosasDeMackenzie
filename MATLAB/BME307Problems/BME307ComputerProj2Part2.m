%% BME 307, Computer Project 2, Part 2
% Mackenzie Marques (mlm99)
clear all
close all
% Values for h2 and initial concentration at t=0 in nanopartical carrier
% system manually altered to find minimum concentration at which
% the desired concentration at the end of the dead tissue bed is obtained
% within a 24 hour period of time.
%ncs = nanoparticle carrier system
%dtb = dead tissue bed
%% Problem set up
Dncs = 3e-6; % diffusion coefficient in nanoparticle carrier system; units: cm^2/s
Ddtb = 5e-9; % diffusion coefficient in dead tissue bed; units: cm^2/s
k = 5e-5; % first order reaction coefficient; units: s^-1
h1 = 0.02; % depth of nanoparticle carrier system; units: cm
h2 = 0.08; % depth of diseased tissue bed; units: cm
x0 = 0; %initial position, x=0; units: cm
xcent = h1; %where interface will be considered
xEnd = h1+h2; %final position (total depth), x=h1+h2; units: cm
t0 = 0; %initial time, t=0; units: s
tEnd = 86400;  %86400; %final time, t=24 hrs; units: s
dt = 0.02; %time step size; units: s
dx = 0.0005; %position step size; units: cm
t = t0:dt:tEnd; %time vector
x = x0:dx:xEnd; %position vector
M = floor((tEnd-t0)./dt); %time nodes
Nncs = floor((xcent-x0)./dx); %position nodes for ncs
N = floor((xEnd-x0)./dx); %position nodes over entire system
C = zeros(N+1,M+1); %pre-allocated system concentration matrix that includes imaginary node for top surface of ncs and bottom surface of dtb

% initial conditions of concentration
C(1:Nncs+1,1) = 4.20e8; %at t= 0 within the ncs, initial concentration throughout is 1e6 nanoparticles/mL
C(Nncs+2:end,1) = 0; %at t=0 within dtb, inital concentration of nanoparticls is zero
%% iterations for nanaoparticle carrier system & diseased tissue bed
for j = 1:M %iterate through time nodes (columns)
    C(1,j+1) = C(1,j)+((2.*Dncs.*dt)./(dx.^2)).*(C(2,j)-C(1,j)); %flux at top surface of carrier system is zero
     for i = 2:Nncs %iterate through position nodes (rows); going from top of carrier system to interface
        C(i,j+1) = C(i,j) + ((Dncs.*dt)/(dx.^2)).*(C(i+1,j)-2.*C(i,j)+C(i-1,j)); %numerical approximation of concentration in ncs from Fick's 2nd Law
     end  
     for i = Nncs+2:N %iterate from top to bottom of tissue bed
        C(i,j+1) = (1-k.*dt).*C(i,j) + ((Ddtb.*dt)./(dx.^2)).*(C(i+1,j)-2.*C(i,j)+C(i-1,j)); %numerical approximation of concentration in dtb
     end
    C(Nncs+1,j+1) = (Ddtb.*C(Nncs+2,j+1) + Dncs.*C(Nncs,j+1))./(Dncs+Ddtb); %interface concentration calculation
    C(N+1,j+1) = C(N+1,j)+((2.*Ddtb.*dt)./(dx.^2)).*(C(N,j)-C(N+1,j));%flux at bottom surface of tissue bed is zero
end
%% Calculate time at which concentration at end of dtb is 1e5 nanoparticles/mL
T = min(find(C(N+1,:)>=1e5)); %find the index where the concentration at end of tissue is greater than or equal to concentration of interest
T = (T*dt)/3600 %convert time to hours
%% find simple equation
h2 = linspace(0.02,0.08,7); %values for depth of tissue
Ci = [7.28e5 2.15e6 6.22e6 1.79e7 5.07e7 1.44e8 4.20e8]; %values for min initial concentration necessary