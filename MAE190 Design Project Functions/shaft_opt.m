% Shaft Optimization
function [d, j, optcrit, convin, ny, nut, fail, status8] = shaft_opt(M_max, M_min, T_max, T_min, modi, Sut, Sy, n, ke, D_d, r_d, s_unit, T, status1, status2, status3, status4, status5, status6)

fprintf("SHAFT OPTIMIZATION \n\n");

% Verify that shaft optimization will start
if status1 ~= 1 || status2 ~= 1 || status3 ~= 1 || status4 ~= 1 || status5 ~= 1 || status6 ~= 1
    fail = 1;
    fprintf('Please verify that you have done all the previous processes.\n\n')
    proceed = input('Press ENTER to proceed back to the main menu');
    d = []; j = []; optcrit = []; convin = []; ny = []; nut = []; status8 = 0;
    clc
else
    fail = 0; % deactivates cancel message
    j = 1; % initialize iterations
    delta = 1; % initialize convergence

    % Calculate Alternate / Mean Moments / Torques
    Ma = (M_max - M_min)/2; % alternating moment (lb-in / N-m)
    Mm = (M_max + M_min)/2; % mean moment (lb-in / N-m)
    Ta = (T_max - T_min)/2; % alternating torque (lb-in / N-m)
    Tm = (T_max + T_min)/2; % mean torque (lb-in / N-m)

    % Stress Concentration Factors

    if D_d > 1.1 && D_d <= 1.2
        Ab = ((0.97098-0.95120)*(D_d-1.1)/(1.2-1.1))+0.95120;
        bb = ((-0.21796+0.23757)*(D_d-1.1)/(1.2-1.1))-0.23757;
    elseif D_d > 1.2 && D_d <= 1.5
        Ab = ((0.93836-0.97098)*(D_d-1.2)/(1.5-1.2))+0.97098;
        bb = ((-0.25759+0.21796)*(D_d-1.2)/(1.5-1.2))-0.21796;
    elseif D_d > 1.5 && D_d <= 2
        Ab = ((0.90879-0.93836)*(D_d-1.5)/(2-1.5))+0.93836;
        bb = ((-0.28598+0.25759)*(D_d-1.5)/(2-1.5))-0.25759;
    end
    
    if D_d > 1.09 && D_d <= 1.2
        At = ((0.83425-0.90337)*(D_d-1.09)/(1.2-1.09))+0.90337;
        bt = ((-0.21649+0.12692)*(D_d-1.09)/(1.2-1.09))-0.12692;
    elseif D_d > 1.2 && D_d <= 1.33
        At = ((0.84897-0.83425)*(D_d-1.2)/(1.33-1.2))+0.83425;
        bt = ((-0.23161+0.21649)*(D_d-1.2)/(1.33-1.2))-0.21649;
    elseif D_d > 1.33 && D_d <= 2
        At = ((0.86331-0.84897)*(D_d-1.33)/(2-1.33))+0.84897;
        bt = ((-0.23865+0.23161)*(D_d-1.33)/(2-1.33))-0.23161;
    end

    if s_unit == "ksi"
        ra_b = 0.246-3.08*(10^-3)*(Sut*10^-3)+1.51*(10^-5)*(Sut*10^-3)^2-2.67*(10^-8)*(Sut*10^-3)^3; % bending notch sensitivity variable (ksi)
        ra_t = 0.190-2.51*(10^-3)*(Sut*10^-3)+1.35*(10^-5)*(Sut*10^-3)^2-2.67*(10^-8)*(Sut*10^-3)^3; % torsion notch sensitivity variable (ksi)
    elseif s_unit == "MPa"
        ra_b = 1.24-2.25*(10^-3)*(Sut*10^-6)+1.60*(10^-6)*(Sut*10^-6)^2-4.11*(10^-10)*(Sut*10^-6)^3; % bending notch sensitivity variable (MPa)
        ra_t = 0.958-1.83*(10^-3)*(Sut*10^-6)+1.343*(10^-6)*(Sut*10^-6)^2-4.11*(10^-8)*(Sut*10^-6)^3; % torsion notch sensitivity variable (MPa)
    end

    Kt = Ab*(r_d)^bb;
    Kts = At*(r_d)^bt;
    q = 1;
    Kf(j) = 1 + q*(Kt - 1);
    Kfs(j) = 1 + q*(Kts - 1);

    % Marin Factors
    if s_unit == "ksi"
        if modi == "Ground"
            a = 1.21;
            b = -0.067;
        elseif modi == "CD" || modi == "Machined"
            a = 2;
            b = -0.217;
        elseif modi == "HR"
            a = 11.0;
            b = -0.650;
        elseif modi == "As-forged"
            a = 12.7;
            b = -0.758;e
        else
            fail = 1;
            fprintf('Please verify that your material is either a carbon steel, a titanium allow, or a custom material.\n\n')
            proceed = input('Press ENTER to proceed back to the main menu');
            d = []; j = []; optcrit = []; convin = []; ny = []; nut = []; status7 = 0;
            clc
        end
    elseif s_unit == "MPa"
        if modi == "Ground"
            a = 1.38;
            b = -0.067;
        elseif modi == "CD" || modi == "Machined"
            a = 3.04;
            b = -0.217;
        elseif modi == "HR"
            a = 38.6;
            b = -0.650;
        elseif modi == "As-forged"
            a = 54.9;
            b = -0.758;
        else
            fail = 1;
            fprintf('Please verify that your material is either carbon steel or a custom material.\n\n')
            proceed = input('Press ENTER to proceed back to the main menu');
            d = []; j = []; optcrit = []; convin = []; ny = []; nut = []; status7 = 0;
            clc
        end
    end
    ka = a*(Sut)^b; % surface factor
    kb(j) = 0.879; % size factor (initializing for iteration)
    kc = 1; % load factor (moment + torque load factor)
    if s_unit == "ksi"
        kd = 0.98 + 3.5e-4*T - 6.3e-7*T^2;
    elseif s_unit == "MPa"
        kd = 0.99 + 5.9e-4*T - 2.1e-6*T^2;
    end
    kf = 1; % miscellaneous-effects factor

    % Endurance Limits (initializing for iteration)
    if s_unit == "ksi" % ksi to psi
        Sut = Sut*10^3;
        Sy = Sy*10^3;

        if Sut <= 200*10^3
            Se_prime = 0.5*Sut;
        else
            Se_prime = 100*10^3;
        end
    elseif s_unit == "MPa" % MPa to Pa
        Sut = Sut*10^6;
        Sy = Sy*10^6;

        if Sut <= 1400*10^6
            Se_prime = 0.5*Sut;
        else
            Se_prime = 700*10^6;
        end
    end

    Se(j) = ka*kb(j)*kc*kd*ke*kf*Se_prime; % critical location endurance limit (psi / Pa)

    % Criteria Selection
    crit = ["DE-Goodman", "DE-Gerber", "DE-ASME Elliptic", "DE-SWT"];
    fprintf("You may conduct the optimization with the following criteria:\n")
    for i = 1:length(crit)
        fprintf("[%g] %s\n\n", i, crit(i))
    end
    choice = input(['Please select which criteria you would like to use [1-' num2str(length(crit)) ']: ']);
    while isempty(choice) == 1 || (choice < 1 || choice > length(crit)) || mod(choice,1) ~= 0
        clc
        fprintf("SHAFT OPTIMIZATION \n\n");
        fprintf("Please input a valid option. \n\n");
        fprintf("You may conduct the optimization with the following criteria:\n")
        for i = 1:length(crit)
            fprintf("[%g] %s\n\n", i, crit(i))
        end
        choice = input('Please select which criteria you would like to use [1-3]:');
    end
    optcrit = crit(choice);

    % Convergence Selection
    clc
    fprintf("SHAFT OPTIMIZATION \n\n");
    convin = input('Please input your desired convergence limit [in %]:');
    while isempty(convin) == 1 || convin < 0
        clc
        fprintf("SHAFT OPTIMIZATION \n\n");
        fprintf("Please input a valid option. \n\n");
        convin = input('Please input your desired convergence limit [in %]:');
    end
    conv = convin/100;

    % Diameter Calculation via Distortion Energy Equations (initializing for iteration)
        A(j) = sqrt((4*(Kf(j)*Ma)^2) + (3*(Kfs(j)*Ta)^2));
        B(j) = sqrt((4*(Kf(j)*Mm)^2) + (3*(Kfs(j)*Tm)^2));
    if choice == 1 % DE-Goodman
        d(j) = ((16*n/pi)*((A(j)/Se(j))+(B(j)/Sut)))^(1/3);
        % d(j) = ((16*n/pi)*((1/(Se(j)))*(4*(Kf(j)*Ma)^2+3*(Kfs(j)*Ta)^2)^(0.5)+(1/(Sut))*(4*(Kf(j)*Mm)^2+3*(Kfs(j)*Tm)^2)^(0.5)))^(1/3);
    elseif choice == 2 % DE-Gerber
        d(j) = ((8*n*A(j)/(pi*Se(j)))*(1+sqrt(1+(2*B(j)*Se(j)/(A(j)*Sut))^2)))^(1/3);
    elseif choice == 3 % DE-ASME Elliptic
        d(j) = (16*n/pi*sqrt((4*(Kf(j)*Ma/Se(j))^2)+(3*(Kfs(j)*Ta/Se(j))^2)+(4*(Kf(j)*Mm/Sy)^2)+(3*(Kfs(j)*Tm/Sy)^2)))^(1/3);
    elseif choice == 4 % DE-SWT
        d(j) = ((16*n/(pi*Se(j)))*sqrt((A(j)^2)+(A(j)*B(j))))^(1/3);
    end

    % Unit Conversion
    if s_unit == "ksi"
        % diameter is already in in
    elseif  s_unit == "MPa"
        d(j) = d(j)*10^3; % converts diameter from m to mm
    end

    % Iteration Process
    while delta > conv % convergence condition (modify for more precise data)        
        if s_unit == "ksi"
            siga(j) = sqrt((32*Kf(j)*Ma/(pi*d(j)^3))^2+(3*(16*Kfs(j)*Ta/(pi*d(j)^3))^2));
            sigm(j) = sqrt((32*Kf(j)*Mm/(pi*d(j)^3))^2+(3*(16*Kfs(j)*Tm/(pi*d(j)^3))^2));
        elseif s_unit == "MPa"
            siga(j) = sqrt((32*Kf(j)*Ma/(pi*(d(j)*10^-3)^3))^2+(3*(16*Kfs(j)*Ta/(pi*(d(j)*10^-3)^3))^2));
            sigm(j) = sqrt((32*Kf(j)*Mm/(pi*(d(j)*10^-3)^3))^2+(3*(16*Kfs(j)*Tm/(pi*(d(j)*10^-3)^3))^2));
        end

        ny(j) = Sy/(siga(j)+sigm(j));
        nut(j) = Sut/(siga(j)+sigm(j));

        if ny(j) < n
            fprintf("The Yielding Factor of Safety is less than the Defined Fatigue Factor of Safety - DESIGN IS NOT VIABLE\n\n")
            break
        elseif nut(j) < n
            fprintf("The Ultimate Tensile Factor of Safety is less than the Defined Fatigue Factor of Safety - DESIGN IS NOT VIABLE\n\n")
            break
        end

        % modify size factor for next iteration
        if s_unit == "ksi"
            if d(j) <= 2 && d(j) >= 0.3 % diameter (in)
                kb(j+1) = 0.879*d(j)^-0.107;
            elseif d(j) > 2 && d(j) <= 10 % diameter (in)
                kb(j+1) = 0.91*d(j)^-0.157;
            else
                fprintf("The iterative diameter is not within size factor constraints - DESIGN IS NOT VIABLE\n\n")
                break
            end
        elseif s_unit == "MPa"
            if d(j) <= 51 && d(j) >= 7.62 % diameter (mm)
                kb(j+1) = 1.24*d(j)^-0.107;
            elseif d(j) > 51 && d(j) <= 254 % diameter (mm)
                kb(j+1) = 1.51*d(j)^-0.157;
            else
                fprintf("The iterative diameter is not within size factor constraints - DESIGN IS NOT VIABLE\n\n")
                break
            end
        end
        Se(j+1) = ka*kb(j+1)*kc*kd*ke*kf*Se_prime; % critical location endurance limit
        r(j) = r_d*d(j); % fillet radius based on r/d ratio and iterative diameter

        Kf(j+1) = 1+((Kt-1)/(1+(ra_b/sqrt(r(j)))));
        Kfs(j+1) = 1+((Kts-1)/(1+(ra_t/sqrt(r(j)))));

        A(j+1) = sqrt((4*(Kf(j+1)*Ma)^2) + (3*(Kfs(j+1)*Ta)^2));
        B(j+1) = sqrt((4*(Kf(j+1)*Mm)^2) + (3*(Kfs(j+1)*Tm)^2));
        if choice == 1
            d(j+1) = ((16*n/pi)*((A(j+1)/Se(j+1))+(B(j+1)/Sut)))^(1/3);
            % d(j+1) = ((16*n/pi)*((1/(Se(j+1)))*(4*(Kf(j+1)*Ma)^2+3*(Kfs(j+1)*Ta)^2)^(0.5)+(1/(Sut))*(4*(Kf(j+1)*Mm)^2+3*(Kfs(j+1)*Tm)^2)^(0.5)))^(1/3);
        elseif choice == 2
            d(j+1) = ((8*n*A(j+1)/(pi*Se(j+1)))*(1+sqrt(1+(2*B(j+1)*Se(j+1)/(A(j+1)*Sut))^2)))^(1/3);
        elseif choice == 3
            d(j+1) = ((16*n/pi)*sqrt((4*(Kf(j+1)*Ma/Se(j+1))^2)+(3*(Kfs(j+1)*Ta/Se(j+1))^2)+(4*(Kf(j+1)*Mm/Sy)^2)+(3*(Kfs(j+1)*Tm/Sy)^2)))^(1/3);
        elseif choice == 4 % DE-SWT
            d(j+1) = ((16*n/(pi*Se(j+1)))*sqrt((A(j+1)^2)+(A(j+1)*B(j+1))))^(1/3);
        end

        if s_unit == "ksi"
            % diameter is already in in
        elseif  s_unit == "MPa"
            d(j+1) = d(j+1)*10^3; % converts diameter from m to mm
        end
        delta = abs(d(j+1)-d(j))/d(j); % convergence calculation
        j = j + 1; % number of iterations
    end
status8 = 1;
end
end