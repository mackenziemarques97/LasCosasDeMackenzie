%%BME 302 Lab 1 
%Mackenzie Marques
%% Load Data
clear all
close all

source_dirT = 'C:\Program Files\MATLAB\R2017b\bin\Tension';
filestens = dir(fullfile(source_dirT,'*.xlsx'));
source_dirC1 = 'C:\Program Files\MATLAB\R2017b\bin\Compression1';
filescomp1 = dir(fullfile(source_dirC1,'*.xlsx'));
source_dirC2 = 'C:\Program Files\MATLAB\R2017b\bin\Compression2';
filescomp2 = dir(fullfile(source_dirC2,'*.xlsx'));
source_dirB = 'C:\Program Files\MATLAB\R2017b\bin\Bending';
filesbend = dir(fullfile(source_dirB,'*.xlsx'));

%% Tension Tests - Load and Graph
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

%% Compression 1 - Load and Graph
for j = 1:2
[num,txt,raw] = xlsread(filescomp1(j).name);
name = extractBefore(filescomp1(j).name, '.xlsx');
name = extractAfter(name, 'Master');
name = strrep(name,'-',''); 

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

%Bending for titanium 1.6mm 
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
%% 


%% Stress Strain Plots
%Tension
for c = 1:4
    clf(figure(c))
    figure(c)
    hold on
for d = 1:numel(tensile.file1)
    %if numel([tensile.(sprintf('file%d', c))(d).Stress]) > 100
        %StressNew1 = downsample([tensile.(sprintf('file%d', c))(d).Stress], 50);
        %StrainNew1 = downsample([tensile.(sprintf('file%d', c))(d).Strain], 50); 
    %else 
        %StressNew1 = downsample([tensile.(sprintf('file%d', c))(d).Stress], 20);
        %StrainNew1 = downsample([tensile.(sprintf('file%d', c))(d).Strain], 20);  
    %end
    %[tensile.(sprintf('file%d', c))(d).StressNew1] = StressNew1;
    %[tensile.(sprintf('file%d', c))(d).StrainNew1] = StrainNew1;
    %if tensile.(sprintf('file%d', c))(d).StressNew1 
    %StressNew2 = diff(tensile.(sprintf('file%d', c))(d).StressNew1);
    plot(tensile.(sprintf('file%d', c))(d).Strain,...
    tensile.(sprintf('file%d', c))(d).Stress, 'o');
    xlabel('Strain (mm/mm)');
    ylabel('Stress (N/{mm}^2)');
    title(['Stress vs. Strain (mlm99) ', tensile.(sprintf('file%d', c))(d).Material])
    %plot(tensile.(sprintf('file%d', c))(d).StrainNew1,...
    %tensile.(sprintf('file%d', c))(d).StressNew1);
end
hold off
end
clear c d 

%% Compression
for c = 1:2
    clf(figure(c+4))
    figure(c+4)
    hold on
for d = 1:numel(compress1.file1)
plot(compress1.(sprintf('file%d', c))(d).Strain,...
    compress1.(sprintf('file%d', c))(d).Stress, 'o')
xlabel('Strain (mm/mm)');
ylabel('Stress (N/{mm}^2)');
title(['Stress vs. Strain (mlm99) ', compress1.(sprintf('file%d', c))(d).Material])
end
hold off
end

for c = 1:2
    clf(figure(c+6))
    figure(c+6)
    hold on
for d = 1:numel(compress2.file1)
plot(compress2.(sprintf('file%d', c))(d).Strain,...
    compress2.(sprintf('file%d', c))(d).Stress, 'o')
xlabel('Strain (mm/mm)');
ylabel('Stress (N/{mm}^2)');
title(['Stress vs. Strain (mlm99) ', compress2.(sprintf('file%d', c))(d).Material])
end
hold off
end
clear c d 

%% Bending
for c = 1:5
    clf(figure(c+8))
    figure(c+8)
    hold on
for d = 1:numel(bend.file1)
plot(bend.(sprintf('file%d', c))(d).Strain,...
    bend.(sprintf('file%d', c))(d).Stress, 'o')
xlabel('Strain (mm/mm)');
ylabel('Stress (N/{mm}^2)');
title(['Stress vs. Strain (mlm99) ', bend.(sprintf('file%d', c))(d).Material])
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
    m.InitialLengthMean = mean([compress1.(sprintf('file%d', h)).InitialLength]);
    m.FinalLengthMean = mean([compress1.(sprintf('file%d', h)).FinalLength]);
    m.AreaMean = mean([compress1.(sprintf('file%d', h)).Area]);
    m.DiameterSD = std([compress1.(sprintf('file%d', h)).Diameter]);
    m.InitialLengthSD = std([compress1.(sprintf('file%d', h)).InitialLength]);
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
    m.InitialWidth1Mean = mean([compress2.(sprintf('file%d', h)).InitialWidth1]);
    m.InitialWidth2Mean = mean([compress2.(sprintf('file%d', h)).InitialWidth2]);
    m.InitialHeightMean = mean([compress2.(sprintf('file%d', h)).InitialHeight]);
    m.FinalHeightMean = mean([compress2.(sprintf('file%d', h)).FinalHeight]);
    m.AreaMean = mean([compress2.(sprintf('file%d', h)).Area]);
    m.InitialWidth1SD = std([compress2.(sprintf('file%d', h)).InitialWidth1]);
    m.InitialWidth2SD = std([compress2.(sprintf('file%d', h)).InitialWidth2]);
    m.InitialHeightSD = std([compress2.(sprintf('file%d', h)).InitialHeight]);
    m.FinalHeightSD = std([compress2.(sprintf('file%d', h)).FinalHeight]);
    m.AreaSD = std([compress2.(sprintf('file%d', h)).Area]);
    MeanSD_comp2 (h) = m;
end

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
%% Calculation of mechanical propeties

