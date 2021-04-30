%% Configuration

%Set simulation timeframe
dt = 0.05; %Time step
tf = 60; %Total Flight Time




%% Free flight simulation
disp(' ')
disp('Simulating trimmed Free Flight...')

%Prepare Time vector
T_vec = 0:dt:tf;

%Load Initial conditions
X0 = Trimmed_Cond(FCT).X_eq;
U0 = Trimmed_Cond(FCT).U_eq;

%Force changes in some initial states
% X0(11) = X0(11) + 30*pi/180; %Initial forced state

%Run Solver
X_sol = ode4(@dynamics, T_vec, X0, U0, FCT);

%Call plot scripts
plot_path;
plot_long;
plot_latdir;
% plot_control;

disp(' ')
disp('Done!')