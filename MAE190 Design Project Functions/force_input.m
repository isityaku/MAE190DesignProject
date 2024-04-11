% Define Moments and Torques
function [M_max, M_min, T_max, T_min, status1] = force_input(f_unit, unit_name)
fprintf("DEFINE MOMENTS AND TORQUES \n\n");
fprintf("%s: %s (%s)\n", "UNITS", unit_name, f_unit);

M_max = input('Input your first desired bending moment:');
while isempty(M_max)
    clc
    fprintf("DEFINE MOMENTS AND TORQUES \n\n");
    fprintf("No input has been detected. \n\n");
    fprintf("%s: %s (%s)\n", "UNITS", unit_name, f_unit);
    M_max = input('Input your first desired bending moment:' );
end

clc
fprintf("DEFINE MOMENTS AND TORQUES \n\n");
fprintf("%s: %s (%s)\n", "UNITS", unit_name, f_unit);
M_min = input('Input your second desired bending moment:' );
while isempty(M_min)
    clc
    fprintf("DEFINE MOMENTS AND TORQUES \n\n");
    fprintf("No input has been detected. \n\n");
    fprintf("%s: %s (%s)\n", "UNITS", unit_name, f_unit);
    M_min = input('Input your second desired bending moment:' );
end

clc
fprintf("DEFINE MOMENTS AND TORQUES \n\n");
fprintf("%s: %s (%s)\n", "UNITS", unit_name, f_unit);
T_max = input('Input your first desired torque:' );
while isempty(T_max)
    clc
    fprintf("DEFINE MOMENTS AND TORQUES \n\n");
    fprintf("No input has been detected. \n\n");
    fprintf("%s: %s (%s)\n", "UNITS", unit_name, f_unit);
    T_max = input('Input your first desired torque:' );
end

clc
fprintf("DEFINE MOMENTS AND TORQUES \n\n");
fprintf("%s: %s (%s)\n", "UNITS", unit_name, f_unit);
T_min = input('Input your second desired torque:' );
while isempty(T_min)
    clc
    fprintf("DEFINE MOMENTS AND TORQUES \n\n");
    fprintf("No input has been detected. \n\n");
    fprintf("%s: %s (%s)\n", "UNITS", unit_name, f_unit);
    T_min = input('Input your second desired torque:' );
end

if M_max < M_min
    [M_min, M_max] = deal(M_max,M_min);
end

if T_max < T_min
    [T_min, T_max] = deal(T_max, T_min);
end

status1 = 1;
end
