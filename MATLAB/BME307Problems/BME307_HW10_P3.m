%bme 307, hw 10, p 2
%Mackenzie Marques
clear all 
close all
z = linspace(0,0.1,1000);
C1 = 5-12.558.*z;
C2 = 2.265-12.558.*z;
C3 = 2.186-(12.558.*z);
hold on
plot(z, C1, 'k:', z, C2, 'k-.', z, C3, 'k--');
title('Concentration of glucose vs. Axial position along capillary');
xlabel('axial position, z (cm)');
ylabel('concentration, C(z) (\mumol/{cm}^3)');
legend('within blood', 'at outer surface of capillary', 'at Krogh tissue cylinder radius');