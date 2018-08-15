%BME 307, HW7, P6, Part D & E
%Mackenzie Marques
%03/27/2018

clear all
close all
%% Euler numerical methods  - plot drug concentration - slab
D = 3e-6; % diffusion coefficient calculated from Part a; units: cm^2/s
x0 = 0; %initial position, x=0, units: cm
xEnd = 0.208; %final position, x=L, units: cm
t0 = 0; %initial time, t=0, units: s
tEnd = 10*3600; %final time, t=36000, units: s
dt = 1; %time step size, units: s
dx = (2.*D.*dt).^(0.5); %position step size, units: cm
t = t0:dt:tEnd; %time vector
x = x0:dx:xEnd; %position vector
M = floor((tEnd-t0)./dt); %time nodes
N = floor((xEnd-x0)./dx); %position nodes
C = zeros(N+1,M+1); %pre-allocated concentration  matrix
C(end,:) = 10e-9; %1st boundary condition: x=0,t>=0,C=10
C(end,1) = 0;
%2nd boundary condition: x>>0,t>=0,C=0
%initial condition: x>0,t=0,C=0
%2nd boundary condition and initial condition already accounted for in
%matrix of zeros
for j = 1:M %iterate through time nodes (columns)
    C(1,j+1) = C(1,j) +((2*D*dt)/(dx^2))*(C(2,j)-C(1,j));
    for i = 2:N %iterate through position nodes (rows)
        C(i,j+1) = C(i,j) + ((D.*dt)./(dx.^2)).*(C(i+1,j)-2.*C(i,j)+C(i-1,j)); %numerical approximation of concentration from Fick's 2nd Law
    end   
end 
%alternative approach to organizing position
%position = zeros(N+1,M+1); 
%for i = 1:N+1
    %for j = 1:M+1
        %position(i,j) = (i-1)*dx;
    %end 
%end
figure(1)
%plot of concentration vs. position
%each line represents a time
plot(x, C);
title('Glucose Concentration vs. Position, Time');
xlabel('position, x (cm)');
ylabel('Concentration, C (\mumol/mL)');
figure(2)
plot(x, C(:,40), 'k', x, C(:,2000), 'k--', x, C(:,10000), 'k-.', x, C(:,15000), 'k:', x, C(:,30000), 'k*')
legend('t = 40s', 't = 2000s', 't = 10,000s', 't = 15,000s', 't = 30,000s');
title('Glucose Concentration vs. Position, Time');
xlabel('position, x (cm)');
ylabel('Concentration, C (\mumol/mL)');
%% Euler numerical methods  - plot glucose concentration - sphere
D = 3e-6; % diffusion coefficient calculated from Part a; units: cm^2/s
r0 = 0; %initial position, x=0, units: cm
rEnd = 0.31; %final position, x=L, units: cm
t0 = 0; %initial time, t=0, units: s
tEnd = 10*3600; %final time, t=3600, units: s
dt = 1; %time step size, units: s
dr = (2.*D.*dt).^(0.5); %position step size, units: cm
t = t0:dt:tEnd; %time vector
r = t0:dr:rEnd; %position vector
M = floor((tEnd-t0)./dt); %time nodes
N = floor((rEnd-r0)./dr ); %position nodes
C = zeros(N+1,M+1); %pre-allocated concentration  matrix
C(end,:) = 10e-9; %1st boundary condition: x=0,t>=0,C=10
C(end,1) = 0; 
for j = 1:M %iterate through time nodes (columns)
    C(1,j+1) = C(1,j) +(2.*D.*dt./(dr.^2)).*(C(2,j)-C(1,j));
    for i = 2:N %iterate through position nodes (rows)
        %numerical approximation of concentration from Fick's 2nd Law
        C(i,j+1) = C(i,j) + (D.*dt./(r(i).^2)).*(r(i).*(C(i+1,j) - C(i-1,j))./dr + (r(i).^2).*(C(i+1,j) - 2.*C(i,j) +C(i-1,j))./(dr.^2));
    end 
end 
%alternative approach to organizing position
%position = zeros(N+1,M+1); 
%for i = 1:N+1
    %for j = 1:M+1
        %position(i,j) = (i-1)*dx;
    %end 
%end
%figure(1)
%plot of concentration vs. position
%each line represents a time
figure(3)
hold on 
plot(r, C)
hold off
xlabel('position, r (cm)');
ylabel('concentration, C (\mumol/mL)');
figure(4)
plot(r, C(:,40), 'k', r, C(:,2000), 'k--', r, C(:,5000), 'k-.', r, C(:,10000), 'k:', r, C(:,30000), 'k*')
legend('t = 40s', 't = 2000s', 't = 5,000s', 't = 10,000s', 't = 30,000s');
title('Glucose Concentration vs. Position, Time');
xlabel('position, r (cm)');
ylabel('Concentration, C (\mumol/mL)');