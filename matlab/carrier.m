clc; clear;

% Params
n = 15; % Number of bits
M = 128; % Number of samples in 1/4 of the period

% Generate the signal
delta_x = (2 * pi / (4 * M)); % Delta x
x = 0:delta_x:pi / 2; % x values
signal = (2 ^ n - 1) * sin(x);

% Quantify the signal
quantified = fix(signal);
quantified_b = dec2bin(quantified);
quantified_hex = dec2hex(quantified);

% Save binary values to a binary file
fileID_bin = fopen('../assets/sources/sin_b.bin', 'wb');

for i = 1:size(quantified_b, 1)
    fwrite(fileID_bin, quantified_b(i, :), 'char');
    fwrite(fileID_bin, newline, 'char'); % To add a new line after each binary value
end

fclose(fileID_bin);

% Save hex values to a text file
fileID_hex = fopen('../assets/sources/sin_hex.hex', 'w');

for i = 1:size(quantified_hex, 1)
    fprintf(fileID_hex, '%s\n', quantified_hex(i, :));
end

fclose(fileID_hex);

% Plot the result
plot(x, quantified);
xlabel('x');
ylabel('quantified signal');
title('15-bit quantified sin(x) signal');
