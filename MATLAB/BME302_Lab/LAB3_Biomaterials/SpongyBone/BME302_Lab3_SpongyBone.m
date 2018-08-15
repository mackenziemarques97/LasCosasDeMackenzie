%BME 302, Lab 3, Tissue Testing - Spongy Bone (Compression)
%Mackenzie Marques 
clear all 
close all
%% Load Data
source_dirComp2 = 'C:\Users\Mackenzie\Documents\MATLAB\BME302_Lab\LAB3\SpongyBone';
CompFile2 = dir(fullfile(source_dirComp2,'*.xlsx'));
for j = 1
    [num,txt,raw] = xlsread(CompFile2(j).name);
    name = extractBefore(CompFile2(j).name, '.xlsx');
    name = strrep(name,'1','');    
    numtrials = numel(num(1,:))/2;  
SET = struct('Material', {},...
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
    s.OuterDiameter = num(1,i+1);
    s.InitialLength = num(2,i+1);
    s.FinalLength = num(3,i+1);
    s.Area = pi.*(s.OuterDiameter./2).^2;
    s.Position = abs(num(8:end,i));
    s.Load = abs(num(8:end,i+1));
    s.Position(isnan(s.Position)) = [];
    s.Load(isnan(s.Load)) = [];
    s.Stress = (s.Load)./(s.Area);
    s.Strain = (s.Position)./(s.InitialLength);
    SET(k) = s;
end 
Spongy.(sprintf('file%d', j))=SET;
end
%% Mean + SD of measuremnts 
MeanSD_spong = struct('OutDMean', {},...
    'InitialLengthMean', {},...
    'FinalLengthMean', {},...
    'AreaMean', {},...
    'OutDSD', {},...
    'InitialLengthSD', {},...
    'FinalLengthSD', {},...
    'AreaSD',{});
    m.OutDMean = mean([Spongy.file1.OuterDiameter]);
    m.InitialLengthMean = mean([Spongy.file1.InitialLength]);
    m.FinalLengthMean = mean([Spongy.file1.FinalLength]);
    m.AreaMean = mean([Spongy.file1.Area]);
    m.OutDSD = std([Spongy.file1.OuterDiameter]);
    m.InitialLengthSD = std([Spongy.file1.InitialLength]);
    m.FinalLengthSD = std([Spongy.file1.FinalLength]);
    m.AreaSD = std([Spongy.file1.Area]);
    MeanSD_spong = m;
%% Stress Strain Plots
clf(figure(1))
figure(1)
    for d = 1:numel(Spongy.file1) 
        StressNew = downsample(Spongy.file1(d).Stress, 2);
        StrainNew = downsample(Spongy.file1(d).Strain, 2);
        [Spongy.file1(d).StrainNew] = StrainNew;
        [Spongy.file1(d).StressNew] = StressNew;
        [Pks, Locs] = findpeaks(Spongy.file1(d).StressNew);
        if length(Spongy.file1(d).StrainNew) >= Locs(end)
            Spongy.file1(d).StrainNew(Locs(end):end) = [];
            Spongy.file1(d).StressNew(Locs(end):end) = [];
        end 
        F = find(round(Spongy.file1(d).StressNew, 2) == 0);
        Spongy.file1(d).StrainNew(F) = [];
        Spongy.file1(d).StressNew(F) = [];    
        Spongy.file1(d).StressNew = smooth((Spongy.file1(d).StrainNew), (Spongy.file1(d).StressNew),0.1);
        %[StrainNew, StressNew] = smoothing((Spongy.file1(d).Strain), (Spongy.file1(d).Stress));
        A = Spongy.file1(d).StrainNew;
        B = Spongy.file1(d).StressNew;
        X = diff(Spongy.file1(d).StressNew);
        %Y = find(abs(X) > 0.06);
        %A(Y) = [];
        %B(Y) = [];
        %[Spongy.file1(d).StrainNew] = StrainNew;
        H = max(Spongy.file1(d).StressNew);
        %Y = find([RatColl.file1(d).StressNew] == X);
        %[RatColl.file1(d).StressNew] = RatColl.file1(d).StressNew(1:Y);
        %[RatColl.file1(d).StrainNew] = RatColl.file1(d).StrainNew(1:Y);
        [Spongy.file1(d).diff] = diff(Spongy.file1(d).StressNew)./diff(Spongy.file1(d).StrainNew);
        [Spongy.file1(d).diff2] = diff(Spongy.file1(d).diff)./diff(Spongy.file1(d).StrainNew(2:end));
        %subplot(2,2,1)
        hold on
        plot(Spongy.file1(d).Strain, Spongy.file1(d).Stress)
        xlabel('Strain (mm/mm)');
        ylabel('Stress (N/{mm}^2)');
        title(['Noisy Stress vs. Strain ', Spongy.file1(d).Material]);
        hold off 
        %subplot(2,2,2)
        hold on 
        %plot(Spongy.file1(d).StrainNew, Spongy.file1(d).StressNew);
        %title(['Cleaned Stress vs. Strain ', Spongy.file1(d).Material]);
        hold off 
    end 
    %figure(2)
    %plot(Spongy.file1(2).Strain, Spongy.file1(2).Stress, Spongy.file1(2).StrainNew, Spongy.file1(2).StressNew);
%% Compression Modulus
clear d c f 
P = zeros(1,20);
E = zeros(1,10);
YieldStress = zeros(1,10);
U = zeros(1, 10);
    for d = 1:numel(Spongy.file1)         
        keepgoing = true;
        f = 1;
        Window = 5;
        if numel(Spongy.file1(d).StressNew) < 130
            Window = 12;
        end
        while (f+Window < numel(Spongy.file1(d).StrainNew)) && keepgoing
            R = corr(Spongy.file1(d).StrainNew(f:f+Window), Spongy.file1(d).StressNew(f:f+Window));
            if R > 0.97
                keepgoing = true;
                f = f+Window;
            elseif R < 0.97
                keepgoing = false;
                X = Spongy.file1(d).StrainNew(1:f+Window);
                Y = Spongy.file1(d).StressNew(1:f+Window);
                U(d) = find(Spongy.file1(d).diff < 0, 1, 'first');
                YieldStress(d) = Spongy.file1(d).StressNew(U(d));
                %YieldStress(d) = Spongy.file1(d).StressNew(round(0.98*(f+Window)));
                for c = 2*d-1 
                P(c:c+1) = polyfit(X, Y, 1);
                E(d) = abs(P(c));
                end 
            else
                break 
            end
        end 
    [Spongy.file1(d).E] = E(d);
    [Spongy.file1(d).YS] = YieldStress(d); 
    [Spongy.file1(d).UStress] = max(Spongy.file1(d).StressNew);
    R = find(Spongy.file1(d).StressNew == max(Spongy.file1(d).StressNew));
    [Spongy.file1(d).UStrain] = Spongy.file1(d).StrainNew(R);
    end     
H = find(E == 0);
for d = H
   YieldStress(d) = Spongy.file1(d).StressNew(end);
   for c = 2*d-1 
   P(c:c+1) = polyfit(Spongy.file1(d).StrainNew, Spongy.file1(d).StressNew, 1);
   E(d) = P(c);
   end 
   [Spongy.file1(d).E] = E(d);
   [Spongy.file1(d).YS] = YieldStress(d);
   [Spongy.file1(d).UStress] = max(Spongy.file1(d).StressNew);
   R = find(Spongy.file1(d).StressNew == max(Spongy.file1(d).StressNew));
   [Spongy.file1(d).UStrain] = Spongy.file1(d).StrainNew(R);
end 
I = find(YieldStress < 1);

% Mean & SD - mech props
props_MeanSD_spong = struct('EMean', {},...
    'YSMean', {},...
    'UStrainMean', {},...
    'UStressMean', {},...
    'ESD', {},...
    'YSSD', {},...
    'UStrainSD', {},...
    'UStressSD', {});
    n.EMean = mean([Spongy.file1.E]);
    n.YSMean = mean([Spongy.file1.YS]);
    n.UStrainMean = mean([Spongy.file1.UStrain]);
    n.UStressMean = mean([Spongy.file1.UStress]);
    n.ESD = std([Spongy.file1.E]);
    n.YSSD = std([Spongy.file1.YS]);
    n.UStrainSD = std([Spongy.file1.UStrain]);
    n.UStressSD = std([Spongy.file1.UStress]);
    props_MeanSD_spong = n;