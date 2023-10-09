%question2
% Load the ECG data from the text file (assuming it's a column vector)
ecg_data = load('ECG_Data.txt');
fs = 720;

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

% Apply the filter to the ECG data
filtered_ecg = filter(b, a, ecg_data);

% Time vector
t = (0:length(ecg_data)-1) / fs;

% Plot the original and filtered signals on the same figure
figure;
subplot(2, 1, 1); %ori
plot(t, ecg_data, 'b', 'LineWidth', 1, 'DisplayName', 'Original ECG');
xlabel('Time (s)');
ylabel('Amplitude');

grid on;

subplot(2, 1, 2);
plot(t, filtered_ecg, 'r', 'LineWidth', 1, 'DisplayName', 'Filtered ECG');
xlabel('Time (s)');
ylabel('Amplitude');

grid on;