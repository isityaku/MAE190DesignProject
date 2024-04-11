% Define Fatigue Factor of Safety
function [n, status3] = sf_input
fprintf("DEFINE FATIGUE FACTOR OF SAFETY \n\n");
n = input("Input the desired safety factor [cannot be lower than 1]:");
while isempty(n) || n < 1
    clc
    fprintf("DEFINE FATIGUE FACTOR OF SAFETY \n\n");
    fprintf("Please input a valid option.\n\n");
    n = input("Input the desired safety factor [cannot be lower than 1]: ");
end
status3 = 1;
end
