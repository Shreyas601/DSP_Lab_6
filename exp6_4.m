% Define filter specifications
passband_ripple = 2;      % Passband ripple in dB
cutoff_frequency = 10;  % Cutoff frequency in Hz
sampling_frequency = 720; % Sampling frequency in Hz

% Convert passband ripple from dB to linear scale
passband_ripple_linear = 10^(passband_ripple / 20);

% Calculate the normalized cutoff frequency
Wn = (2 * cutoff_frequency) / sampling_frequency;

% Design the Chebyshev Type I low-pass filter
[N, Wn] = cheb1ord(Wn, Wn*2, passband_ripple_linear, 60);
[b, a] = cheby1(N, passband_ripple, Wn, 'low');

% Plot the frequency response
freqz(b, a);
title('Chebyshev Type I Low-Pass Filter Frequency Response');
figure;

Fs = 720;
Ts = 1/Fs;
H = tf(b, a, Ts);
Hc = d2c(H);
h = pzplot(Hc);
grid on
figure;
bode(Hc);
figure;

stepz(b, a);
title('Step Response');
figure;

impz(b, a);
title('Impulse Response');
