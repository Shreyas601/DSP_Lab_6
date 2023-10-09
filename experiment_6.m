%% 
%% 
% 

%question one 
a = 3;


passband_ripple = 2;  % Passband ripple in dB
stopband_ripple = 40;   % Stopband ripple in dB
cutoff_frequency = 10; % Cutoff frequency in Hz
sampling_frequency = 720; % Sampling frequency in Hz

Wn = (2 * cutoff_frequency) / sampling_frequency;


delta1 = 10^(-passband_ripple / 20);
delta2 = 10^(-stopband_ripple / 20);
N = ceil(log((1 / delta1^2 - 1) / (1 / delta2^2 - 1)) / (2 * log(Wn)));


[b, a] = butter(N, Wn, 'low');


freqz(b, a)
title('Butterworth Low-Pass Filter Frequency Response')
figure;

%1b
sys = tf(b, a);
h = pzplot(sys);
grid on
figure;

%1c
%% 
% * Impulse Response: The impulse response represents how the filter responds 
% to a sudden input change. In this case, it starts with a spike (due to the sudden 
% change) and then gradually decays. The filter's characteristics, such as its 
% order and cutoff frequency, determine the shape of this response.
% * Step Response: The step response illustrates how the filter reacts to a 
% step input, like turning on a signal abruptly. It starts at zero, then rises 
% steadily until it reaches a stable value. The rate of rise and settling time 
% depends on the filter's design.
% * 10/360 
% * 20/360
% * ripple: 3dB,
% * ef(b,a, Fs)
%% 
% aim: The aim of this problem is to design a low-pass digital Butterworth filter 
% with specific passband and stopband requirements, analyze its properties, and 
% compare its responses.
% 
% Procedure: the filter specifications, including passband ripple, cutoff frequency, 
% and stopband edge frequency, were defined. The Butterworth filter order was 
% calculated using the MATLAB's built-in function 'butterord'. A low-pass Butterworth 
% filter was designed using the 'butter' function. A pole-zero plot was created 
% to assess filter stability and visualize poles and zeros. Additionally, a Bode 
% plot was generated to visualize the frequency response, and the impulse and 
% step responses of the filter were calculated and compared to understand its 
% time-domain behavior.    (--------------stable or not?)
% 
% results: The transfer function represents the mathematical description of 
% the filter's behavior. The pole-zero plot helps assess filter stability; poles 
% should be inside the unit circle for stability. The Bode plot illustrates the 
% frequency response characteristics, including cutoff frequency and rolloff rate. 
% The impulse and step responses show how the filter responds to input signals, 
% revealing transient behavior and steady-state characteristics. The impulse response 
% represents how the filter responds to a sudden input change. In this case, it 
% starts with a spike (due to the sudden change) and then gradually decays. The 
% filter's characteristics, such as its order and cutoff frequency, determine 
% the shape of this response. The step response illustrates how the filter reacts 
% to a step input, like turning on a signal abruptly. It starts at zero, then 
% rises steadily until it reaches a stable value.
% 
% 

%question2
% Load the ECG data from the text file (assuming it's a column vector)
ecg_data = load('C:\Users\chand\OneDrive\Documents\EEE\sem 5\DSP Lab\Experiment-1\ECG_Data.txt');

% Parameters
fs = 720;             % Sampling frequency (Hz)
cutoff_frequency = 3;  % Cutoff frequency for the filter (Hz)
filter_order = 5;     % Filter order (adjust as needed)

% Design a Butterworth filter
[b, a] = butter(filter_order, cutoff_frequency / (fs/2), 'low');

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
%% 
% Question 2 
% 
% The aim of this problem is to filter ECG (Electrocardiogram) data using a 
% Butterworth filter with a specified sampling frequency and then visualize and 
% compare the filtered output with the original signal.
% 
% Procedure: The ECG data stored in the text file was used and filtered with 
% a Butterworth filter, considering a sampling frequency of 720 Hz. The assessment 
% of how the filter affected the original ECG signal, particularly in terms of 
% noise reduction and signal preservation is done.
% 
% Results: The filtered ECG signal shows a reduction in high-frequency noise 
% or baseline drift, resulting in a smoother and cleaner signal. The plot shown 
% below is based on a filter order of 5 and cutoff frequency taken as 5 Hz. There 
% is a trade-off between noise reduction and signal distortion. Higher filter 
% orders provide better noise reduction but could lead to signal distortion when 
% too high. 

%question 3 
% Load the audio signal
[x, fs] = audioread('C:\Users\chand\OneDrive\Documents\EEE\sem 5\DSP Lab\Experiment-1\instru3.wav');

% Calculate the spectrogram of the audio signal
window_size = 1024;
overlap = window_size / 2;
nfft = 2^nextpow2(window_size);
[s_original, f_original, t_original] = spectrogram(x, hamming(window_size), overlap, nfft, fs);

% Find the dominant frequency (fundamental) in the spectrogram
fundamental_freq = f(find(sum(abs(s), 2) == max(sum(abs(s), 2)), 1));

% Design a Butterworth band-pass filter centered around the fundamental frequency
bandwidth = 10; % Adjust the bandwidth as needed
[b, a] = butter(6, [(fundamental_freq - bandwidth/2) (fundamental_freq + bandwidth/2)] / (fs/2), 'bandpass');

% Apply the filter to the audio signal
filtered_signal = filter(b, a, x);

% Save the filtered audio as a new WAV file
audiowrite('filtered_audio.wav', filtered_signal, fs);

% Calculate the spectrogram of the filtered audio
[s_filtered, ~, ~] = spectrogram(filtered_signal, hamming(window_size), overlap, nfft, fs);

% Normalize the spectrogram of the filtered audio
s_filtered_norm = 10*log10(abs(s_filtered) / max(abs(s_filtered(:))));

% Plot the normalized spectrogram of the filtered audio
subplot(2, 1, 1);
imagesc(t_original, f_original, 10*log10(abs(s_original)));
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colormap jet;
colorbar;

subplot(2, 1, 2);
imagesc(t, f, s_filtered_norm);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colormap jet;
colorbar;

%% 
% Aim: The aim is to analyze an audio signal by computing its spectrogram, designing 
% a Butterworth band-pass and verifying through spectrogram that only the fundamental 
% frequency is retained in the filtered output. 
% 
% Procedure:  the spectrogram of the 'instru3.wav' audio file was plotted using 
% the hamming window function. A digital Butterworth band-pass filter was designed 
% to extract the fundamental frequency while removing other frequency components, 
% including DC. The filtered audio was saved as a new WAV file. This process involved 
% analyzing the original spectrogram to identify the fundamental frequency as 
% the first major peak after DC. The aim was to isolate and preserve the fundamental 
% frequency while eliminating unwanted components.
% 
% 
% 
% Observations: 
% 
% The original spectrogram of the audio signal reveals the frequency content 
% and any harmonic components present in the signal. The fundamental frequency 
% refers to the first significant peak in the spectrogram after DC, and it corresponds 
% to the main pitch or tone of the audio signal.
% 
% The filtered audio showcases the clarity of the isolated fundamental frequency 
% and the removal of other frequencies. The spectrogram of the filtered audio 
% shown below confirms that only the fundamental frequency remains, while other 
% frequency components have been attenuated or removed. 
%% 
% Question 4 
% 
% Aim: The aim of this problem is to design a Type I Chebyshev filter with low-pass 
% characteristics, compare it to a Butterworth filter, and evaluate their responses.
% 
% Procedure:  The Chebyshev Type I filter order was computed using the 'cheb1ord' 
% function, and the Butterworth filter order was calculated using the 'butterord' 
% function. Both Chebyshev Type I and Butterworth low-pass filters were designed 
% using the determined filter orders and specifications. Bode plots were created 
% for both filters to compare their frequency responses. Impulse and step responses 
% of both filters were calculated and compared to assess their time-domain behavior. 
% 
% Results: 
% 
% The Chebyshev Type I filter oder is 5 and that of the Butterworth filter is 
% 8. Chebyshev filter has a lower order for the same specifications. The Bode 
% plot comparison showcases the differences in frequency response, including filter 
% rolloff and passband characteristics. Comparing the impulse and step responses 
% helps evaluate the filters' transient and steady-state behaviors. Chebyshev 
% filters provide steeper rolloff and less attenuation in the passband compared 
% to Butterworth filters but at the expense of ripple in the passband.

% Define filter specifications based on Problem 1
alpha = 1 + mod(235, 3); % Passband ripple in dB
fc = 10;                 % Cutoff frequency in Hz
fstop = 20;              % Stopband edge frequency in Hz
Fs = 720;                % Sampling frequency in Hz

% Calculate filter order using cheb1ord for Chebyshev Type I
[Rp, Rs] = deal(alpha, 40); % Passband ripple and stopband attenuation in dB
[N_chebyshev, Ws] = cheb1ord(2*pi*fc/Fs, 2*pi*fstop/Fs, Rp, Rs, 's');

% Calculate filter order using butterord for Butterworth
[N_butterworth, Wn] = buttord(2*pi*fc/Fs, 2*pi*fstop/Fs, Rp, Rs, 's');

% Display the calculated filter orders
fprintf('Chebyshev Type I Filter Order: %d\n', N_chebyshev);
fprintf('Butterworth Filter Order: %d\n', N_butterworth);