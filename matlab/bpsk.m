% Params
n = 15; % Number of bits
M = 64; % Number of samples in 1/4 of the period
N_T = 100; % Number of periods
Fc = 50000000; % Carrier frequency
Fs = Fc * M * 4; % Sampling frequency
% Generate the signal
delta_x = (2 * pi / (4 * M)); % Delta x
x = 0:delta_x:2 * pi * 100 - delta_x; % x values
signal = (2 ^ n - 1) * sin(x);

% Quantify the signal
quantified = fix(signal);

base_sig = randi([0, 1], 1, 1000);

base_sig = (base_sig - 0.5) * 2;

figure(1);
plot(x, quantified);
