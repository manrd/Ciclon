%% Configuration

%% Trim the Aircraft for given flight conditions
disp(' ')
disp('Trimming the aircraft...')

%Prepare
Trimmed_Cond(size(FCT,2)) = struct('X_eq',zeros(12,1),'U_eq',zeros(4,1));

%Do Trimming
for Flight_Cond=FCT
    %Pre-alocate tested trim vector
    Trim_Vector = zeros(13,1);
    
    %Set Airspeed to always be the specified airspeed
    Trim_Vector(1) = Op_Points(Flight_Cond).V;
    Trim_Vector(5) = 0*pi/180;
    
    %Call fsolve to find the trim
    Trimmed_Vector = fsolve(@trim_function,Trim_Vector,options,Op_Points,Flight_Cond);
    
    %Extract trimmed initial conditions
    [~,X_eq,U_eq] = trim_function(Trimmed_Vector,Op_Points,Flight_Cond);
    
    Trimmed_Cond(Flight_Cond).X_eq = X_eq;
    Trimmed_Cond(Flight_Cond).U_eq = U_eq;
    
    %Print to Comand line
    fprintf('----- Flight Condition Nº%d-----\n\n',Flight_Cond);
    fprintf('   %-10s = %10.4f %-4s\n','gamma',Op_Points(Flight_Cond).gamma_rad*180/pi,'deg');
    fprintf('   %-10s = %10.4f %-4s\n','theta_dot',Op_Points(Flight_Cond).thetadot_rad_s*180/pi,'deg/s');
    fprintf('   %-10s = %10.4f %-4s\n','psi_dot',Op_Points(Flight_Cond).psidot_rad_s*180/pi,'deg/s');
    fprintf('\n');
    fprintf('   %-10s = %10.2f %-4s\n','V',X_eq(1),'m/s');
    fprintf('   %-10s = %10.4f %-4s\n','alpha',X_eq(2)*180/pi,'deg');
    fprintf('   %-10s = %10.4f %-4s\n','q',X_eq(3)*180/pi,'deg/s');
    fprintf('   %-10s = %10.4f %-4s\n','theta',X_eq(4)*180/pi,'deg');
    fprintf('   %-10s = %10.1f %-4s\n','H',X_eq(5),'m');
    fprintf('\n');
    fprintf('   %-10s = %10.4f %-4s\n','beta',X_eq(7)*180/pi,'deg');
    fprintf('   %-10s = %10.4f %-4s\n','phi',X_eq(8)*180/pi,'deg');
    fprintf('   %-10s = %10.4f %-4s\n','p',X_eq(9)*180/pi,'deg/s');
    fprintf('   %-10s = %10.4f %-4s\n','r',X_eq(10)*180/pi,'deg/s');
    fprintf('   %-10s = %10.4f %-4s\n','psi',X_eq(11)*180/pi,'deg');
    fprintf('\n');
    fprintf('   %-10s = %10.1f %-4s\n','Aileron',U_eq(1)*100,'% Pos');
    fprintf('   %-10s = %10.1f %-4s\n','Elevator',U_eq(2)*100,'% Pos');
    fprintf('   %-10s = %10.1f %-4s\n','Rudder',U_eq(3)*100,'% Pos');
    fprintf('   %-10s = %10.2f %-4s\n','Thrust',U_eq(4),'N');
    fprintf('\n');
end

disp(' ')
disp('Done!')