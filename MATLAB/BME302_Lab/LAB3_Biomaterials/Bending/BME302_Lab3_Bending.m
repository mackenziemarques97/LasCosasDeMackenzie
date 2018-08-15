%BME 302, Lab 3, Tissue Testing - BENDING
%Mackenzie Marques 
clear all 
close all
%% Load Data
source_dirBend = 'C:\Users\Mackenzie\Documents\MATLAB\BME302_Lab\LAB3\Bending';
BendFile = dir(fullfile(source_dirBend,'*.xlsx'));
for j = 1:2
    [num,txt,raw] = xlsread(BendFile(j).name);
    name = extractBefore(BendFile(j).name, '.xlsx');
    name = strrep(name,'1',''); 
    numtrials = numel(num(1,:))/2;  
SET = struct('Material', {},...
    'GageLength', {},...
    'Thickness', {},...
    'Width', {},...
    'Area', {},...
    'Position', {},...
    'Load', {});
for k = 1:numtrials
    i = 2*k-1;
    s.Material = name;
    s.GageLength = num(1,i+1);
    s.Thickness = num(2,i+1);
    s.Width = num(3,i+1);
    s.Area = num(4,i+1);
    s.Position = num(8:end,i);
    s.Load = num(8:end,i+1);
    s.Position(isnan(s.Position)) = [];
    s.Load(isnan(s.Load)) = [];
    SET(k) = s;
end 
Bend.(sprintf('file%d', j))=SET;
end
clear h m 
for d = 1:numel(Bend.file1)
    [Bend.file1(d).Stress] = (3.*(Bend.file1(d).Load).*70)./(2.*(Bend.file1(d).Width).*(Bend.file1(d).Thickness).^2);
    [Bend.file1(d).Strain] = (6.*(Bend.file1(d).Position).*(Bend.file1(d).Thickness))./(70^2);
end
for d = 1:numel(Bend.file2)
    [Bend.file2(d).Stress] = (3.*(Bend.file2(d).Load).*20)./(2.*(Bend.file2(d).Width).*(Bend.file2(d).Thickness).^2);
    [Bend.file2(d).Strain] = (6.*(Bend.file2(d).Position).*(Bend.file2(d).Thickness))./(20^2);
end
%% Mean + Sd for measurements 
MeanSD_bend = struct('GageLengthMean', {},...
    'ThicknessMean', {},...
    'WidthMean', {},...
    'AreaMean', {},...
    'GageLengthSD', {},...
    'ThicknessSD', {},...
    'WidthSD', {},...
    'AreaSD',{});
for h = 1:2
    m.GageLengthMean = mean([Bend.(sprintf('file%d', h)).GageLength]);
    m.ThicknessMean = mean([Bend.(sprintf('file%d', h)).Thickness]);
    m.WidthMean = mean([Bend.(sprintf('file%d', h)).Width]);
    m.AreaMean = mean([Bend.(sprintf('file%d', h)).Area]);
    m.GageLengthSD = std([Bend.(sprintf('file%d', h)).GageLength]);
    m.ThicknessSD = std([Bend.(sprintf('file%d', h)).Thickness]);
    m.WidthSD = std([Bend.(sprintf('file%d', h)).Width]);
    m.AreaSD = std([Bend.(sprintf('file%d', h)).Area]);
    MeanSD_bend(h) = m;
end
%% Stress Strain Plots - file1
    clf(figure(1))
    figure(1)
    for d = 1:numel(Bend.file1)
        StressNew = downsample(Bend.file1(d).Stress, 8);
        StrainNew = downsample(Bend.file1(d).Strain, 8);
        [Bend.file1(d).StressNew] = StressNew;
        [Bend.file1(d).StrainNew] = StrainNew;
        [Pks, Locs] = findpeaks(Bend.file1(d).StressNew);
        if length(Bend.file1(d).StrainNew) >= Locs(end)
            Bend.file1(d).StrainNew(Locs(end):end) = [];
            Bend.file1(d).StressNew(Locs(end):end) = [];
        end 
        Bend.file1(d).StressNew = smooth((Bend.file1(d).StrainNew), (Bend.file1(d).StressNew),0.1, 'loess');
        %[StrainNew, StressNew] = smoothing((Bend.(sprintf('file%d', c))(d).Strain), (Bend.(sprintf('file%d', c))(d).Stress));
        [Bend.file1(d).diff] = diff(Bend.file1(d).StressNew)./diff(Bend.file1(d).StrainNew);
        [Bend.file1(d).diff2] = diff(Bend.file1(d).diff)./diff(Bend.file1(d).StrainNew(2:end));
        %subplot(2,2,1)
        hold on
        %plot(Bend.file1(d).Strain, Bend.file1(d).Stress);
        xlabel('Strain (mm/mm)');
        ylabel('Stress (N/{mm}^2)');
        title(['Noisy Stress vs. Strain ', Bend.file1(d).Material]);
        xlim([0 0.25]);
        ylim([0 50]);
        hold off
        %subplot(2,2,2)
        hold on
        plot(Bend.file1(d).StrainNew, Bend.file1(d).StressNew);
        title(['Cleaned Stress vs. Strain ', Bend.file1(d).Material]);
        hold off
    end 
    %clf(figure(3))
    %figure(3)
    %plot(Bend.file1(7).Strain, Bend.file1(7).Stress, Bend.file1(7).StrainNew, Bend.file1(7).StressNew); 
clear d c f 
P = zeros(1,20);
E = zeros(1,10);
YieldStress = zeros(1,10);
    for d = 1:numel(Bend.file1)         
        keepgoing = true;
        f = 1;
        Window = 30;
        while (f+Window < numel(Bend.file1(d).StrainNew)) && keepgoing
            R = corr(Bend.file1(d).StrainNew(f:f+Window), Bend.file1(d).StressNew(f:f+Window));
            if R > 0.97
                keepgoing = true;
                f = f+Window;
            else
                keepgoing = false;
                X = Bend.file1(d).StrainNew(1:f+Window);
                Y = Bend.file1(d).StressNew(1:f+Window);
                %U = find(abs(Bend.file1(d).diff(1:f+Window)) <= 1);
                YieldStress(d) = Bend.file1(d).StressNew(round(0.98*(f+Window)));
                for c = 2*d-1 
                P(c:c+1) = polyfit(X, Y, 1);
                E(d) = abs(P(c));
                end 
            end
        end 
    [Bend.file1(d).E] = E(d);
    [Bend.file1(d).YS] = YieldStress(d);
    [Bend.file1(d).UStress] = max(Bend.file1(d).StressNew);
    R = find(Bend.file1(d).StressNew == max(Bend.file1(d).StressNew));
    [Bend.file1(d).UStrain] = Bend.file1(d).StrainNew(R);
    end     
H = find(E == 0);
for d = H
   YieldStress(d) = Bend.file1(d).StressNew(end);
   for c = 2*d-1 
   P(c:c+1) = polyfit(Bend.file1(d).StrainNew, Bend.file1(d).StressNew, 1);
   E(d) = P(c);
   end 
   [Bend.file1(d).E] = E(d);
   [Bend.file1(d).YS] = YieldStress(d);
   [Bend.file1(d).UStress] = max(Bend.file1(d).StressNew);
   R = find(Bend.file1(d).StressNew == max(Bend.file1(d).StressNew));
   [Bend.file1(d).UStrain] = Bend.file1(d).StrainNew(R);
end 
% Mean & SD - mech props
props_MeanSD_bend1 = struct('EMean', {},...
    'YSMean', {},...
    'UStrainMean', {},...
    'UStressMean', {},...
    'ESD', {},...
    'YSSD', {},...
    'UStrainSD', {},...
    'UStressSD', {});
    n.EMean = mean([Bend.file1.E]);
    n.YSMean = mean([Bend.file1.YS]);
    n.UStrainMean = mean([Bend.file1.UStrain]);
    n.UStressMean = mean([Bend.file1.UStress]);
    n.ESD = std([Bend.file1.E]);
    n.YSSD = std([Bend.file1.YS]);
    n.UStrainSD = std([Bend.file1.UStrain]);
    n.UStressSD = std([Bend.file1.UStress]);
    props_MeanSD_bend1 = n;    
    %% Stress Strain Plots - file2
    clf(figure(2))
    figure(2)
    for d = 1:numel(Bend.file2)
        StressNew = downsample(Bend.file2(d).Stress, 5);
        StrainNew = downsample(Bend.file2(d).Strain, 5);
        [Bend.file2(d).StressNew] = StressNew;
        [Bend.file2(d).StrainNew] = StrainNew;
        [Pks, Locs] = findpeaks(Bend.file2(d).StressNew);
        if length(Bend.file2(d).StrainNew) >= Locs(end)
            Bend.file2(d).StrainNew(Locs(end):end) = [];
            Bend.file2(d).StressNew(Locs(end):end) = [];
        end 
        F = find(round(Bend.file2(d).StressNew, 2) == 0);
        Bend.file2(d).StrainNew(F) = [];
        Bend.file2(d).StressNew(F) = [];
        Bend.file2(d).StressNew = smooth((Bend.file2(d).StrainNew), (Bend.file2(d).StressNew),0.1, 'loess');
        %[StrainNew, StressNew] = smoothing((Bend.(sprintf('file%d', c))(d).Strain), (Bend.(sprintf('file%d', c))(d).Stress));
        [Bend.file2(d).diff] = diff(Bend.file2(d).StressNew)./diff(Bend.file2(d).StrainNew);
        [Bend.file2(d).diff2] = diff(Bend.file2(d).diff)./diff(Bend.file2(d).StrainNew(2:end));
        %subplot(2,2,1)
        hold on
        %plot(Bend.file2(d).Strain, Bend.file2(d).Stress);
        xlabel('Strain (mm/mm)');
        ylabel('Stress (N/{mm}^2)');
        title(['Noisy Stress vs. Strain ', Bend.file2(d).Material]);
        hold off
        %subplot(2,2,2)
        hold on
        plot(Bend.file2(d).StrainNew, Bend.file2(d).StressNew);
        title(['Cleaned Stress vs. Strain ', Bend.file2(d).Material]);
        hold off
    end 
    %clf(figure(4))
    %figure(4)
    %plot(Bend.file2(7).Strain, Bend.file2(7).Stress, Bend.file2(7).StrainNew, Bend.file2(7).StressNew);
clear d c f 
P = zeros(1,24);
E = zeros(1,12);
YieldStress = zeros(1,12);
    for d = 1:numel(Bend.file2)         
        keepgoing = true;
        f = 100;
        Window = 3;
        while (f+Window < numel(Bend.file2(d).StrainNew)) && keepgoing
            R = corr(Bend.file2(d).StrainNew(f:f+Window), Bend.file2(d).StressNew(f:f+Window));
            if R > 0.97
                keepgoing = true;
                f = f+Window;
            else
                keepgoing = false;
                X = Bend.file2(d).StrainNew(1:f+Window);
                Y = Bend.file2(d).StressNew(1:f+Window);
                YieldStress(d) = Bend.file2(d).StressNew(f+Window);
                for c = 2*d-1 
                P(c:c+1) = polyfit(X, Y, 1);
                E(d) = abs(P(c));
                end 
            end
        end 
    [Bend.file2(d).E] = E(d);
    [Bend.file2(d).YS] = YieldStress(d); 
    [Bend.file2(d).UStress] = max(Bend.file2(d).StressNew);
    R = find(Bend.file2(d).StressNew == max(Bend.file2(d).StressNew));
    [Bend.file2(d).UStrain] = Bend.file2(d).StrainNew(R);
    end     
H = find(E == 0);
for d = H
   YieldStress(d) = Bend.file2(d).StressNew(end);
   for c = 2*d-1 
   P(c:c+1) = polyfit(Bend.file2(d).StrainNew, Bend.file2(d).StressNew, 1);
   E(d) = P(c);
   end 
   [Bend.file2(d).E] = E(d);
   [Bend.file2(d).YS] = YieldStress(d);
   [Bend.file2(d).UStress] = max(Bend.file2(d).StressNew);
   R = find(Bend.file2(d).StressNew == max(Bend.file2(d).StressNew));
   [Bend.file2(d).UStrain] = Bend.file2(d).StrainNew(R);
end 
% Mean & SD - mech props
props_MeanSD_bend2 = struct('EMean', {},...
    'YSMean', {},...
    'UStrainMean', {},...
    'UStressMean', {},...
    'ESD', {},...
    'YSSD', {},...
    'UStrainSD', {},...
    'UStressSD', {});
    n.EMean = mean([Bend.file2.E]);
    n.YSMean = mean([Bend.file2.YS]);
    n.UStrainMean = mean([Bend.file2.UStrain]);
    n.UStressMean = mean([Bend.file2.UStress]);
    n.ESD = std([Bend.file2.E]);
    n.YSSD = std([Bend.file2.YS]);
    n.UStrainSD = std([Bend.file2.UStrain]);
    n.UStressSD = std([Bend.file2.UStress]);
    props_MeanSD_bend2 = n;