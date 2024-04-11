% Define Preset Parameters
function [M_max, M_min, T_max, T_min, status1, mat, modi, Sut, Sy, status2, n, status3, rel_per, ke, status4, D_d, r_d, T, status5, status6, status7] = pre_set(unit_name, status1, status2, status3, status4, status5)
if unit_name == "ENGLISH"
    fprintf("DEFINE PRESET PARAMETERS \n\n");
    fprintf("The variables for the Proof of Concept Calculation shall overwrite all your parameters.\n\n");
    proceed = input('Press ENTER to proceed back to the main menu');
    M_max = 5000;
    M_min = 1000;
    T_max = 1800;
    T_min = 0;
    mat = "CUSTOM";
    modi = "Machined";
    Sut = 75;
    Sy = 50;
    n = 1.5;
    rel_per = "99.99%";
    ke = 0.702;
    D_d = 1.2;
    r_d = 0.1;
    T = 70;
    status1 = 1; status2 = 1; status3 = 1; status4 = 1; status5 = 1; status6 = 1; status7 = 1;

elseif unit_name == "METRIC"
    fprintf("DEFINE PRESET PARAMETERS \n\n");
    fprintf("The variables for the Proof of Concept Calculation shalloverwrite all your parameters.\n\n");
    proceed = input('Press ENTER to proceed back to the main menu');
    M_max = 565;
    M_min = 113;
    T_max = 203;
    T_min = 0;
    mat = "CUSTOM";
    modi = "Machined";
    Sut = 517;
    Sy = 345;
    n = 1.5;
    rel_per = "99.99%";
    ke = 0.702;
    D_d = 1.2;
    r_d = 0.1;
    T = 20;
    status1 = 1; status2 = 1; status3 = 1; status4 = 1; status5 = 1; status6 = 1; status7 = 1;
end
end
