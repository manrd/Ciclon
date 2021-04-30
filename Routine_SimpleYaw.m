%% Configuration
Alpha=0*pi/180;
Beta=0*pi/180;
Rudder=1; %1 for positive reference, -1 for negative reference

Conditions.Control_Duration=1;
Para1=1;
Para2=1;

Conditions.ControlSurface=3;

Target1=1*pi/180;
Target2=10*pi/180;

Type1=2; %1
Type2=3;
Type3=2;
Type4=2;

%% Simple Rudder autorithy analisys

[Conditions.rho,~,~,~]=ISA(Op_Points(FCT).h);

if config.UseTheAirbus == 1
    %--Airbus A300 Debug--% (Comment for normal execution)
% % %     Conditions.Cn_r=-0.294; %Static Cm_q for the condition %A3
% % %     Cn_dr=-0.101; %Absolute contribution %A3
    %--end of Debug--%
    
else
    %%%%Prepare Analisys (Uncoment for normal execution)
    
%     Alpha=0*pi/180;
%     Beta=0*pi/180;
    Reynolds=Op_Points(FCT).V*Conditions.rho*aircraft.c/(17.2*10^-6);
%     Rudder=1; %1 for positive reference, -1 for negative reference
    
    load(config.CAFile)
    Conditions.Cn_r = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Derivatives.Cn_r,Alpha,Beta,Reynolds,'linear');
    if Rudder >= 0
        Cn_dr = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Matrices.dpCn_Yaw,Alpha,Beta,Reynolds,'linear');
    else
        Cn_dr = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Matrices.dnCn_Yaw,Alpha,Beta,Reynolds,'linear');
    end
end

Conditions.V=Op_Points(FCT).V;
Conditions.S=aircraft.S;
Conditions.b=aircraft.b;
Conditions.Izz=aircraft.Izz;
% Conditions.Control_Duration=1;
Conditions.Para=Para1;
Conditions.Target=Target1;
% Conditions.ControlSurface=3;

%%%% Analize Current data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Conditions.Type=Type1; % 1 - Line output only, 2 - Plots, 3 - Show nothing
Simple_Yaw_Control(Cn_dr,Conditions);

if false

%%%% Sweep for minimun control contribution requirement %%%%%%%%%%%%
Conditions.Type=Type2; % 1 - Line output only, 2 - Plots, 3 - Show nothing

%Set sweep target
Conditions.Para=Para2; % 1-3, Seconds of command, 4 Rate, 5 Achieved Angle
Conditions.Target=Target2;

%Run sweep
Req_Cn_dr = fsolve(@Simple_Yaw_Control,0,options,Conditions);

%%%%%%% Analize the solution encountered %%%%%%%%%%%%%%%%%%%%%%%%%%%
Conditions.Type=Type3;
Simple_Yaw_Control(Req_Cn_dr,Conditions);

end

%%%% Rudder Roll Analisys (Current Geometry)
% % disp('Rudder Roll')

if config.UseTheAirbus == 1
    %--Airbus A300 Debug--% (Comment for normal execution)
% % % %     Conditions.Cl_p=-0.426; %Static Cl_p for the condition %A3
% % % %     Cl_dr=0.0193; %Absolute contribution %A3
    %--end of Debug--%
else
    Conditions.Cl_p = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Derivatives.Cl_p,Alpha,Beta,Reynolds,'linear');
    if Rudder >= 0
        Cl_dr = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Matrices.dpCl_Yaw,Alpha,Beta,Reynolds,'linear');
    else
        Cl_dr = interpn(Coef_Matrices.C_Index(:,1),Coef_Matrices.C_Index(:,2),Coef_Matrices.C_Index(:,3),Coef_Matrices.dnCl_Yaw,Alpha,Beta,Reynolds,'linear');
    end
end

Conditions.Ixx=aircraft.Ixx;

Conditions.Type=Type4; % 1 - Line output only, 2 - Plots, 3 - Show nothing
Simple_Roll_Control(Cl_dr,Conditions);