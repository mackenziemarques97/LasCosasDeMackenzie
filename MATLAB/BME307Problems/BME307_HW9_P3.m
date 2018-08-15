%Mackenzie Marques
%BME 307, HW9, P3

vavg = logspace(-2,3,6); %cm/s
Re = 70.*vavg; %unitless
Sc = (0.03)/(1e-5); %unitless
Crit = (2*4.5)./(Re.*3000); %unitless
D = 2; %cm
L = 4.5; %cm
Deff = 1e-5; %cm^2/s
km = (Deff/D).*(1.86.*(Re.*Sc.*(D./L)).^(1/3));
plot(vavg,km);
xlabel('average blood velocity, cm/s');
ylabel('mass transfer coefficient, cm/s');
title('Mass transfer coefficient vs. average blood velocity'); 