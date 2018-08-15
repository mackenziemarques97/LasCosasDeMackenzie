clear all
close all

[num1,txt1,raw1] = xlsread('mBME354ECGLab6', 'ErrorBarsAll');
X = [0,5,15,30,60,120];
All = mean(num1, 1);
MeanHrAll = All(1:6);
MeanPrAll = All(7:12);
EAll = std(num1, 1);
EhrAll = EAll(1:6);
EprAll = EAll(7:12);
[numM,txtM,rawM] = xlsread('mBME354ECGLab6', 'ErrorBarsM');
M = mean(numM,1);
MeanHrM = M(1:6);
MeanPrM = M(7:12);
EM = std(numM, 1);
EhrM = EM(1:6);
EprM = EM(7:12);
[numF,txtF,rawF] = xlsread('mBME354ECGLab6', 'ErrorBarsF');
F = mean(numF, 1);
MeanHrF = F(1:6);
MeanPrF = F(7:12);
EF = std(num1, 1);
EhrF = EF(1:6);
EprF = EF(7:12);

clf(figure(1))
figure(1)
hold on
errorbar(X,MeanHrAll,EhrAll,'-o')
errorbar(X,MeanHrM,EhrM,'-o');
errorbar(X,MeanHrF,EhrF,'-o');
hold off
title('Heart Rate Error Bar Plot');
xlabel('Exercise Time Interval'); ylabel('Heart Rate');
axis([-5 125 0 140]);
legend('Overall', 'Male', 'Female');

clf(figure(2))
figure(2)
hold on
errorbar(X,MeanPrAll,EprAll,'-o')
errorbar(X,MeanPrM,EprM,'-o');
errorbar(X,MeanPrF,EprF,'-o');
hold off
title('PR Interval Error Bar Plot');
xlabel('Exercise Time Interval'); ylabel('PR Interval');
axis([-5 125 0 0.18]);
legend('Overall', 'Male', 'Female');

numAll = [numM; numF];
hr = numAll(1:end,1:6);
pr = numAll(1:end,7:12);
maleHR = numM(:,1:6);
maleHR = maleHR(:);
femaleHR =numF(:,1:6);
femaleHR = femaleHR(:);
malePR = numM(:,7:12);
malePR = malePR(:);
femalePR = numF(:,7:12);
femalePR = femalePR(:);
AllHR = [maleHR; femaleHR];
AllPR = [malePR; femalePR];
hr = hr(1:end,:) - hr(1:end,1);
pr = pr(1:end,:) - pr(1:end,1);
anova2(AllHR);
anova2(AllPR);
anova1(hr)
anova1(pr)