%BME 302 Lab - TENSILE 
%Mackenzie Marques

clear all
close all

source_dirT = 'C:\Users\Mackenzie\Documents\MATLAB\BME302_Lab\Tension';
filestens = dir(fullfile(source_dirT,'*.xlsx'));

%% Load and Graph Raw Data
for j = 1:4
[num,txt,raw] = xlsread(filestens(j).name);
name = extractBefore(filestens(j).name, '.xlsx');
name = extractAfter(name, 'Master');
name = strrep(name,'-','');

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
    s.Area = (s.Thickness).*(s.Width);
    s.Position(isnan(s.Position)) = [];
    s.Load(isnan(s.Load)) = [];
    s.Stress = (s.Load)./(s.Area);
    s.Strain = (s.Position)./(s.GageLength);
    SET(k) = s;
end 
%j
tensile.(sprintf('file%d', j))=SET;
end

%% Stress Strain Plots
clear c d i
for c = 1:4
    clf(figure(c))
    figure(c)
    hold on
for d = 1:numel(tensile.file1)
    %StressNew1 = smooth([tensile.(sprintf('file%d', c))(d).Strain],...
    %[tensile.(sprintf('file%d', c))(d).Stress], 0.1,'rloess');
    %fracture removal
    [StrainNew, StressNew] = smoothing((tensile.(sprintf('file%d', c))...
        (d).Strain), (tensile.(sprintf('file%d', c))(d).Stress));
    [tensile.(sprintf('file%d', c))(d).StressNew1] = StressNew;
    [tensile.(sprintf('file%d', c))(d).StrainNew1] = StrainNew;
    X = max(tensile.(sprintf('file%d', c))(d).StressNew1);
    Y = find([tensile.(sprintf('file%d', c))(d).StressNew1] == X);
    tensile.(sprintf('file%d', c))(d).StressNew1 = tensile.(sprintf...
        ('file%d', c))(d).StressNew1(1:Y);
    tensile.(sprintf('file%d', c))(d).StrainNew1 = tensile.(sprintf...
        ('file%d', c))(d).StrainNew1(1:Y);
    %toe regions
    Z = find([tensile.file1(d).StressNew1] < 5);
    ZZ = max(Z);
    tensile.file1(d).StressNew1 = tensile.file1(d).StressNew1(ZZ:end);
    tensile.file1(d).StrainNew1 = tensile.file1(d).StrainNew1(ZZ:end);
    %P = find([tensile.file4(d).StressNew1] < 1);
    %PP = max(P);
    %tensile.file4(d).StressNew1 = tensile.file4(d).StressNew1(PP:end);
    %tensile.file4(d).StrainNew1 = tensile.file4(d).StrainNew1(PP:end);
    xlabel('Strain (mm/mm)');
    ylabel('Stress (N/{mm}^2)');
    title(['Stress vs. Strain (mlm99) ', tensile.(sprintf('file%d', c))(d).Material])
    plot(tensile.(sprintf('file%d', c))(d).StrainNew1,...
    tensile.(sprintf('file%d', c))(d).StressNew1, 'o');
end
end
hold off
%%
clear c d
for c=1:4
    for d=1:numel(tensile.file1)
        y = [tensile.(sprintf('file%d', c))(d).StressNew1];
        x = tensile.(sprintf('file%d', c))(d).StrainNew1;
        dStressdStrain = diff(y)./diff(x);
        [tensile.(sprintf('file%d', c))(d).Deriv] = dStressdStrain;
    end
end
    %dStress = diff([tensile.file1.StressNew1]);
    %StressNew2 = diff(tensile.(sprintf('file%d', c))(d).StressNew1);
for a = 1:4
    for b = 1:numel(tensile.file1)
        
    end 
end

%% Mean + SD
clear h m 
MeanSD_tens = struct('GageLengthMean', {},...
    'ThicknessMean', {},...
    'WidthMean', {},...
    'AreaMean', {},...
    'GageLengthSD', {},...
    'ThicknessSD', {},...
    'WidthSD', {},...
    'AreaSD',{});
for h = 1:4
    m.GageLengthMean = mean([tensile.(sprintf('file%d', h)).GageLength]);
    m.ThicknessMean = mean([tensile.(sprintf('file%d', h)).Thickness]);
    m.WidthMean = mean([tensile.(sprintf('file%d', h)).Width]);
    m.AreaMean = mean([tensile.(sprintf('file%d', h)).Area]);
    m.GageLengthSD = std([tensile.(sprintf('file%d', h)).GageLength]);
    m.ThicknessSD = std([tensile.(sprintf('file%d', h)).Thickness]);
    m.WidthSD = std([tensile.(sprintf('file%d', h)).Width]);
    m.AreaSD = std([tensile.(sprintf('file%d', h)).Area]);
    MeanSD_tens(h) = m;
end