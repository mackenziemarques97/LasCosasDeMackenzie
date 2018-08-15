% BME 354, HW 6, P3
% Mackenzie Marques
%% c
clf(figure(1))
figure(1)
plot(t, ecg); 
title('Canine ECG vs. time'); xlabel('time, s'); ylabel('ECG, mV');
%% d.
ECGmax = max(ecg);
ECGmin = min(ecg);
X = find(t==0);
Y = find(t==0.05);
Noisemax = max(ecg(X:Y));
Noisemin = min(ecg(X:Y));
%% i.
A = fft(ecg);
B = fftshift(A);
n = length(ecg);
Fs = 20000;
f = linspace(-Fs/2,Fs/2,n);
signal = 20*log10(abs(B));
clf(figure(2))
figure(2)
plot(f, signal);
title('Magnitude Frequency Spectrum'); 
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
%% j.
t1 = t(1:150:end);
E1 = ecg(1:150:end);
t2 = t(1:350:end);
E2 = ecg(1:350:end);
t3 = t(1:800:end);
E3 = ecg(1:800:end);
clf(figure(3))
figure(3)
subplot(3,1,1)
plot(t1,E1,'k')
title('150 downsample');
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
subplot(3,1,2)
plot(t2,E2,'k')
title('350 downsample');
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
subplot(3,1,3)
plot(t3,E3,'k')
title('800 downsample');
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
%% k.
Fs1 = 1/(t1(2)-t1(1));
f1 = linspace(-Fs1/2,Fs1/2,length(E1));
fftsignal1 = 20*log10(abs(fftshift(fft(E1))));
Fs2 = 1/(t2(2)-t2(1));
f2 = linspace(-Fs2/2,Fs2/2,length(E2));
fftsignal2 = 20*log10(abs(fftshift(fft(E2))));
Fs3 = 1/(t3(2)-t3(1));
f3 = linspace(-Fs3/2,Fs3/2,length(E3));
fftsignal3 = 20*log10(abs(fftshift(fft(E3))));
clf(figure(4))
figure(4)
subplot(3,1,1)
plot(f1, fftsignal1)
title('150 Frequency Spectrum'); 
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
subplot(3,1,2)
plot(f2, fftsignal2)
title('350 Frequency Spectrum'); 
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
subplot(3,1,3)
plot(f3, fftsignal3)
title('800 Frequency Spectrum'); 
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');