%%BME 302 Lab 1 
%Mackenzie Marques
%% Load Data

clear all
close all

source_dirT = 'C:\Program Files\MATLAB\R2017b\bin\Tension';
filestens = dir(fullfile(source_dirT,'*.xlsx'));
source_dirC = 'C:\Program Files\MATLAB\R2017b\bin\Compression';
filescomp = dir(fullfile(source_dirC,'*.xlsx'));
source_dirB = 'C:\Program Files\MATLAB\R2017b\bin\Bending';
filesbend = dir(fullfile(source_dirB,'*.xlsx'));

%% Tension
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
    s.Position = num(6:end,i+1);
    s.Load = num(6:end,i);
    s.Area = (s.Thickness).*(s.Width);
    s.Stress = (s.Load)./(s.Area);
    s.Strain = (s.Position)./(s.GageLength);
    SET(k) = s;
end 
j
tensile.(sprintf('file%d', j))=SET;
end

%% Compression
for j = 1:4
[num,txt,raw] = xlsread(filescomp(j).name);
name = extractBefore(filescomp(j).name, '.xlsx');
name = extractAfter(name, 'Master');
name = strrep(name,'-','');
clear SET, s
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
    s.Position = num(6:end,i+1);
    s.Load = num(6:end,i);
    s.Area = 0;
    s.Stress = 0;
    s.Strain = 0;
    SET(k) = s;
end 
j
compress.(sprintf('file%d', j))=SET;
end

%% Bending

for j = 1:6
[num,txt,raw] = xlsread(filesbend(j).name);
name = extractBefore(filesbend(j).name, '.xlsx');
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
    s.Position = num(6:end,i+1);
    s.Load = num(6:end,i);
    s.Area = (s.Thickness).*(s.Width);
    s.Stress = (s.Load)./(s.Area);
    s.Strain = (s.Position)./(s.GageLength);
    SET(k) = s;
end 
j
bend.(sprintf('file%d', j))=SET;
end