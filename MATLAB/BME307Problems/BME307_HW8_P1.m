% BME 307, HW 8, P1
%Mackenzie Marques

z = linspace(0,5,10000);
plot(z, 0.1065.*(z.^(1/3)), 'k:', z, 0.0494.*(z.^(1/3)), 'k-.', z, 0.0229.*(z.^(1/3)), 'k--', z, 0.0107.*(z.^(1/3)), 'k');
legend('<v> = 0.1 cm/s', '<v> = 1 cm/s', '<v> = 10 cm/s', '<v> = 100 cm/s');
xlabel('axial position (cm)');
ylabel('concentration boundary layer (cm)');
title('Concentration boundary layer vs. Axial position');