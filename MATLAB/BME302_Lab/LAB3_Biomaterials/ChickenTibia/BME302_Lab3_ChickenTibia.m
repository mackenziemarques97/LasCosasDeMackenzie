%BME 302, Lab 3, Tissue Testing - Chicken Tibia (Compression)
%Mackenzie Marques 

clear all 
close all

%% Load Data
source_dirComp1 = 'C:\Users\Mackenzie\Documents\MATLAB\BME302_Lab\LAB3\ChickenTibia';
CompFile1 = dir(fullfile(source_dirComp1,'*.xlsx'));
for j = 1
    [num,txt,raw] = xlsread(CompFile1(j).name);
    name = extractBefore(CompFile1(j).name, '.xlsx');
    name = strrep(name,'1','');
    
    numtrials = numel(num(1,:))/2;  
SET = struct('Material', {},...
    'InnerDiameter', {},...
    'OuterDiameter', {},...
    'InitialLength', {},...
    'FinalLength', {},...
    'Area', {},...
    'Position', {},...
    'Load', {},...
    'Stress', {},...
    'Strain', {});
for k = 1:numtrials
    i = 2*k-1;
    s.Material = name;
    s.InnerDiameter = num(1,i+1);
    s.OuterDiameter = num(2,i+1);
    s.InitialLength = num(3,i+1);
    s.FinalLength = num(4,i+1);
    s.Area = num(5,i+1);
    s.Position = abs(num(9:end,i));
    s.Load = abs(num(9:end,i+1));
    s.Position(isnan(s.Position)) = [];
    s.Load(isnan(s.Load)) = [];
    s.Stress = (s.Load)./(s.Area);
    s.Strain = (s.Position)./(s.InitialLength);
    SET(k) = s;
end 
ChickTib.(sprintf('file%d', j))=SET;
end
%% Mean + SD of measuremnts 
MeanSD_tibia = struct('InDMean', {},...
    'OutDMean', {},...
    'InitialLengthMean', {},...
    'FinalLengthMean', {},...
    'AreaMean', {},...
    'InDSD', {},...
    'OutDSD', {},...
    'InitialLengthSD', {},...
    'FinalLengthSD', {},...
    'AreaSD',{});
    m.InDMean = mean([ChickTib.file1.InnerDiameter]);
    m.OutDMean = mean([ChickTib.file1.OuterDiameter]);
    m.InitialLengthMean = mean([ChickTib.file1.InitialLength]);
    m.FinalLengthMean = mean([ChickTib.file1.FinalLength]);
    m.AreaMean = mean([ChickTib.file1.Area]);
    m.InDSD = std([ChickTib.file1.InnerDiameter]);
    m.OutDSD = std([ChickTib.file1.OuterDiameter]);
    m.InitialLengthSD = std([ChickTib.file1.InitialLength]);
    m.FinalLengthSD = std([ChickTib.file1.FinalLength]);
    m.AreaSD = std([ChickTib.file1.Area]);
    MeanSD_tibia = m;
%% Stress Strain Plots
clf(figure(1))
figure(1)
hold on
    for d = 1:numel(ChickTib.file1)
        StressNew = downsample(ChickTib.file1(d).Stress, 3);
        StrainNew = downsample(ChickTib.file1(d).Strain, 3);
        [ChickTib.file1(d).StressNew] = StressNew;
        [ChickTib.file1(d).StrainNew] = StrainNew;
        [Pks, Locs] = findpeaks(ChickTib.file1(d).StressNew);
        if length(ChickTib.file1(d).StrainNew) >= max(Locs)
            ChickTib.file1(d).StrainNew(Locs(end):end) = [];
            ChickTib.file1(d).StressNew(Locs(end):end) = [];
        end 
        F = find(round(ChickTib.file1(d).StressNew, 2) == 0);
        ChickTib.file1(d).StrainNew(F) = [];
        ChickTib.file1(d).StressNew(F) = [];
        ChickTib.file1(d).StressNew = smooth((ChickTib.file1(d).StrainNew), (ChickTib.file1(d).StressNew),0.1, 'loess');
        %[StrainNew, StressNew] = smoothing(ChickTib.file1(d).StrainNew, ChickTib.file1(d).StressNew);
        [ChickTib.file1(d).diff] = diff(ChickTib.file1(d).StressNew)./diff(ChickTib.file1(d).StrainNew);
        [ChickTib.file1(d).diff2] = diff(ChickTib.file1(d).diff)./diff(ChickTib.file1(d).StrainNew(2:end));
        %original data plot
        %subplot(2,2,1);
        hold on 
        plot(ChickTib.file1(d).Strain, ChickTib.file1(d).Stress)
        xlabel('Strain (mm/mm)');
        ylabel('Stress (N/{mm}^2)');
        title(['Noisy Stress vs. Strain ', ChickTib.file1(d).Material]);
        hold off
        %Smoothed and downsampled plot
        %subplot(2,2,2)
        hold on
        %plot(ChickTib.file1(d).StrainNew, ChickTib.file1(d).StressNew);
        %title(['Cleaned Stress vs. Strain ', ChickTib.file1(d).Material]);
        ylim([0 80]);
        hold off
    end
    %clf(figure(2))
    %figure(2)
    %plot(ChickTib.file1(5).Strain, ChickTib.file1(5).Stress, ChickTib.file1(5).StrainNew, ChickTib.file1(5).StressNew);
%% Compression Modulus 
clear d c f 
P = zeros(1,14);
E = zeros(1,7);
YieldStress = zeros(1,7);
U = zeros(1, 7);
    for d = 1:numel(ChickTib.file1)        
        keepgoing = true;
        f = 50;
        Window = 10;
        while (f+Window < numel(ChickTib.file1(d).StrainNew)) && keepgoing
            R = corr(ChickTib.file1(d).StrainNew(f:f+Window), ChickTib.file1(d).StressNew(f:f+Window));
            if R > 0.97
                keepgoing = true;
                f = f+Window;
            else
                keepgoing = false;
                %X(d) = find(ChickTib.file1(d).StressNew == max(ChickTib.file1(d).StressNew));   
                X = ChickTib.file1(d).StrainNew(1:f+Window);
                Y = ChickTib.file1(d).StressNew(1:f+Window);
                U(d) = find(ChickTib.file1(d).diff < 0, 1, 'first');
                YieldStress(d) = ChickTib.file1(d).StressNew(U(d));
                %YieldStress(d) = ChickTib.file1(d).StressNew(round(0.98*(f+Window)));
                for c = 2*d-1 
                P(c:c+1) = polyfit(X, Y, 1);
                E(d) = abs(P(c));
                end 
            end 
        end  
   [ChickTib.file1(d).E] = E(d);
   [ChickTib.file1(d).YS] = YieldStress(d); %max(ChickTib.file1(d).StressNew);
   [ChickTib.file1(d).UStress] = max(ChickTib.file1(d).StressNew);
   R = find(ChickTib.file1(d).StressNew == max(ChickTib.file1(d).StressNew));
   [ChickTib.file1(d).UStrain] = ChickTib.file1(d).StrainNew(R);    
    end     
H = find(E == 0);
for d = H
   YieldStress(d) = ChickTib.file1(d).StressNew(end);
   for c = 2*d-1 
   P(c:c+1) = polyfit(ChickTib.file1(d).StrainNew, ChickTib.file1(d).StressNew, 1);
   E(d) = P(c);
   end 
   [ChickTib.file1(d).E] = E(d);
   [ChickTib.file1(d).YS] = YieldStress(d); %max(ChickTib.file1(d).StressNew);
   [ChickTib.file1(d).UStress] = max(ChickTib.file1(d).StressNew);
   R = find(ChickTib.file1(d).StressNew == max(ChickTib.file1(d).StressNew));
   [ChickTib.file1(d).UStrain] = ChickTib.file1(d).StrainNew(R);
end 
% Mean & SD - mech props
props_MeanSD_chicktib = struct('EMean', {},...
    'YSMean', {},...
    'UStrainMean', {},...
    'UStressMean', {},...
    'ESD', {},...
    'YSSD', {},...
    'UStrainSD', {},...
    'UStressSD', {});
    n.EMean = mean([ChickTib.file1.E]);
    n.YSMean = mean([ChickTib.file1.YS]);
    n.UStrainMean = mean([ChickTib.file1.UStrain]);
    n.UStressMean = mean([ChickTib.file1.UStress]);
    n.ESD = std([ChickTib.file1.E]);
    n.YSSD = std([ChickTib.file1.YS]);
    n.UStrainSD = std([ChickTib.file1.UStrain]);
    n.UStressSD = std([ChickTib.file1.UStress]);
    props_MeanSD_chicktib = n; 