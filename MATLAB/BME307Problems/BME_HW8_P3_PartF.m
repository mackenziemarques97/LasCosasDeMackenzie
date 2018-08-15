%BME 307, HW8, P3, Part F
%Mackenzie Marques
%03/27/2018
clear all
close all
%% Euler numerical methods  - plot drug concentration
D = 3.94e-6; % diffusion coefficient calculated from Part a; units: cm^2/s
r0 = 0; %initial radial position, r=0, units: cm
rEnd = 0.25; %final radial position, r=L, units: cm
z0 = 0; %initial axial position, units: cm
zEnd = 4; %final axial position, units: cm
dz = 0.01; %time step size, units: s
dr = 1e-3; %(2.*D.*dz).^(0.5); %position step size, units: cm
z = z0:dz:zEnd; %time vector
r = r0:dr:rEnd; %position vector
M = floor((zEnd-z0)./dz); %axial position nodes
N = floor((rEnd-r0)./dr ); %radial position nodes
C = zeros(N+1,M+1); %pre-allocated concentration  matrix
C(end,:) = 2e-4; %1st boundary condition: 
%%
%V = 14.26.*(1-((r(i).^2)./(rEnd.^2)));
for j = 1:M %iterate through axial position nodes (columns)
    %C(1,j+1) = C(1,j) +(2.*D.*dz./(dr.^2)).*(C(2,j)-C(1,j));
    for i = 2:N %iterate through radial position nodes (rows)
        %numerical approximation of concentration from Fick's 2nd Law
        %C(1,j+1) = C(1,j) +((2.*D.*dz)./(dr.^2)).*(C(2,j)-C(1,j));
        V = 14.26.*(1-((r(i).^2)./(rEnd.^2)));
        C(i,j+1) = C(i,j) + ((D.*dz)./(V.*dr)).*(((C(i+1,j) - C(i-1,j))./(2.*r(i))) + ((C(i+1,j) - 2.*C(i,j) +C(i-1,j)))./dr);
    end 
    C(1,j+1) = C(3,j+1);
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
figure(1)
hold on 
plot(r, C)
hold off
xlabel('radial position, r (cm)');
ylabel('concentration, C (mg/mL)');
title('Drug Concentration vs. Radial Position');
figure(2)
plot(z, C)
xlabel('axial position, z (cm)');
ylabel('concentration, C (mg/mL)');
title('Drug Concentration vs. Axial Position');
%% Plot of drug flux in tissue over time
C0 = 2e-4; 
Pe = (7.13*0.5)/D;
Ny = ((0.6783.*D.*C0)./rEnd).*((Pe.*(rEnd./z)).^(1/3)); %drug flux into tissue over time
figure(3)
plot(z , Ny); %plot of flux vs. time
title('Drug Flux vs. Time');
xlabel('Time, s');
ylabel('Flux, N (mg/cm^{2}s)');
Navg = cumtrapz(z,Ny);
t = (Navg*(2*pi*0.25))/(30e-3*3); 