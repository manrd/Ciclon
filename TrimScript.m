
% disp(' ')
% disp('Flight Dynamics (6DoF)')
% 
% global aircraft g recording config A6 B6
% 
% g = 9.80665;
% 
% recording=[];
% 
% aircraft.altecoef=18;

%Aileron command
% config.maneouver=0; %0 for fixed, 1 for single input, 2 for doublet
% 
% config.ap=0*pi/180; %Command deflection
% config.ti=0; %initial time
% config.tf=20; %final time
% config.td=(config.ti+config.tf)/2; %doublet switchover time

%% Aircraft Data

% aircraft = struct(  'S',260,...
%                     'c',6.6,...
%                     'b',44.8,...
%                     'm',130000,...
%                     'Iyy',10.53e6,...
%                     'Izz',15.73e6,... 
%                     'Ixz',0.33e6,...
%                     'Ixx',6.011e6,...
%                     'i_p_rad',2.17*pi/180,...
%                     't_p_rad',0*pi/180,...
%                     'x_p',0,...
%                     'y_p',0,...
%                     'z_p',2.65); %Airbus A300
% disp(' ')
% disp('Aircraft Model: Airbus A300')
                
Op_Points(1) = struct(  'V',15,...
                        'h',648,...
                        'gamma_rad',0*pi/180,...
                        'psidot_rad_s',0*pi/180,... 
                        'thetadot_rad_s',0); %A300 A1 
% Op_Points(2) = struct(  'V',131.5,...
%                         'h',3000,...
%                         'gamma_rad',0,...
%                         'psidot_rad_s',0*pi/180,... 
%                         'thetadot_rad_s',0); %A300 A2
% Op_Points(3) = struct(  'V',264,...
%                         'h',10000,...
%                         'gamma_rad',0,...
%                         'psidot_rad_s',0*pi/180,... 
%                         'thetadot_rad_s',0); %A300 A3 

%% Trim the Aircraft for given flight conditions
% disp(' ')
% disp('Trimming the aircraft for all 3 flight conditions...')
% disp(' ')
Flight_Cond=1;
Trimmed_Cond(1) = struct('X_eq',zeros(12,1),'U_eq',zeros(4,1));

options = optimset('Display','off','TolX',1e-10,'TolFun',1e-10);
                     
load_system('CSim6_C1');

     %Trim_Vector=x_eq_0
    Trim_Vector = zeros(13,1); %%%%%%%%%%%%%%%%%%%% req 10, quiza org 8
    Trim_Vector(1) = Op_Points(Flight_Cond).V;

    Trimmed_Vector = fsolve(@trim_function_c1,Trim_Vector,options,Op_Points,Flight_Cond);
    [~,X_eq,U_eq] = trim_function_c1(Trimmed_Vector,Op_Points,Flight_Cond);
    
    Trimmed_Cond(Flight_Cond).X_eq = X_eq;
    Trimmed_Cond(Flight_Cond).U_eq = U_eq;

%     fprintf('----- A%d FLIGHT CONDITION -----\n\n',Flight_Cond);
%     fprintf('   %-10s = %10.4f %-4s\n','gamma',Op_Points(Flight_Cond).gamma_rad*180/pi,'deg');
%     fprintf('   %-10s = %10.4f %-4s\n','theta_dot',Op_Points(Flight_Cond).thetadot_rad_s*180/pi,'deg/s');
%     fprintf('\n');
%     fprintf('   %-10s = %10.2f %-4s\n','V',X_eq(1),'m/s');
%     fprintf('   %-10s = %10.4f %-4s\n','alpha',X_eq(2)*180/pi,'deg');
%     fprintf('   %-10s = %10.4f %-4s\n','q',X_eq(3)*180/pi,'deg/s');
%     fprintf('   %-10s = %10.4f %-4s\n','theta',X_eq(4)*180/pi,'deg');
%     fprintf('   %-10s = %10.1f %-4s\n','H',X_eq(5),'m');
%     fprintf('\n');
%     fprintf('   %-10s = %10.2f %-4s\n','Thrust',U_eq(1),'N');
%     fprintf('   %-10s = %10.4f %-4s\n','delta_e',U_eq(2)*180/pi,'deg');
%     fprintf('\n');
