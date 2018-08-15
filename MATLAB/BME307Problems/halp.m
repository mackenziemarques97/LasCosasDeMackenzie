 %% BME 307, Computer Project 2, Part 1
% Mackenzie Marques (mlm99)
clear all
close all
%% Set up
Dncs = 3e-6; % diffusion coefficient in nanoparticle carrier system; units: cm^2/s
Ddtb = 3e-9; % diffusion coefficient in dead tissue bed; units: cm^2/s
k = 5e-5; % first order reaction coefficient; units: s^-1
h1 = 0.02; % depth of nanoparticle carrier system; units: cm
h2 = 0.02; % depth of diseased tissue bed; units: cm
x0 = 0; %initial position, x=0; units: cm
xcent = h1;
xEnd = h1+h2; %final position (total depth), x=h1+h2; units: cm
t0 = 0; %initial time, t=0; units: s
tEnd = 86400;  %86400; %final time, t=24 hrs; units: s
dt = 0.02; %time step size; units: s
dx = 0.0005; %position step size; units: cm
t = t0:dt:tEnd; %time vector
x = x0:dx:xEnd; %position vector
M = floor((tEnd-t0)./dt); %time nodes
Nncs = floor((xcent-x0)./dx); %position nodes
Ndtb = floor((xEnd-xcent)./dx); %position nodes
N = floor((xEnd-x0)./dx);
Cncs = zeros(Nncs+2,M+1); %pre-allocated carrier system concentration matrix that includes imaginary node for top surface and interface
Cdtb = zeros(Ndtb+1,M+1); %pre-allocated tissue bed concentration matrix that includes imaginary node for bottom surface of tissue


C = zeros(N+1,M+1);
C(1:Nncs+1,1) = 1e6;
C(Nncs+2:end,1) = 0;

for j = 1:M
    C(1,j+1) = C(1,j) + ((2*Dncs*dt)/(dx^2))*(C(2,j)-C(1,j));
    for i = 2:Nncs
        C(i,j+1) = C(i,j) +((Dncs*dt)/(dx^2))*(C(i+1,j)-2*C(i,j)+C(i-1,j));
    end 
    for i = Nncs+2:N
        C(i,j+1) = (1-k*dt)*C(i,j) + ((Ddtb*dt)/(dx^2))*(C(i+1,j)-2*C(i,j)+C(i-1,j));
    end
    %C(41,j+1) = C(41,j) + dt*(Ddtb*C(42,j)-(Ddtb+Dncs)*C(41,j)+Dncs*C(40,j));
    C(41,j+1) = (Ddtb*C(42,j+1) + Dncs*C(40,j+1))/(Dncs+Ddtb);
    C(N+1,j+1) = C(N+1,j) +((2*Ddtb*dt)/dx^2)*(C(N,j)-C(N+1,j));
end
%% Plotting
figure(1)
%plot of concentration vs. position
%each curve represents a time
Ctotal = [Cncs; Cdtb];
plot(x, C(:,1:30000:end));
title('Nanoparticle Concentration vs. Position, Time');
xlabel('position, x (cm)');
ylabel('Concentration, C (nanoparticles/mL)');

%figure(2)
%plot(x, Ctotal(:,40), 'k', x, Ctotal(:,2000), 'k--', x, Ctotal(:,10000), 'k-.', x, Ctotal(:,15000), 'k:', x, Ctotal(:,30000), 'k*')
%legend('t = 40s', 't = 2000s', 't = 10,000s', 't = 15,000s', 't = 30,000s');
%title('Nanoparticle Concentration vs. Position, Time');
%xlabel('position, x (cm)');
%ylabel('Concentration, C (nanoparticles/mL)');

%%

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
plot(t,C(1,:));
plot(t,C(10,:));
plot(t,C(20,:));
plot(t,C(30,:));
plot(t,C(40,:));
plot(t,C(50,:));
plot(t,C(60,:));
plot(t,C(70,:));
plot(t,C(80,:));
title('Nanoparticle Concentration vs. Position, Time');
xlabel('time, t (s)');
ylabel('Concentration, C (nanoparticles/mL)');
legend('x = 0', 'x = 0.005', 'x = 0.01', 'x = 0.015', 'x = 0.020', 'x = 0.025', 'x = 0.030', 'x = 0.035', 'x = 0.040');
