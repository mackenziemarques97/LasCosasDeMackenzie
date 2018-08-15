%%BME307, HW3, Question 5
%%Mackenzie Marques
S1 = [1 2 2 3 5 8 12 19 30 47 75 120 188 300 473 750 1200 1875];
V1 = [48687 37351 31537 27722 22551 16670 12417 9266 6682 4826 3457 2436 1740 1195 819 514 270 145];
S2 = [1 2 2 3 5 8 12 19 30 47 75 120 188 300 473 750 1200 1875];
V2 = [40112 30665 25676 22563 18482 13967 10509 7929 5802 4217 3030 2133 1523 1057 736 482 284 155];
S3 = [1 2 2 3 5 8 12 19 30 47 75 120 188 300 473 750 1200 1875];
V3 = [4651 5014 4844 4869 4748 4418 4024 3604 3136 2662 2187 1747 1371 1038 778 564 397 259];
S1norm = log10(S1);
V1norm = log10(V1/100);
S2norm = log10(S2);
V2norm = log10(V2/100);
S3norm = log10(S3);
V3norm = log10(V3/100);
plot(S1norm, V1norm, S2norm, V2norm, '--', S3norm, V3norm, '.-');
title('Linearized Viscosity vs. Shear Rate of Gels');
xlabel('log(Shear Rate) log(1/s)');
ylabel('log(Viscosity) log(cP)');
legend
