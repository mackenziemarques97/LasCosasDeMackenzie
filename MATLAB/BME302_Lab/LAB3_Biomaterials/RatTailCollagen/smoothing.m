function [StrainNew, StressNew] = smoothing(Strain, Stress)
numValues = numel(Strain);
WindowSize = (0.05*numValues);
StrainNew = movmean(Strain, WindowSize);
StressNew = movmean(Stress, WindowSize);



