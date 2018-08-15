%bme 307, hw 10, p 3
%Mackenzie Marques
clear all
close all
T = 20+273.15;
rho = 1.4;
mu = 0.01; 
Mw = [180 1200 17000 69000 150000];
a = ((3.*Mw)./(4.*pi.*rho.*(6.022.*10.^(23)))).^(1/3);
f = 6.*pi.*mu.*a;
Dgel = [4.5e-6 1.7e-6 4e-7 1e-7 1.3e-8];
Dwater = ((1.38065e-16)*T)./f;
Y = Dgel./Dwater;



