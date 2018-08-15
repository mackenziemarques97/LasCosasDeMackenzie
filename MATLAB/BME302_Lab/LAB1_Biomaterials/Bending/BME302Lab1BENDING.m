%BME 302 Lab - BENDING
%Mackenzie Marques

clear all
close all

source_dirB = 'C:\Users\Mackenzie\Documents\MATLAB\BME302_Lab\Lab1\Bending';
filesbend = dir(fullfile(source_dirB,'*.xlsx'));

%% Bending (excluding titanium 1.6mm) - Load and Graph
for j = 1:5
[num,txt,raw] = xlsread(filesbend(j).name);
name = extractBefore(filesbend(j).name, '.xlsx');
name = extractAfter(name, 'Master');
name = strrep(name,'-','');

clear SET s 
numtrials = numel(num(1,:))/2;  
SET = struct('Material', {},...
    'GageLength', {},...
    'Thickness', {},...
    'Width', {},...
    'Position', {},...
    'Load', {},...
    'Area',{},...
    'Stress', {},...
    'Strain', {});
for k = 1:numtrials
    i = 2*k-1;
    s.Material = name;
    s.GageLength = num(1,i+1);
    s.Thickness = num(2,i+1);
    s.Width = num(3,i+1);
    s.Position = num(6:end,i);
    s.Load = num(6:end,i+1);
    s.Position(isnan(s.Position)) = [];
    s.Load(isnan(s.Load)) = [];
    s.Area = (s.Width).*(s.Thickness);
    s.Stress = (3.*(s.Load).*(s.GageLength))./...
        (2.*(s.Width).*(s.Thickness).^2);
    s.Strain = (6.*(s.Position).*(s.Thickness))./...
        ((s.GageLength).^2);
    SET(k) = s;
end 
bend.(sprintf('file%d', j))=SET;
end

%% Bending for titanium 1.6mm 
[num,txt,raw] = xlsread('Master-Titanium1.6mm.xlsx');
name = extractBefore('Master-Titanium1.6mm.xlsx', '.xlsx');
name = extractAfter(name, 'Master');
name = strrep(name,'-','');

clear SET s 
numtrials = numel(num(1,:))/2;  
SET = struct('Material', {},...
    'GageLength', {},...
    'Thickness', {},...
    'Width', {},...
    'Position', {},...
    'Load', {},...
    'Area', {},...
    'Stress', {},...
    'Strain', {});
for k = 1:numtrials
    i = 2*k-1;
    s.Material = name;
    s.GageLength = num(1,i+1);
    s.Thickness = num(2,i+1);
    s.Width = num(3,i+1);
    s.Position = num(6:end,i);
    s.Load = num(6:end,i+1);
    s.Area = (s.Width).*(s.Thickness);
    s.Position(isnan(s.Position)) = [];
    s.Load(isnan(s.Load)) = [];
    s.Stress = (3.*(s.Load).*(s.GageLength))./...
        (2.*(s.Width).*(s.Thickness).^2);
    s.Strain = (6.*(s.Position).*(s.Thickness))./...
        ((s.GageLength).^2);
    SET(k) = s;
end 
bendtit16 = SET;

%% Stress Strain Plots Bending
for c = 1:5
    clf(figure(c+8))
    figure(c+8)
    hold on
for d = 1:numel(bend.file1)
    [StrainNew, StressNew] = smoothing((bend.(sprintf('file%d', c))(d).Strain), (bend.(sprintf('file%d', c))(d).Stress));
    [bend.(sprintf('file%d', c))(d).StressNew1] = StressNew;
    [bend.(sprintf('file%d', c))(d).StrainNew1] = StrainNew;
    X = max(bend.(sprintf('file%d', c))(d).StressNew1);
    Y = find([bend.(sprintf('file%d', c))(d).StressNew1] == X);
    bend.(sprintf('file%d', c))(d).StressNew1 = bend.(sprintf...
        ('file%d', c))(d).StressNew1(1:Y);
    bend.(sprintf('file%d', c))(d).StrainNew1 = bend.(sprintf...
        ('file%d', c))(d).StrainNew1(1:Y);
    %Z = find([bend.file5(d).StressNew1] < 12);
    %ZZ = max(Z);
    %bend.file5(d).StressNew1 = bend.file5(d).StressNew1(ZZ:end);
    %bend.file5(d).StrainNew1 = bend.file5(d).StrainNew1(ZZ:end);
plot(bend.(sprintf('file%d', c))(d).StrainNew1,...
    bend.(sprintf('file%d', c))(d).StressNew1, 'o')
xlabel('Strain (mm/mm)');
ylabel('Stress (N/{mm}^2)');
%title(['Stress vs. Strain (mlm99) ', bend.(sprintf('file%d', c))
    %(d).Material])
end
hold off
end

clear c
clf(figure(14))
figure(14)
hold on
for c = 1:numel(bendtit16)
plot(bendtit16(c).Strain, bendtit16(c).Stress, 'o')
xlabel('Strain (mm/mm)');
ylabel('Stress (N/{mm}^2)');
title(['Stress vs. Strain (mlm99) ', bendtit16(c).Material])
end
hold off

clear h m
MeanSD_bend = struct('GageLengthMean', {},...
    'ThicknessMean', {},...
    'WidthMean', {},...
    'AreaMean', {},...
    'GageLengthSD', {},...
    'ThicknessSD', {},...
    'WidthSD', {},...
    'AreaSD',{});
for h = 1:5
    m.GageLengthMean = mean([bend.(sprintf('file%d', h)).GageLength]);
    m.ThicknessMean = mean([bend.(sprintf('file%d', h)).Thickness]);
    m.WidthMean = mean([bend.(sprintf('file%d', h)).Width]);
    m.AreaMean = mean([bend.(sprintf('file%d', h)).Area]);
    m.GageLengthSD = std([bend.(sprintf('file%d', h)).GageLength]);
    m.ThicknessSD = std([bend.(sprintf('file%d', h)).Thickness]);
    m.WidthSD = std([bend.(sprintf('file%d', h)).Width]);
    m.AreaSD = std([bend.(sprintf('file%d', h)).Area]);
    MeanSD_bend(h) = m;
end

clear h m
MeanSD_bendtit16 = struct('GageLengthMean', {},...
    'ThicknessMean', {},...
    'WidthMean', {},...
    'AreaMean', {},...
    'GageLengthSD', {},...
    'ThicknessSD', {},...
    'WidthSD', {},...
    'AreaSD',{});
    m.GageLengthMean = mean([bendtit16.GageLength]);
    m.ThicknessMean = mean([bendtit16.Thickness]);
    m.WidthMean = mean([bendtit16.Width]);
    m.AreaMean = mean([bendtit16.Area]);
    m.GageLengthSD = std([bendtit16.GageLength]);
    m.ThicknessSD = std([bendtit16.Thickness]);
    m.WidthSD = std([bendtit16.Width]);
    m.AreaSD = std([bendtit16.Area]);
    MeanSD_bendtit16 = m;
    
    %% 
    clear d c f 
P = zeros(1,20);
E = zeros(1,10);
YieldStress = zeros(1,10);
    for d = 1:10        
        keepgoing = true;
        f = 3000;
        Window = 3;
        while (f+Window < numel(bendtit16(d).Strain)) && keepgoing
            R = corr(bendtit16(d).Strain(f:f+Window), bendtit16(d).Stress(f:f+Window));
            if R > 0.97
                keepgoing = true;
                f = f+Window;
            else
                keepgoing = false;
                X = bendtit16(d).Strain(1:f+Window);
                Y = bendtit16(d).Stress(1:f+Window);
                YieldStress(d) = bendtit16(d).Stress(f+Window);
                for c = 2*d-1 
                P(c:c+1) = polyfit(X, Y, 1);
                E(d) = abs(P(c));
                end 
            end
        end 
    [bendtit16(d).E] = E(d);
    [bendtit16(d).YS] = YieldStress(d); 
    [bendtit16(d).UStress] = max(bendtit16(d).Stress);
    R = find(bendtit16(d).Stress == max(bendtit16(d).Stress));
    [bendtit16(d).UStrain] = bendtit16(d).Strain(R);
    end     
H = find(E == 0);
for d = H
   YieldStress(d) = bendtit16.Stress(end);
   for c = 2*d-1 
   P(c:c+1) = polyfit(bendtit16.Strain, bendtit16.Stress, 1);
   E(d) = P(c);
   end 
   [bendtit16.E] = E(d);
   [bendtit16.YS] = YieldStress(d);
   [bendtit16.UStress] = max(bendtit16.StressNew);
   R = find(bendtit16.StressNew == max(bendtit16.StressNew));
   [bendtit16.UStrain] = bendtit16.StrainNew(R);
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
    n.EMean = mean([bendtit16.E]);
    n.YSMean = mean([bendtit16.YS]);
    n.UStrainMean = mean([bendtit16.UStrain]);
    n.UStressMean = mean([bendtit16.UStress]);
    n.ESD = std([bendtit16.E]);
    n.YSSD = std([bendtit16.YS]);
    n.UStrainSD = std([bendtit16.UStrain]);
    n.UStressSD = std([bendtit16.UStress]);
    props_MeanSD_bend2 = n;