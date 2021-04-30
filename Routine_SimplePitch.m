%% Configuration

Alpha=0*pi/180;
Beta=0*pi/180;

firstType=2; %1 % 1 - Line output only, 2 - Plots, 3 - Show nothing
secondType=3;
thirdType=2;

Elevator=1; %1 for positive reference, -1 for negative reference

Para1=1; % 1-3, Seconds of command, 4 Rate, 5 Achieved Angle
Para2=2;

Conditions.Control_Duration=1;
Conditions.Target=1*pi/180;
Conditions.ControlSurface=2; %2, elevator

target1=1*pi/180; %sweep target for run 1
target2=10*pi/180; %sweep target for run 2



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
Simple_Pitch_Control(Cm_de,Conditions);
return
% % % %%%% Sweep for minimun control contribution requirement %%%%%%%%%%%%
% % % Conditions.Type=secondType; % 1 - Line output only, 2 - Plots, 3 - Show nothing
% % % 
% % % %Set sweep target
% % % Conditions.Para=Para2; % 1-3, Seconds of command, 4 Rate, 5 Achieved Angle
% % % Conditions.Target=target2;
% % % 
% % % %Run sweep
% % % Req_Cm_de = fsolve(@Simple_Pitch_Control,0,options,Conditions);
% % % 
% % % %%%%%%% Analize the solution encountered %%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % Conditions.Type=thirdType;
% % % Simple_Pitch_Control(Req_Cm_de,Conditions);
