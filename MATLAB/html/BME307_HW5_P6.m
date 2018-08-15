%%BME 307, HW5, P6
% Mackenzie Marques
%Part b
a = 4.64;
x = linspace(0,10,1000);
Uo = 200;
rho = 1;
mu = 0.01;
V = a.*x.*((rho*Uo.*x)./mu).^-0.5;
clf(figure(1))
figure(1)
plot(x, V, 'k');
title('Boudary Layer Thickness vs. Distance from Edge');
xlabel('x (cm)');
ylabel('BL Thickness (cm)');
%Part c
b = 0.323;
Tw = (b*Uo./x).*(rho*Uo.*x).^0.5;
clf(figure(2))
figure(2)
plot(x, Tw,'k');
title('Wall Shear Stress vs. Distance from Edge');
xlabel('x (cm)');
ylabel('Wall Shear Stress (dyne/cm^{2})');
