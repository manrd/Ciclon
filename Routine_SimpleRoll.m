%% Configuration
Alpha=0*pi/180;
Beta=0*pi/180;
Aileron=1; %1 for positive reference, -1 for negative reference

Conditions.Control_Duration=1;
Para1=1;
Para2=1;

Conditions.ControlSurface=1;

Target1=1*pi/180;
Target2=80*pi/180;

Type1=2; %1
Type2=3;
Type3=2;
Type4=2;

%% Simple Aileron Autorithy analisys

[Conditions.rho,~,~,~]=ISA(Op_Points(FCT).h);

if config.UseTheAirbus == 1
    %--Airbus A300 Debug--% (Comment for normal execution)
% % %     Conditions.Cl_p=-0.426; %Static Cl_p for the condition %A3
% %     Cl_da=-0.0184; %Absolute contribution %3
    %--end of Debug--%
else
    %%%Prepare Analisys (Uncoment for normal execution)
    
    %     Alpha=0*pi/180;
    %     Beta=0*pi/180;
    Reynolds=Op_Points(FCT).V*Conditions.rho*aircraft.c/(17.2*10^-6);
    %     Aileron=1; %1 for positive reference, -1 for negative reference
    
    load(config.CAFile)
    Conditions.Cl_p = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Derivatives.Cl_p,Alpha,Beta,Reynolds,'linear');
    if Aileron >= 0
        Cl_da = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Matrices.dpCl_Roll,Alpha,Beta,Reynolds,'linear');
    else
        Cl_da = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Matrices.dnCl_Roll,Alpha,Beta,Reynolds,'linear');
    end
end

Conditions.V=Op_Points(FCT).V;
Conditions.S=aircraft.S;
Conditions.b=aircraft.b;
Conditions.Ixx=aircraft.Ixx;
% Conditions.Control_Duration=1;
Conditions.Para=Para1;
Conditions.Target=Target1;
% Conditions.ControlSurface=1;

%%%% Analize Current data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Conditions.Type=Type1; % 1 - Line output only, 2 - Plots, 3 - Show nothing
Simple_Roll_Control(Cl_da,Conditions);
if false
%%%% Sweep for minimun control contribution requirement %%%%%%%%%%%%
Conditions.Type=Type2; % 1 - Line output only, 2 - Plots, 3 - Show nothing

%Set sweep target
Conditions.Para=Para2; % 1-3, Seconds of command, 4 Rate, 5 Achieved Angle
Conditions.Target=Target2;

%Run sweep
Req_Cl_da = fsolve(@Simple_Roll_Control,0,options,Conditions)
% end
%%%%%%% Analize the solution encountered %%%%%%%%%%%%%%%%%%%%%%%%%%%
Conditions.Type=Type3;
Simple_Roll_Control(Req_Cl_da,Conditions);
end
%%%% Aileron Yaw Analisys (Current Geometry)
% % disp('Aileron Yaw')

if config.UseTheAirbus == 1
    %--Airbus A300 Debug--% (Comment for normal execution)
% % % %     Conditions.Cn_r=-0.294; %Static Cm_q for the condition %A3
% % % %     Cn_da=-0.0084; %Absolute contribution %A3
    %--end of Debug--%
else
    Conditions.Cn_r = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Derivatives.Cn_r,Alpha,Beta,Reynolds,'linear');
    if Aileron >= 0
        Cn_da = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Matrices.dpCn_Roll,Alpha,Beta,Reynolds,'linear');
    else
        Cn_da = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Matrices.dnCn_Roll,Alpha,Beta,Reynolds,'linear');
    end
end

Conditions.Izz=aircraft.Izz;

Conditions.Type=Type4; % 1 - Line output only, 2 - Plots, 3 - Show nothing
Simple_Yaw_Control(Cn_da,Conditions);