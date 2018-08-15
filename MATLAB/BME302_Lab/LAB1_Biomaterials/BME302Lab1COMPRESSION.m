%BME 302 Lab - COMPRESSION
%Mackenzie Marques

clear all
close all 

source_dirC1 = 'C:\Users\Mackenzie\Documents\MATLAB\BME302_Lab\Compression1';
filescomp1 = dir(fullfile(source_dirC1,'*.xlsx'));
source_dirC2 = 'C:\Users\Mackenzie\Documents\MATLAB\BME302_Lab\Compression2';
filescomp2 = dir(fullfile(source_dirC2,'*.xlsx'));

%% Compression 1 - Load and Graph
for j = 1:2
[num,txt,raw] = xlsread(filescomp1(j).name);
name = extractBefore(filescomp1(j).name, '.xlsx');
name = extractAfter(name, 'Master');
name = strrep(name,'-',''); 

numtrials = numel(num(1,:))/2; 
clear SET s 
SET = struct('Material', [],...
    'Diameter', [],...
    'InitialLength', [],...
    'FinalLength', [],...
    'Position', [],...
    'Load', [],...
    'Area', [],...
    'Stress', [],...
    'Strain', []);
for k = 1:numtrials
    i = 2*k-1;
    s.Material = name;
    s.Diameter = num(1,i+1);
    s.InitialLength = num(2,i+1);
    s.FinalLength = num(3,i+1);
    s.Position = abs(num(6:end,i));
    s.Load = abs(num(6:end,i+1));
    s.Position(isnan(s.Position)) = [];
    s.Load(isnan(s.Load)) = [];
    s.Area = pi.*(s.Diameter./2).^2;
    s.Stress = (s.Load)./(s.Area);
    s.Strain = (s.Position)./(s.InitialLength);
    SET(k) = s;
end
compress1.(sprintf('file%d', j))=SET;
end

%% Compression 2 - Load and Graph
for j = 1:2
[num,txt,raw] = xlsread(filescomp2(j).name);
name = extractBefore(filescomp2(j).name, '.xlsx');
name = extractAfter(name, 'Master');
name = strrep(name,'-','');

clear SET s 
SET = struct('Material', {},...
    'InitialWidth1', {},...
    'InitialWidth2', {},...
    'InitialHeight', {},...
    'FinalHeight', {},...
    'Position', {},...
    'Load', {},...
    'Area', {},...
    'Stress', {},...
    'Strain', {});
for k = 1:numtrials
    i = 2*k-1;
    s.Material = name;
    s.InitialWidth1 = num(1,i+1);
    s.InitialWidth2 = num(2,i+1);
    s.InitialHeight = num(3,i+1);
    s.FinalHeight = num(4,i+1);
    s.Position = abs(num(6:end,i));
    s.Load = abs(num(6:end,i+1));
    s.Position(isnan(s.Position)) = [];
    s.Load(isnan(s.Load)) = [];
    s.Area = (s.InitialWidth1).*...
        (s.InitialWidth2);
    s.Stress = (s.Load)./(s.Area);
    s.Strain = (s.Position)./(s.InitialHeight);
    SET(k) = s;
end
compress2.(sprintf('file%d', j))=SET;
end

%% Stress Strain Plots Compression
for c = 1:2
    clf(figure(c+4))
    figure(c+4)
    hold on
for d = 1:numel(compress1.file1)
    [StrainNew, StressNew] = smoothing((compress1.(sprintf('file%d', c))...
        (d).Strain), (compress1.(sprintf('file%d', c))(d).Stress));
    [compress1.(sprintf('file%d', c))(d).StressNew1] = StressNew;
    [compress1.(sprintf('file%d', c))(d).StrainNew1] = StrainNew;
    X = max(compress1.(sprintf('file%d', c))(d).StressNew1);
    Y = find([compress1.(sprintf('file%d', c))(d).StressNew1] == X);
    compress1.(sprintf('file%d', c))(d).StressNew1 = compress1.(sprintf...
        ('file%d', c))(d).StressNew1(1:Y);
    compress1.(sprintf('file%d', c))(d).StrainNew1 = compress1.(sprintf...
        ('file%d', c))(d).StrainNew1(1:Y);
plot(compress1.(sprintf('file%d', c))(d).StrainNew1,...
    compress1.(sprintf('file%d', c))(d).StressNew1, 'o')
xlabel('Strain (mm/mm)');
ylabel('Stress (N/{mm}^2)');
title(['Stress vs. Strain (mlm99) ', compress1.(sprintf('file%d', c))...
    (d).Material])
end
hold off
end

for c = 1:2
    clf(figure(c+6))
    figure(c+6)
    hold on
for d = 1:numel(compress2.file1)
    [StrainNew, StressNew] = smoothing((compress2.(sprintf('file%d', c))...
        (d).Strain), (compress2.(sprintf('file%d', c))(d).Stress));
    [compress2.(sprintf('file%d', c))(d).StressNew1] = StressNew;
    [compress2.(sprintf('file%d', c))(d).StrainNew1] = StrainNew;
    X = max(compress2.(sprintf('file%d', c))(d).StressNew1);
    Y = find([compress2.(sprintf('file%d', c))(d).StressNew1] == X);
    compress2.(sprintf('file%d', c))(d).StressNew1 = compress2.(sprintf...
        ('file%d', c))(d).StressNew1(1:Y);
    compress2.(sprintf('file%d', c))(d).StrainNew1 = compress2.(sprintf...
        ('file%d', c))(d).StrainNew1(1:Y);
    plot(compress2.(sprintf('file%d', c))(d).Strain,...
    compress2.(sprintf('file%d', c))(d).Stress, 'o')
xlabel('Strain (mm/mm)');
ylabel('Stress (N/{mm}^2)');
title(['Stress vs. Strain (mlm99) ', compress2.(sprintf('file%d', c))...
    (d).Material])
end
hold off
end
clear c d 

%% Mean + SD
clear h m
MeanSD_comp1 = struct('DiameterMean', {},...
    'InitialLengthMean', {},...
    'FinalLengthMean', {},...
    'AreaMean', {},...
    'DiameterSD', {},...
    'InitialLengthSD', {},...
    'FinalLengthSD', {},...
    'AreaSD',{});
for h = 1:2 
    m.DiameterMean = mean([compress1.(sprintf('file%d', h)).Diameter]);
    m.InitialLengthMean = mean([compress1.(sprintf('file%d', h))...
        .InitialLength]);
    m.FinalLengthMean = mean([compress1.(sprintf('file%d', h))...
        .FinalLength]);
    m.AreaMean = mean([compress1.(sprintf('file%d', h)).Area]);
    m.DiameterSD = std([compress1.(sprintf('file%d', h)).Diameter]);
    m.InitialLengthSD = std([compress1.(sprintf('file%d', h))...
        .InitialLength]);
    m.FinalLengthSD = std([compress1.(sprintf('file%d', h)).FinalLength]);
    m.AreaSD = std([compress1.(sprintf('file%d', h)).Area]);
    MeanSD_comp1(h) = m;
end

clear h m
MeanSD_comp2 = struct('InitialWidth1Mean', {},...
    'InitialWidth2Mean', {},... 
    'InitialHeightMean', {},...
    'FinalHeightMean', {},...
    'AreaMean', {},...
    'InitialWidth1SD', {},...
    'InitialWidth2SD', {},...
    'InitialHeightSD', {},...
    'FinalHeightSD', {},...
    'AreaSD', {});
for h = 1:2
    m.InitialWidth1Mean = mean([compress2.(sprintf('file%d', h))...
        .InitialWidth1]);
    m.InitialWidth2Mean = mean([compress2.(sprintf('file%d', h))...
        .InitialWidth2]);
    m.InitialHeightMean = mean([compress2.(sprintf('file%d', h))...
        .InitialHeight]);
    m.FinalHeightMean = mean([compress2.(sprintf('file%d', h))...
        .FinalHeight]);
    m.AreaMean = mean([compress2.(sprintf('file%d', h)).Area]);
    m.InitialWidth1SD = std([compress2.(sprintf('file%d', h))...
        .InitialWidth1]);
    m.InitialWidth2SD = std([compress2.(sprintf('file%d', h))...
        .InitialWidth2]);
    m.InitialHeightSD = std([compress2.(sprintf('file%d', h))...
        .InitialHeight]);
    m.FinalHeightSD = std([compress2.(sprintf('file%d', h))...
        .FinalHeight]);
    m.AreaSD = std([compress2.(sprintf('file%d', h)).Area]);
    MeanSD_comp2 (h) = m;
end