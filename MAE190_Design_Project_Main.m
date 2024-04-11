%--------------------------------------------------------------------------------%
% MAE190 Shaft Design Project
%
% Made By : Lance Zyrus De La Cruz
%
% Description: This is a machined steel shaft optimization script made for
%       MAE190 for our design project. It asks the user to input specific
%       parameters, such as bending moments and torques, fatigue factor of
%       safety, reliability percentage, and others, which then the script uses
%       to calculate the minimum shaft diameter required.
%
% Modifications:
%   04.10.24 - Version 1.6 of the code has been completed.
%       Removed: functions within main script
%       Added: various scripts for each function
%   03.14.24 - Version 1.5 of the code has been completed.
%       Added: titanium alloys can now be used for the optimization script
%              new option added --- define temperature factor
%   03.12.24 - Version 1.4 of the code has been completed.
%       Added: variable D/d and r/d rather than set values (1.2 and 0.1,
%                   respectively)
%   03.11.24 - Version 1.3 of the code has been completed.
%       Added: new option added --- Define Preset Parameters has been added to
%                   streamline testing process of the script
%   03.10.24 - Version 1.2 of the code has been completed.
%       Added: iterative analysis of yielding and ultimate tensile factor
%                   to determine design viability
%       Added: custom materials (Sy and Sut have to be inputted by the
%                   user)
%   03.09.24 - Verseion 1.0 of the code has been completed.
%       Added: shaft optimization function with three equations (Goodman,
%                   Gerber, and ASME Elliptic)
%   03.09.24 - Version 0.2 of the code has been completed.
%       Added: all of the yield and ultimate tensile strengths of different
%                   materials have been added in matrices to be called by
%                   the script.
%   03.08.24 - Version 0.1 of the code has been completed
%       Added: general skeleton of the code, mainly of the moment and
%                   toqrue definition, fatigue safety factor definition,
%                   and reliability percentage definition
%
% Made for MAE190 - WINTER 2024
%--------------------------------------------------------------------------------%

clc; clear all; close all

%% Menu
% Initializing variables
choice = 1; status1 = 0; status2 = 0; status3 = 0; status4 = 0; status5 = 0; status6 = 0; status7 = 0; status8 = 0; % formatting variables
M_max = 0; M_min = 0; T_max = 0; T_min = 0; mat = "N/A"; modi = "N/A"; % moment and torque variables
Sy = 0; Sut = 0; % material variables
n = 0; % safety factor variable
ke = 0; % reliability factor variable
T = 0; % temperature factor variable
D_d = 0; r_d = 0; % shaft geometry variables

units = ["ENGLISH", "METRIC";
    "ksi", "MPa";
    "lb-in", "N-m";
    "in", "mm"];

% Asks user for which unit the calculations will be presented as
unit_sel = input("Please select which unit system you would like to use [1 for English, 2 for Metric]:");
while isempty(unit_sel) || unit_sel < 1 || unit_sel > 2 || mod(unit_sel,1) ~= 0
    clc
    fprintf("Please input a valid option.\n\n")
    unit_sel = input("Please select which unit system you would like to use [1 for English, 2 for Metric]:");
end
unit_name = units(1,unit_sel);
s_unit = units(2,unit_sel); % strength / stress units
f_unit = units(3,unit_sel); % force units
d_unit = units(4,unit_sel); % diameter units

% Menu Formatting
clc
fprintf("Hello. This is a Machined Steel Shaft Optimization Script designed by Lance Zyrus De La Cruz for MAE190. \n");
fprintf("Below is a menu where you can input or select specific parameters, or begin the optimization script once all other parameters have been defined.\n\n");

while choice ~= 9 % Loop back to menu unless user inputs to exit script
    fprintf("MACHINED STEEL SHAFT OPTIMIZATION SCRIPT MENU:\n");
    fprintf("[1] Define Moments and Torques \n");
    if status1 == 1
        fprintf("       %s = %g %s, %s = %g %s, %s = %g %s, %s = %g %s\n" , "M_max", M_max, f_unit, "M_min", M_min, f_unit, "T_max", T_max, f_unit, "T_min", T_min, f_unit);
    end
    fprintf("[2] Define Material \n");
    if status2 == 1
        fprintf("       %s: %s %s; %s = %g %s, %s = %g %s\n", "Material", mat, modi, "S_y", Sy, s_unit, "S_ut", Sut, s_unit);
    end
    fprintf("[3] Define Fatigue Factor of Safety \n");
    if status3 == 1
        fprintf("       %s = %g\n", "Fatigue Factor of Safety", n);
    end
    fprintf("[4] Define Reliability Factor \n");
    if status4 == 1
        fprintf("       %s = %s\n", "Reliability", rel_per);
    end
    fprintf("[5] Define Temperature Factor \n");
    if status5 == 1
        if s_unit == "ksi"
            fprintf("       %s = %g %s\n", "Temperature", T, "degrees F");
        elseif s_unit == "MPa"
            fprintf("       %s = %g %s\n", "Temperature", T, "degrees C");
        end
    end
    fprintf("[6] Define Shaft Geometry \n");
    if status6 == 1
        fprintf("       %s = %g, %s = %g\n", "D/d", D_d, "r/d", r_d);
    end
    fprintf("[7] Define Preset Parameters\n");
    fprintf("[8] Shaft Optimization Script \n");
    if status8 == 1
        fprintf("       %s: %s, %s: %g%%, %s: %g %s, %s: %g\n", "Criteria", optcrit, "Convergence Limit", convin, "Minimum Shaft Diameter", d(end), d_unit, 'Number of Iterations', j);
        fprintf("       %s: %g, %s: %g\n", "Yielding Factor of Safety", ny(end), "Ultimate Tensile Factor of Safety", nut(end));
    end
    fprintf("[9] End Script \n\n");
    fprintf("%s: %s \n\n", "UNITS", unit_name);
    choice = input("Please select which processes you would like to perform:");

    while isempty(choice) || choice < 1 || choice > 9 || mod(choice,1) ~= 0
        clc
        fprintf("Please input a valid option.\n\n");
        fprintf("MACHINED STEEL SHAFT OPTIMIZATION SCRIPT MENU:\n");
        fprintf("[1] Define Moments and Torques \n");
        if status1 == 1
            fprintf("       %s = %g %s, %s = %g %s, %s = %g %s, %s = %g %s\n" , "M_max", M_max, f_unit, "M_min", M_min, f_unit, "T_max", T_max, f_unit, "T_min", T_min, f_unit);
        end
        fprintf("[2] Define Material \n");
        if status2 == 1
            fprintf("       %s: %s %s; %s = %g %s, %s = %g %s\n", "Material", mat, modi, "S_y", Sy, s_unit, "S_ut", Sut, s_unit);
        end
        fprintf("[3] Define Fatigue Factor of Safety \n");
        if status3 == 1
            fprintf("       %s = %g\n", "Fatigue Factor of Safety", n);
        end
        fprintf("[4] Define Reliability Factor \n");
        if status4 == 1
            fprintf("       %s = %s\n", "Reliability", rel_per);
        end
        fprintf("[5] Define Temperature Factor \n");
        if status5 == 1
            if s_unit == "ksi"
                fprintf("       %s = %g %s\n", "Temperature", T, "degrees F");
            elseif s_unit == "MPa"
                fprintf("       %s = %g %s\n", "Temperature", T, "degrees C");
            end
        end
        fprintf("[6] Define Shaft Geometry \n");
        if status6 == 1
            fprintf("       %s = %g, %s = %g\n", "D/d", D_d, "r/d", r_d);
        end
        fprintf("[7] Define Preset Parameters\n");
        fprintf("[8] Shaft Optimization Script \n");
        if status8 == 1
            fprintf("       %s: %s, %s: %g%%, %s: %g %s, %s: %g\n", "Criteria", optcrit, "Convergence Limit", convin, "Minimum Shaft Diameter", d(end), d_unit, 'Number of Iterations', j);
            fprintf("       %s: %g, %s: %g\n", "Yielding Factor of Safety", ny(end), "Ultimate Tensile Factor of Safety", nut(end));
            if ny < n
                fprintf("       The Yielding Factor of Safety is less than the Defined Factor of Safety -- DESIGN IS NOT VIABLE")
            elseif nut < n
                fprintf("       The Ultimate Tensile Factor of Safety is less than the Defined Factor of Safety -- DESIGN IS NOT VIABLE")
            else
            end
        end
        fprintf("[9] End Script \n\n");
        fprintf("%s: %s (%s)\n\n", "UNITS", unit_name);
        choice = input("Please select which processes you would like to perform:");
    end

    if choice == 1 % Define Moment and Torque
        clc
        [M_max, M_min, T_max, T_min, status1] = force_input(f_unit, unit_name);
        clc
        fprintf("DEFINE MOMENTS AND TORQUES - COMPLETE \n\n");

    elseif choice == 2 % Define Material
        clc
        [mat, modi, Sut, Sy, status2] = mat_selection(s_unit);
        clc
        fprintf("DEFINE MATERIAL - COMPLETE \n\n");

    elseif choice == 3 % Define Fatigue Factor of Safety
        clc
        [n, status3] = sf_input;
        clc
        fprintf("DEFINE FATIGUE FACTOR OF SAFETY - COMPLETE \n\n");

    elseif choice == 4 % Define Reliability Factor
        clc
        [rel_per, ke, status4] = rel_input;
        clc
        fprintf("DEFINE RELIABILITY FACTOR - COMPLETE \n\n");

    elseif choice == 5 % Define Temperature Factor
        clc
        [T, status5] = temp_input(s_unit);
        clc
        fprintf("DEFINE TEMPERATURE FACTOR - COMPLETE \n\n");

    elseif choice == 6 % Define Shaft Geometry
        clc
        [D_d, r_d, status6] = shaft_geo;
        clc
        fprintf("DEFINE SHAFT GEOMETRY - COMPLETE \n\n");

    elseif choice == 7
        clc
        [M_max, M_min, T_max, T_min, status1, mat, modi, Sut, Sy, status2, n, status3, rel_per, ke, status4, D_d, r_d, T, status5, status6, status7] = pre_set(unit_name, status1, status2, status3, status4, status5);
        clc
        fprintf("DEFINE PRESET PARAMETERS - COMPLETE \n\n");

    elseif choice == 8 % Shaft Optimization
        clc
        [d, j, optcrit, convin, ny, nut, fail, status8] = shaft_opt(M_max, M_min, T_max, T_min, modi, Sut, Sy, n, ke, D_d, r_d, s_unit, T, status1, status2, status3, status4, status5, status6);
        clc
        if fail ~= 1
            fprintf("SHAFT OPTIMIZATION - COMPLETE \n\n");
        else
            fprintf("SHAFT OPTIMIZATION - CANCELLED \n\n");
        end
        
    else % Exit Script
        clc
        fprintf("Thank you for using the Machined Steel Shaft Optimization Script. The script will now end.\n");
        if status1 == 1 || status2 == 1 || status3 == 1 || status4 == 1 || status5 == 1 || status6 == 1
            fprintf("\nSummary:\n")
        end
        if status1 == 1
            fprintf("       %s = %g %s, %s = %g %s, %s = %g %s, %s = %g %s\n" , "M_max", M_max, f_unit, "M_min", M_min, f_unit, "T_max", T_max, f_unit, "T_min", T_min, f_unit);
        end
        if status2 == 1
            fprintf("       %s: %s %s; %s = %g %s, %s = %g %s\n", "Material", mat, modi, "S_y", Sy, s_unit, "S_ut", Sut, s_unit);
        end
        if status3 == 1
            fprintf("       %s = %g\n", "Fatigue Factor of Safety", n);
        end
        if status4 == 1
            fprintf("       %s = %s\n", "Reliability", rel_per);
        end
        if status5 == 1
            if s_unit == "ksi"
                fprintf("       %s = %g %s\n", "Temperature", T, "degrees F");
            elseif s_unit == "MPa"
                fprintf("       %s = %g %s\n", "Temperature", T, "degrees C");
            end
        end
        if status6 == 1
            fprintf("       %s = %g, %s = %g\n", "D/d", D_d, "r/d", r_d);
        end
        if status8 == 1
            fprintf("       %s: %s, %s: %g%%, %s: %g %s, %s: %g\n", "Criteria", optcrit, "Convergence Limit", convin, "Minimum Shaft Diameter", d(end), d_unit, 'Number of Iterations', j);
            fprintf("       %s: %g, %s: %g\n", "Yielding Factor of Safety", ny(end), "Ultimate Tensile Factor of Safety", nut(end));
        end
        fprintf("\nMade by: Lance Zyrus De La Cruz");
        return
    end
end