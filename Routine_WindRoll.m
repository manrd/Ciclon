%% Configuration
Alpha=0*pi/180;
    Beta=0*pi/180;
    
    Aileron=1; %1 for positive reference, -1 for negative reference

    betaref_delta=1*pi/180;
    
Control_Duration1=2;
Para1=1;
Target1=1*pi/180;
ControlSurface1=1;
    

Wind_Duration1=2;

maneouver1=1; %0 for fixed, 1 for single input, 2 for doublet

WindSpeed1=8; %?????????????????????
ap1=-1.18; %Command deflection (absolute)
ti1=2.3; %initial time

WindType1=1;


WindSpeed2=8;
WindBeta1=30*pi/180; %Wind-induced beta
wti1=2; %initial time

Type1=2;
%% Wind Roll Control

[Conditions.rho,~,~,~]=ISA(Op_Points(FCT).h);

if config.UseTheAirbus == 1
    %--Airbus A300 Debug--% (Comment for normal execution)
    Conditions.Cl_p=-0.426; %Static Cl_p for the condition %A3
    Cl_da=-0.0184; %Absolute contribution %3
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
    
    
    
    %%%Prepare Analisys (Uncoment for normal execution)
    [~,~,~,~,Cl1,~] = CAero_read(Trimmed_Cond(Flight_Cond).X_eq,Trimmed_Cond(Flight_Cond).U_eq,Flight_Cond);
    
    n_X=Trimmed_Cond(Flight_Cond).X_eq;
    n_X(7)=n_X(7)+betaref_delta;
    
    [~,~,~,~,Cl2,~] = CAero_read(n_X,Trimmed_Cond(Flight_Cond).U_eq,Flight_Cond);
    Cl_b=(Cl2-Cl1)*180/pi;
 
    Conditions.Cl_b=Cl_b;
end

Conditions.V=Op_Points(FCT).V;
Conditions.S=aircraft.S;
Conditions.b=aircraft.b;
Conditions.Ixx=aircraft.Ixx;
Conditions.Control_Duration=Control_Duration1;
Conditions.Para=Para1;
Conditions.Target=Target1;
Conditions.ControlSurface=ControlSurface1;

Conditions.Wind_Duration=Wind_Duration1;


%Aileron command
config.maneouver=maneouver1; %0 for fixed, 1 for single input, 2 for doublet

% config.ap=-5*pi/180; %Command deflection
config.WindSpeed=WindSpeed1;
config.ap=ap1; %Command deflection (absolute)
config.ti=ti1; %initial time
config.tf=config.ti+Conditions.Control_Duration; %final time
config.td=(config.ti+config.tf)/2; %doublet switchover time


%Wind Gust
config.WindType=WindType1; %0 for fixed, 1 for single input, 2 for doublet

% config.ap=-5*pi/180; %Command deflection
config.WindSpeed=WindSpeed2;
config.WindBeta=WindBeta1; %Wind-induced beta
config.wti=wti1; %initial time
config.wtf=config.wti+Conditions.Wind_Duration; %final time

%%%% Analize Current data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Conditions.Type=Type1; % 1 - Line output only, 2 - Plots, 3 - Show nothing
Wind_Roll_Control(Cl_da,Conditions)