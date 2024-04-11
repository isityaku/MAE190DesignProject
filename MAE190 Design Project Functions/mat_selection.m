% Define Material
function [mat, modi, Sut, Sy, status2] = mat_selection(s_unit)
fprintf("DEFINE MATERIAL \n\n");
mats = ["Carbon Steels", "Wrought Aluminum Alloy (WIP)", "Cast Aluminum Alloy (WIP)", "Titanium Alloy", "CUSTOM"];
fprintf("NOTE: Wrought and Cast Aluminum Alloys are not viable for optimization due to inherently not having an endurance limit.\n")
fprintf("You can still use this function to gain the yield and ultimate tensile strengths of your chosen material, though the shaft optimization script will not run for either aluminum alloys.\n")
fprintf("If a material you would like to analyze is missing, you are also able to make a custom material for analysis by inputting its yield and tensile strengths along with its surface finish.\n\n")
fprintf("Below are some viable materials:\n")
for i = 1:length(mats)
    fprintf("[%g] %s\n", i, mats(i))
end

choice = input(['Input your desired material [1-' num2str(length(mats)) ']: ']);
while isempty(choice) == 1 || (choice < 1 || choice > length(mats)) || mod(choice,1) ~= 0
    clc
    fprintf("DEFINE MATERIAL \n\n");
    fprintf("NOTE: Wrought and Cast Aluminum Alloys are not viable for optimization due to inherently not having an endurance limit.\n")
    fprintf("You can still use this function to gain the yield and ultimate tensile strengths of your chosen material, though the shaft optimization script will not run for either aluminum alloys.\n")
    fprintf("If a material you would like to analyze is missing, you are also able to make a custom material for analysis by inputting its yield and tensile strengths along with its surface finish.\n\n")
    fprintf("Please input a valid option. \n\n");
    fprintf("Below are some viable materials:\n")
    for i = 1:length(mats)
        fprintf("[%g] %s\n\n", i, mats(i))
    end
    choice = input(['Input your desired material [1-' num2str(length(mats)) ']: ']);
end

if choice == 1
    clc

    csteel = ["AISI 1006", "AISI 1010", "AISI 1015", "AISI 1018", "AISI 1020", "AISI 1030", "AISI 1035", "AISI 1040", "AISI 1045", "AISI 1050", "AISI 1060", "AISI 1080", "AISI 1090"; ...
        43 47 50 58 55 68 72 76 82 90 98 112 120; ... % HR tensile (kpsi)
        48 53 56 64 68 76 80 85 91 100 0 0 0; ... % CD tensile (kpsi)
        24 26 27.5 32 30 37.5 39.5 42 45 49.5 54 61.5 66; ... % HR yield (kpsi)
        41 44 47 54 57 64 67 71 77 84 0 0 0; ... % CD yield (kpsi)
        300 320 340 400 380 470 500 520 570 620 680 770 830; ... % HR tensile (MPa)
        330 370 390 440 470 520 550 590 630 690 0 0 0; ... % CD tensile (MPa)
        170 180 190 220 210 260 270 290 310 340 370 420 460; ... % HR yield (MPa)
        280 300 320 370 390 440 460 490 530 580 0 0 0]; ... % CD yield (MPa)
    
    fprintf("DEFINE MATERIAL \n\n");
    fprintf("Below are various carbon steels: \n");
    for i = 1:size(csteel,2)
        fprintf("[%g] %s\n", i, csteel(1,i))
    end

    mat_input = input(['\nInput your choice of carbon steel [1-' num2str(size(csteel,2)) ']: ']);
    while isempty(mat_input) == 1 || (mat_input < 1 || mat_input > size(csteel,2)) || mod(mat_input,1) ~= 0
        clc
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("Please input a valid option. \n\n");
        fprintf("Below are various carbon steels: \n");
        for i = 1:size(csteel,2)
            fprintf("[%g] %s\n", i, csteel(1,i))
        end
        mat_input = input(['Input your choice of carbon steel [1-' num2str(size(csteel,2)) ']: ']);
    end

    if mat_input > 10
        mat_modi = 1;
    else
        clc
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("%s, %s, %s \n%s\n%s\n", "Your chosen carbon steel", csteel(1,mat_input), "can be processed in either of the following manners:", "[1] Hot-Rolled (HR)", "[2] Cold-Drawn (CD)");
        mat_modi = input("Input your desired surface finish [1 for HR, 2 for CD]:");
        while isempty(mat_modi) == 1 || (mat_modi == 1 || mat_modi == 2) ~= 1 || mod(mat_modi,1) ~= 0
            clc
            fprintf("Please input a valid option. \n");
            fprintf("\n%s, %s, %s \n%s\n%s\n", "Your chosen carbon steel", csteel(1,mat_input), "can be processed in either of the following manners:", "[1] Hot-Rolled (HR)", "[2] Cold-Drawn (CD)");
            mat_modi = input("Input your desired surface finish [1 for HR, 2 for CD]:");
        end
    end

    mat_modi_n = ["HR", "CD"];
    mat = csteel(1, mat_input);
    modi = mat_modi_n(mat_modi);
    if s_unit == "ksi"
        Sut = str2double(csteel(mat_modi + 1, mat_input));
        Sy = str2double(csteel(mat_modi + 3, mat_input));
    elseif s_unit == "MPa"
        Sut = str2double(csteel(mat_modi + 5, mat_input));
        Sy = str2double(csteel(mat_modi + 7, mat_input));
    end
    status2 = 1;

elseif choice == 2
    clc

    walum = ["2017", "2024", "3003", "3004", "5052"; ...
        10 11 17 27 27; 0 50 24 34 34; ... % yield (kpsi)
        26 27 19 34 34; 0 70 26 40 39; ... % tensile (kpsi)
        70 76 117 186 186; 0 345 165 234 234; ... % yield (MPa)
        179 186 131 234 234; 0 482 179 276 269]; % tensile (MPa)

    fprintf("DEFINE MATERIAL \n\n");
    fprintf("Below are various wrought aluminum alloys: \n");
    for i = 1:size(walum,2)
        fprintf("[%g] %s\n", i, walum(1,i))
    end
    mat_input = input(['\nInput your choice of wrought aluminum alloy [1-' num2str(size(walum,2)) ']: ']);
    while isempty(mat_input) == 1 || (mat_input < 1 || mat_input > size(walum,2)) || mod(mat_input,1) ~= 0
        clc
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("Please input a valid option. \n\n");
        fprintf("Below are various wrought aluminum alloys: \n");
        for i = 1:size(walum,2)
            fprintf("[%g] %s\n", i, walum(1,i))
        end
        mat_input = input(['Input your choice of wrought aluminum alloy [1-' num2str(size(walum,2)) ']: ']);
    end
    
    if mat_input == 1
        mat_modi = 1;
        mat_modi_n = "O";
    elseif mat_input == 2
        clc
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("%s, %s, %s \n%s\n%s\n", "Your chosen wrought aluminum alloy", walum(1,mat_input), "can be processed in either of the following tempers:", "[1] O", "[2] T3");
        mat_modi = input("Input your desired temper [1 for O, 2 for T3]:");
        while isempty(mat_modi) == 1 | (mat_modi == 1 | mat_modi == 2) ~= 1 || mod(mat_modi,1) ~= 0
            clc
            fprintf("DEFINE MATERIAL \n\n");
            fprintf("Please input a valid option. \n");
            fprintf("%s, %s, %s \n%s\n%s\n", "Your chosen wrought aluminum alloy", walum(1,mat_input), "can be processed in either of the following tempers:", "[1] O", "[2] T3");
            mat_modi = input("Input your desired temper [1 for O, 2 for T3]:");
        end
        mat_modi_n = ["O", "T3"];
    elseif mat_input == 3
        clc
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("%s, %s, %s \n%s\n%s\n", "Your chosen wrought aluminum alloy", walum(1,mat_input), "can be processed in either of the following tempers:", "[1] H12", "[2] H16");
        mat_modi = input("Input your desired temper [1 for H12, 2 for H16]:");
        while isempty(mat_modi) == 1 | (mat_modi == 1 | mat_modi == 2) ~= 1 || mod(mat_modi,1) ~= 0
            clc
            fprintf("DEFINE MATERIAL \n\n");
            fprintf("Please input a valid option. \n");
            fprintf("%s, %s, %s \n%s\n%s\n", "Your chosen wrought aluminum alloy", walum(1,mat_input), "can be processed in either of the following tempers:", "[1] H12", "[2] H16");
            mat_modi = input("Input your desired temper  [1 for H12, 2 for H16]:");
        end
        mat_modi_n = ["H12", "H16"];
    elseif mat_input == 4
        clc
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("%s, %s, %s \n%s\n%s\n", "Your chosen wrought aluminum alloy", walum(1,mat_input), "can be processed in either of the following tempers:", "[1] H34", "[2] H38");
        mat_modi = input("Input your desired temper [1 for H34, 2 for H38]:");
        while isempty(mat_modi) == 1 | (mat_modi == 1 | mat_modi == 2) ~= 1 || mod(mat_modi,1) ~= 0
            clc
            fprintf("DEFINE MATERIAL \n\n");
            fprintf("Please input a valid option. \n");
            fprintf("%s, %s, %s \n%s\n%s\n", "Your chosen wrought aluminum alloy", walum(1,mat_input), "can be processed in either of the following tempers:", "[1] H34", "[2] H38");
            mat_modi = input("Input your desired temper [1 for H34, 2 for H38]:");
        end
        mat_modi_n = ["H34", "H38"];
    elseif mat_input == 5
        clc
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("%s, %s, %s \n%s\n%s\n", "Your chosen wrought aluminum alloy", walum(1,mat_input), "can be processed in either of the following tempers:", "[1] H32", "[2] H36");
        mat_modi = input("Input your desired temper [1 for H32, 2 for H36]:");
        while isempty(mat_modi) == 1 | (mat_modi == 1 | mat_modi == 2) ~= 1 || mod(mat_modi,1) ~= 0
            clc
            fprintf("DEFINE MATERIAL \n\n");
            fprintf("Please input a valid option. \n");
            fprintf("%s, %s, %s \n%s\n%s\n", "Your chosen wrought aluminum alloy", walum(1,mat_input), "can be processed in either of the following tempers:", "[1] H32", "[2] H36");
            mat_modi = input("Input your desired temper  [1 for H32, 2 for H36]:");
        end
        mat_modi_n = ["H32", "H36"];
    end

    mat = walum(1, mat_input);
    modi = mat_modi_n(mat_modi);
    if s_unit == "ksi"
        Sut = str2double(walum(mat_modi + 3, mat_input));
        Sy = str2double(walum(mat_modi + 1, mat_input));
    elseif s_unit == "MPa"
        Sut = str2double(walum(mat_modi + 4, mat_input));
        Sy = str2double(walum(mat_modi + 2, mat_input));
    end
    status2 = 1;

elseif choice == 3
    clc

    calum = ["319.0*", "333.0^", "335.0*"; ...
        24 25 25; 0 30 36; ... % yield (kpsi)
        36 34 35; 0 42 38; ... % tensile (kpsi)
        165 172 172; 0 207 248; ... % yield (MPa)
        248 234 241; 0 289 262]; % tensile (MPa)

    fprintf("DEFINE MATERIAL \n\n");
    fprintf("Below are various cast aluminum alloys: \n");
    for i = 1:size(calum,2)
        fprintf("[%g] %s\n", i, calum(1,i))
    end
    fprintf("NOTE:\n")
    fprintf("* = sand casting\n")
    fprintf("^ = permanent-mold casting\n")
    mat_input = input(['\nInput your choice of cast aluminum alloy [1-' num2str(size(calum,2)) ']: ']);
    while isempty(mat_input) == 1 || (mat_input < 1 || mat_input > size(calum,2)) || mod(mat_input,1) ~= 0
        clc
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("Please input a valid option. \n\n");
        fprintf("Below are various cast aluminum alloys: \n");
        for i = 1:size(calum,2)
            fprintf("[%g] %s\n", i, calum(1,i))
        end
        fprintf("NOTE:\n")
        fprintf("* = sand casting\n")
        fprintf("^ = permanent-mold casting\n")
        mat_input = input(['\nInput your choice of cast aluminum alloy [1-' num2str(size(calum,2)) ']: ']);
    end

    if mat_input == 1
        mat_modi = 1;
        mat_modi_n = "T6";
    elseif mat_input == 2
        clc
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("%s, %s, %s \n%s\n%s\n", "Your chosen cast aluminum alloy", calum(1,mat_input), "can be processed in either of the following tempers:", "[1] T5", "[2] T6");
        mat_modi = input("Input your desired temper [1 for T5, 2 for T6]:");
        while isempty(mat_modi) == 1 | (mat_modi == 1 | mat_modi == 2) ~= 1 || mod(mat_modi,1) ~= 0
            clc
            fprintf("DEFINE MATERIAL \n\n");
            fprintf("Please input a valid option. \n");
            fprintf("%s, %s, %s \n%s\n%s\n", "Your chosen cast aluminum alloy", calum(1,mat_input), "can be processed in either of the following tempers:", "[1] T5", "[2] T6");
            mat_modi = input("Input your desired temper [1 for T5, 2 for T6]:");
        end
        mat_modi_n = ["T5", "T6"];
    elseif mat_input == 3
        clc
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("%s, %s, %s \n%s\n%s\n", "Your chosen cast aluminum alloy", calum(1,mat_input), "can be processed in either of the following tempers:", "[1] T6", "[2] T7");
        mat_modi = input("Input your desired temper [1 for T6, 2 for T7]:");
        while isempty(mat_modi) == 1 | (mat_modi == 1 | mat_modi == 2) ~= 1 || mod(mat_modi,1) ~= 0
            clc
            fprintf("DEFINE MATERIAL \n\n");
            fprintf("Please input a valid option. \n");
            fprintf("%s, %s, %s \n%s\n%s\n", "Your chosen cast aluminum alloy", calum(1,mat_input), "can be processed in either of the following tempers:", "[1] T6", "[2] T7");
            mat_modi = input("Input your desired temper [1 for T6, 2 for T7]:");
        end
        mat_modi_n = ["T6", "T7"];
    end

    mat = calum(1, mat_input);
    modi = mat_modi_n(mat_modi);
    if s_unit == "ksi"
        Sut = str2double(calum(mat_modi + 3, mat_input));
        Sy = str2double(calum(mat_modi + 1, mat_input));
    elseif s_unit == "MPa"
        Sut = str2double(calum(mat_modi + 4, mat_input));
        Sy = str2double(calum(mat_modi + 2, mat_input));
    end
    status2 = 1;

elseif choice == 4
    clc
    titan = ["Ti-35A", "Ti-50A", "Ti-0.2 Pd", "Ti-5 Al-2.5 Sn", "Ti-8 Al-1 Mo-1 V", "Ti-6 Al-6 V-2 Sn", "Ti-6 Al-4 V", "Ti-13 V-11 Cr-3 Al"; ...
        30 45 40 110 130 140 120 175; ... % yield (kpsi)
        40 55 50 115 140 150 130 185; ... % tensile (kpsi)
        210 310 280 760 900 970 830 1207; ... % yield (MPa)
        275 380 340 790 965 1030 900 1276]; % tensile (MPa)

    fprintf("DEFINE MATERIAL \n\n");
    fprintf("Below are various titanium alloys: \n");
    for i = 1:size(titan,2)
        fprintf("[%g] %s\n", i, titan(1,i))
    end

    mat_input = input(['\nInput your choice of titanium alloy [1-' num2str(size(titan,2)) ']: ']);
    while isempty(mat_input) == 1 || (mat_input < 1 || mat_input > size(titan,2)) || mod(mat_input,1) ~= 0
        clc
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("Please input a valid option. \n");
        fprintf("Below are various titanium alloys: \n");
        for i = 1:size(titan,2)
            fprintf("[%g] %s\n", i, titan(1,i))
        end
        mat_input = input(['Input your choice of titanium alloy [1-' num2str(size(titan,2)) ']: ']);
    end

    mat_modi_n = ["Ground", "Machined", "CD", "HR", "As-forged"];
    mat = titan(1, mat_input);

    clc
    fprintf("DEFINE MATERIAL \n\n");
    fprintf("%s, %s %s\n%s\n%s\n%s\n%s\n%s\n", "Your titanium alloy", mat, " can have any of the following surface finishes:", "[1] Ground", "[2] Machined", "[3] Cold-Drawn (CD)", "[4] Hot-rolled (HR)", "[5] As-forged");
    mat_modi = input("Input your desired material surface finish [1-5]:");
    while isempty(mat_modi) == 1 || mat_modi < 1 || mat_modi > 5 || mod(mat_modi,1) ~= 0
        clc
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("Please input a valid option. \n");
        fprintf("%s, %s %s\n%s\n%s\n%s\n%s\n%s\n", "Your titanium alloy", mat, " can have any of the following surface finishes:", "[1] Ground", "[2] Machined", "[3] Cold-Drawn (CD)", "[4] Hot-rolled (HR)", "[5] As-forged");
        mat_modi = input("Input your desired material surface finish [1-5]:");
    end

    modi = mat_modi_n(mat_modi);

    if s_unit == "ksi"
        Sut = str2double(titan(3, mat_input));
        Sy = str2double(titan(2, mat_input));
    elseif s_unit == "MPa"
        Sut = str2double(titan(5, mat_input));
        Sy = str2double(titan(4, mat_input));
    end
    status2 = 1;

elseif choice == 5
    clc
    fprintf("DEFINE MATERIAL \n\n");
    fprintf("%s %s%s", "Input your custom material's yield strength [in", s_unit, "]:");
    Sy = input('');
    while isempty(Sy) || Sy <= 0
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("No input has been detected.\n\n");
        fprintf("%s %s%s", "Input your custom material's yield strength [in", s_unit, "]:");
        Sy = input('');
    end

    clc
    fprintf("DEFINE MATERIAL \n\n");
    fprintf("%s %s%s", "Input your custom material's tensile strength [in", s_unit, "]:");
    Sut = input('');
    while isempty(Sut) || Sut <= 0
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("No input has been detected.\n\n");
        fprintf("%s %s%s", "Input your custom material's tensile strength [in", s_unit, "]:");
        Sut = input('');
    end

    clc
    fprintf("DEFINE MATERIAL \n\n");
    fprintf("%s\n%s\n%s\n%s\n%s\n%s\n", "Your custom material can have any of the following surface finishes:", "[1] Ground", "[2] Machined", "[3] Cold-Drawn (CD)", "[4] Hot-rolled (HR)", "[5] As-forged");
    mat_modi = input("Input your desired material surface finish [1-5]:");
    while isempty(mat_modi) == 1 || mat_modi < 1 || mat_modi > 5 || mod(mat_modi,1) ~= 0
        clc
        fprintf("DEFINE MATERIAL \n\n");
        fprintf("Please input a valid option. \n");
         fprintf("%s\n%s\n%s\n%s\n%s\n%s\n", "Your custom material can have any of the following surface finishes:", "[1] Ground", "[2] Machined", "[3] Cold-Drawn (CD)", "[4] Hot-rolled (HR)", "[5] As-forged");
        mat_modi = input("Input your desired material surface finish [1-5]:");
    end
    mat_modi_n = ["Ground", "Machined", "CD", "HR", "As-forged"];
    mat = "CUSTOM";
    modi = mat_modi_n(mat_modi);

    status2 = 1;

end



end
