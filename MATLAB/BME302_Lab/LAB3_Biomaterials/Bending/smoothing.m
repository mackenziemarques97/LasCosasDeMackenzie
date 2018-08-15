function [StrainNew, StressNew] = smoothing(Strain, Stress)
numValues = numel(Strain);
WindowSize = (0.05*numValues);
StrainNew = downsample(Strain, 4);
StressNew = downsample(Stress, 4);
StrainNew = movmean(StrainNew, WindowSize);
StressNew = movmean(StressNew, WindowSize);
StressNew = smooth(StrainNew, StressNew, WindowSize);



