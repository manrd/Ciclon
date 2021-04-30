%% Configuration

%State variables differential from equilibrium
step_val = 1e-5;


%% Linearization

disp(' ')
disp('Linearizing the model...')

Linearized_Model(size(FCT,2)) = struct('A',zeros(length(X_eq),length(X_eq)),'B',zeros(length(X_eq),length(U_eq)));
Reduced_Model_Long(size(FCT,2)) = struct('A',zeros(4,4));
Reduced_Model_Latdir(size(FCT,2)) = struct('A',zeros(4,4));

for Flight_Cond=FCT
    X_eq = Trimmed_Cond(Flight_Cond).X_eq;
    U_eq = Trimmed_Cond(Flight_Cond).U_eq;
    
    A = zeros(length(X_eq),length(X_eq));
    for j=1:length(X_eq)
        dX = zeros(length(X_eq),1);
        dX(j) = step_val;
        Xdot_plus = dynamics(0,X_eq+dX,U_eq,Flight_Cond);
        Xdot_minus = dynamics(0,X_eq-dX,U_eq,Flight_Cond);
        A(:,j) = (Xdot_plus-Xdot_minus)/(2*step_val);
    end
    
    B = zeros(length(X_eq),length(U_eq));
    for j=1:length(U_eq)
        dU = zeros(length(U_eq),1);
        dU(j) = step_val;
        Xdot_plus = dynamics(0,X_eq,U_eq+dU,Flight_Cond);
        Xdot_minus = dynamics(0,X_eq,U_eq-dU,Flight_Cond);
        B(:,j) = (Xdot_plus-Xdot_minus)/(2*step_val);
    end
    
    Linearized_Model(Flight_Cond).A = A;
    Linearized_Model(Flight_Cond).B = B;
    
    Reduced_Model_Long(Flight_Cond).A = A((1:6),(1:6));
    Reduced_Model_Latdir(Flight_Cond).A = A((7:10),(7:10));
end

disp(' ')
disp('Done!')