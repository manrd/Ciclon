%% Configuration

%% Simple Rotation analisys
disp(' ')
disp('Performing Steady-state "Rotate"...')
disp(' ')



%% Configuration

Alpha=0*pi/180;
Beta=0*pi/180;

firstType=2; % 1 - Line output only, 2 - Plots, 3 - Show nothing           era 1
secondType=3;
thirdType=2;

Elevator=1; %1 for positive reference, -1 for negative reference

Para1=1; % 1-3, Seconds of command, 4 Rate, 5 Achieved Angle
Para2=2;

Conditions.Control_Duration=15;
Conditions.Target=1*pi/180;
Conditions.ControlSurface=2; %2, elevator

target1=1*pi/180; %sweep target for run 1
target2=10*pi/180; %sweep target for run 2

alpharef_delta=1*pi/180;

%% Simple Elevator autority analisys

[Conditions.rho,~,~,~]=ISA(Op_Points(FCT).h);

if config.UseTheAirbus == 1
    %--Airbus A300 Debug--% (Comment or left out for normal execution)
    Conditions.Cm_q=-35.44; %Static Cm_q for the condition %A3
    Cm_de=-0.771; %Absolute contribution %3
    %--end of Debug--%
else
    
    %%%%Prepare Analisys (normal execution)
    Reynolds=Op_Points(FCT).V*Conditions.rho*aircraft.c/(17.2*10^-6);
%     Elevator=1; %1 for positive reference, -1 for negative reference
    
    load(config.CAFile)
    Conditions.Cm_q = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Derivatives.Cm_q,Alpha,Beta,Reynolds,'linear');
    if Elevator >= 0
        Cm_de = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Matrices.dpCm_Pitch,Alpha,Beta,Reynolds,'linear');
    else
        Cm_de = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Matrices.dnCm_Pitch,Alpha,Beta,Reynolds,'linear');
    end
    
    [~,~,Cm1,~,~,~] = CAero_read(Trimmed_Cond(Flight_Cond).X_eq,[0 0 0 0],Flight_Cond);
    
    n_X=Trimmed_Cond(Flight_Cond).X_eq;
    n_X(2)=n_X(2)-alpharef_delta;
    
    [~,~,Cm2,~,~,~] = CAero_read(n_X,[0 0 0 0],Flight_Cond);
    Cm_a=(-Cm2+Cm1)*180/pi;
 
    Conditions.Cm_a=Cm_a;
    
    n_Xa=Trimmed_Cond(Flight_Cond).X_eq;
    n_Xa(2)=0;
    
    [CL0,~,~,~,~,~] = CAero_read(n_Xa,[0 0 0 0],Flight_Cond);
    

    n_Xa(2)=n_Xa(2)+alpharef_delta;
    
    [CL2,~,~,~,~,~] = CAero_read(n_Xa,[0 0 0 0],Flight_Cond);
    CL_a=(CL2-CL0)*180/pi;
 
    Conditions.CL_a=CL_a;
    Conditions.CL_0=CL0;
    
end
Conditions.V=Op_Points(FCT).V;
Conditions.S=aircraft.S;
Conditions.c=aircraft.c;
Conditions.Iyy=aircraft.Iyy;
% Conditions.Control_Duration=1;
Conditions.Para=Para1;
Conditions.Target=target1;
% Conditions.ControlSurface=2;

%%%% Analize Current data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Conditions.Type=firstType; % 1 - Line output only, 2 - Plots, 3 - Show nothing
Simple_Rotate_Control(Cm_de,Conditions,Flight_Cond);

% % % % % % % % % % % % %%%% Sweep for minimun control contribution requirement %%%%%%%%%%%%
% % % % % % % % % % % % Conditions.Type=secondType; % 1 - Line output only, 2 - Plots, 3 - Show nothing
% % % % % % % % % % % % 
% % % % % % % % % % % % %Set sweep target
% % % % % % % % % % % % Conditions.Para=Para2; % 1-3, Seconds of command, 4 Rate, 5 Achieved Angle
% % % % % % % % % % % % Conditions.Target=target2;
% % % % % % % % % % % % 
% % % % % % % % % % % % %Run sweep
% % % % % % % % % % % % Req_Cm_de = fsolve(@Simple_Pitch_Control,0,options,Conditions);
% % % % % % % % % % % % 
% % % % % % % % % % % % %%%%%%% Analize the solution encountered %%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % % % % % % % Conditions.Type=thirdType;
% % % % % % % % % % % % Simple_Pitch_Control(Req_Cm_de,Conditions);







%% OLD routine
% % % % % %% Configuration
% % % % % 
% % % % % IES1=1;   
% % % % % IES2=0;
% % % % % 
% % % % % %% Simple Rotation analisys
% % % % % config.isElevsearch=IES1;   
% % % % % 
% % % % % % TOR_Elevator(-0.5,FCT,Op_Points)
% % % % %     TOTrimming_Script
% % % % % 
% % % % % %Run sweep
% % % % % % Req_Cm_de = fsolve(@TOR_Elevator,0.4,options,FCT,Op_Points)
% % % % % % Req_Cm_de = lsqnonlin(@TOR_Elevator,0.2,0.1,0.3,options,FCT,Op_Points)
% % % % % 
% % % % % config.isElevsearch=IES2;
% % % % % % % disp(' ')
% % % % % % % disp('Simulating trimmed rotated Take-off...')
% % % % % % % 
% % % % % % % dt = 0.05;
% % % % % % % tf = 20;
% % % % % % % T_vec = 0:dt:tf;
% % % % % % % 
% % % % % % % X0 = TOTrimmed_Cond(FCT).X_eq;
% % % % % % % % X0(11) = X0(11) + 30*pi/180; %Initial alpha forced
% % % % % % % U0 = TOTrimmed_Cond(FCT).U_eq;
% % % % % % % X_sol = ode4(@TO_Rotadynamics, T_vec, X0, U0, FCT);
% % % % % 
% % % % % % % plot_path;
% % % % % % % plot_long;
% % % % % % % plot_latdir;
% % % % % % plot_control;