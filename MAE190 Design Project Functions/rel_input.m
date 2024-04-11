% Define Reliability Factor
function [rel_per, ke, status4] = rel_input

rel_mat = ["50%", "90%", "95%", "99%", "99.9%", "99.99%", "99.999%", "99.9999%";
    1.000 0.897 0.868 0.814 0.753 0.702 0.659 0.620];

fprintf("DEFINE RELIABILITY FACTOR \n\n");
fprintf("The available reliability percentages are listed below:\n")
for i = 1:length(rel_mat)
    fprintf("[%g] %s\n", i, rel_mat(1,i));
end

rel_sel = input("Input your desired reliability percentage [1-8]:");
while isempty(rel_sel) || (rel_sel < 1 || rel_sel > length(rel_mat)) || mod(rel_sel,1) ~= 0
    clc
    fprintf("DEFINE RELIABILITY FACTOR \n\n");
    fprintf("Please input a valid option. \n\n");
    fprintf("The available reliability percentages are listed below:\n")
    for i = 1:length(rel_mat)
        fprintf("[%g] %s\n", i, rel_mat(1,i));
    end
    rel_sel = input("Input the desired reliability percentage [1-8]:");
end

ke = str2double(rel_mat(2,rel_sel));
rel_per = rel_mat(1,rel_sel);
status4 = 1;

end
