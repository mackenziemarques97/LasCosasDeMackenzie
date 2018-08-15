%% BME 307, Computer Project 2, Part 1
% Mackenzie Marques (mlm99)
clear all
close all
%ncs = nanoparticle carrier system
%dtb = dead tissue bed
%% Problem set up
Dncs = 3e-6; % diffusion coefficient in nanoparticle carrier system; units: cm^2/s
Ddtb = 5e-9; % diffusion coefficient in dead tissue bed; units: cm^2/s
k = 5e-5; % first order reaction coefficient; units: s^-1
h1 = 0.02; % depth of nanoparticle carrier system; units: cm
h2 = 0.02; % depth of diseased tissue bed; units: cm
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
C(1:Nncs+1,1) = 1e6; %at t= 0 within the ncs, initial concentration throughout is 1e6 nanoparticles/mL
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
%% Plots
figure(1)
%plot of concentration vs. position
%each curve represents a time
%plot(x,C(:,1));
hold on
plot(x,C(:,10));
%plot(x,C(:,100));
plot(x,C(:,1000));
%plot(x,C(:,10000));
plot(x,C(:,100000));
%plot(x,C(:,200000));
plot(x,C(:,400000));
%plot(x,C(:,600000));
plot(x,C(:,800000));
%plot(x,C(:,1000000));
plot(x,C(:,2000000));
%plot(x,C(:,3000000));
plot(x,C(:,4000000));
hold off
title('Nanoparticle Concentration vs. Position, Time');
xlabel('position, x (cm)');
ylabel('Concentration, C (nanoparticles/mL)');
legend('t = 0.2 s', 't = 20 s (0.00556 hr)', 't = 2,000 s (0.556 hr)', 't = 8,000 s (2.22 hr)', 't = 16,000 s (4.44 hr)', 't = 40,000 s (11.1 hr)', 't = 80,000 s (22.2 hr)');
axis([0 0.04 0 10e5]);

figure(2)
%plot of concentration versus time
%every curve represents a position
hold on
plot(t,C(1,:),'--');
plot(t,C(10,:),'-.');
plot(t,C(20,:),'--');
plot(t,C(30,:),'-.');
plot(t,C(40,:),'--');
plot(t,C(50,:));
plot(t,C(60,:));
plot(t,C(70,:));
plot(t,C(80,:));
title('Nanoparticle Concentration vs. Position, Time');
xlabel('time, t (s)');
ylabel('Concentration, C (nanoparticles/mL)');
legend('x = 0 cm', 'x = 0.005 cm', 'x = 0.01 cm', 'x = 0.015 cm', 'x = 0.020 cm', 'x = 0.025 cm', 'x = 0.030 cm', 'x = 0.035 cm', 'x = 0.040 cm');