a = 2;

%1a

% Define filter specifications
passband_ripple = 2;  % Passband ripple in dB
stopband_ripple = 40;   % Stopband ripple in dB
cutoff_frequency = 10; % Cutoff frequency in Hz
sampling_frequency = 720; % Sampling frequency in Hz

% Calculate normalized cutoff frequency
Wn = (2 * cutoff_frequency) / sampling_frequency;

% Calculate filter order (round up to the nearest integer)
delta1 = 10^(-passband_ripple / 20);
delta2 = 10^(-stopband_ripple / 20);
N = ceil(log((1 / delta1^2 - 1) / (1 / delta2^2 - 1)) / (2 * log(Wn)));

% Design the Butterworth filter
[b, a] = butter(N, Wn, 'low');

% Plot the frequency response
freqz(b, a)
title('Butterworth Low-Pass Filter Frequency Response')
figure;

%1b

Fs = 720;
Ts = 1/Fs;
H = tf(b, a, Ts);
Hc = d2c(H);
h = pzplot(Hc);
grid on
figure;

%1c
bode(Hc);
figure;

stepz(b, a);
title('Step Response');
figure;

impz(b, a);
title('Impulse Response');