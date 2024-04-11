% Define Shaft Geometry
function [D_d, r_d, status6] = shaft_geo
fprintf("DEFINE SHAFT GEOMETRY \n\n");
D_d = input("Input your desired D/d ratio in decimal form [1.10 to 2.00]: ");
while isempty(D_d) || D_d < 1.1 || D_d > 2
    clc
    fprintf("DEFINE SHAFT GEOMETRY \n\n");
    fprintf("Please input a valid option.\n\n");
    D_d = input("Input your desired D/d ratio in decimal form [1.10 to 2.00]: ");
end

clc
fprintf("DEFINE SHAFT GEOMETRY \n\n");
r_d = input("Input your desired r/d ratio in decimal form [0.01 to 0.30]: ");
while isempty(r_d) || r_d < 0.01 || r_d > 0.3
    clc
    fprintf("DEFINE SHAFT GEOMETRY \n\n");
    fprintf("Please input a valid option.\n\n");
    r_d = input("Input your desired r/d ratio in decimal form [0.01 to 0.30]: ");
end
status6 = 1;
end
