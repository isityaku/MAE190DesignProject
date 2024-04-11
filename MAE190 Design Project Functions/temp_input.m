% Define Temperature Factor
function [T, status5] = temp_input(s_unit)
fprintf("DEFINE TEMPERATURE FACTOR \n\n");
if s_unit == "ksi"
    T = input("Input the desired temperature [from 70F to 1000F]:");
    while isempty(T) || T < 70 || T > 1000
        clc
        fprintf("DEFINE TEMPERATURE FACTOR \n\n");
        fprintf("Please input a valid option.\n\n");
        T = input("Input the desired temperature [from 70F to 1000F]:");
    end
elseif s_unit == "MPa"
    T = input("Input the desired temperature [from 20C to 550C]:");
    while isempty(T) || T < 20 || T > 550
        clc
        fprintf("DEFINE TEMPERATURE FACTOR \n\n");
        fprintf("Please input a valid option.\n\n");
        T = input("Input the desired temperature [from 70F to 1000F]:");
    end
end
status5 = 1;
end
