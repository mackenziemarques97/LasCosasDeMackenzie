function [StrainNew, StressNew] = smoothing(Strain, Stress)
numValues = numel(Strain);
WindowSize = (0.05*numValues);
StrainNew = downsample(Strain, 2);
StressNew = downsample(Stress, 2);
StressNew = smooth(StrainNew, StressNew, WindowSize);



