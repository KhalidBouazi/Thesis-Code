%%
L = 1:96;
Y = hdmdresult{1,1}.X(1,L);
t = hdmdresult{1,1}.t(L);
dt = hdmdresult{1,1}.dt;

%%Time specifications:
Fs = 1/dt;                      
N = length(t);
%%Fourier Transform:
X = fftshift(fft(Y));
%%Frequency specifications:
dF = Fs/N;                      % hertz
f = -Fs/2:dF:Fs/2-dF;           % hertz
%%Plot the spectrum:
figure;
plot(f,abs(X)/N);
xlabel('Frequency (in hertz)');
title('Magnitude Response');