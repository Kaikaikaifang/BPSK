data = coeread('../assets/sources/rcos.coe');
data_coe = data.Numerator;
coe_hex = decimal_to_14bit_hex(data_coe);

% Save hex values to a text file
fileID_hex = fopen('../assets/sources/coe.hex', 'w');

fprintf(fileID_hex, '%s\n', coe_hex(1, 1:(length(coe_hex) +1) / 2));

fclose(fileID_hex);

function hex_array = decimal_to_14bit_hex(decimal_array)
    % Initialize the result array
    hex_array = strings(size(decimal_array));

    for i = 1:length(decimal_array)
        number = decimal_array(i);

        % Step 1: Convert to 14-bit binary string
        if number < 0
            % Handle negative numbers using two's complement
            number = bitand(2 ^ 14 + number, 2 ^ 14 - 1);
        end

        binary_str = dec2bin(number, 14);

        % Step 2: Convert binary string to hexadecimal
        hex_str = dec2hex(bin2dec(binary_str), 4);

        % Append to result array
        hex_array(i) = hex_str;
    end

end
