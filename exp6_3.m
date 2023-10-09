% Step 1: Read and plot the spectrogram of instruα.wav
[x, fs] = audioread('instru2.wav');
window_size = 1024; % Adjust the window size as needed
overlap = window_size/2;
nfft = 2^nextpow2(window_size);
spectrogram(x, hamming(window_size), overlap, nfft, fs, 'yaxis');
title('Spectrogram of Original Audio (instruα.wav)');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;

% Step 2: Perform fundamental frequency estimation
fundamental_frequency = pitch(x, fs);
fundamental_frequency = fundamental_frequency(1:1);

% Step 3: Design a digital Butterworth bandpass filter
% Define filter specifications
passband_ripple = 2;        % Passband ripple in dB
stopband_ripple = 40;       % Stopband ripple in dB
filter_bandwidth = 50;      % Bandwidth for the filter in Hz

% Calculate normalized cutoff frequencies
Wn_low = 2*(fundamental_frequency - filter_bandwidth/2) / fs;
Wn_high = 2*(fundamental_frequency + filter_bandwidth/2) / fs;

% Calculate filter order (round up to the nearest integer)
delta1 = 10^(-passband_ripple / 20);
delta2 = 10^(-stopband_ripple / 20);
N = ceil(log((1 / delta1^2 - 1) / (1 / delta2^2 - 1)) / (2 * log(Wn_low * Wn_high)));

% Design the Butterworth bandpass filter
[b, a] = butter(N, [Wn_low, Wn_high], 'bandpass');

% Step 4: Apply the filter to the audio signal
filtered_audio = filter(b, a, x);

% Step 5: Write the filtered audio to a new WAV file
audiowrite('filtered_audio.wav', filtered_audio, fs);

% Step 6: Plot the spectrogram of the filtered audio
figure;
spectrogram(filtered_audio, hamming(window_size), overlap, nfft, fs, 'yaxis');
title('Spectrogram of Filtered Audio (Fundamental Frequency)');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;
