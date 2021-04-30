function [F,X,U] = trim_function(Trim_Vector,Op_Points,Flight_Cond)

Op_Points = Op_Points(Flight_Cond);

% X = [V
%     alpha_rad
%     q_rad_s
%     theta_rad
%     h
%     x
%     beta_rad
%     phi_rad
%     p_rad_s
%     r_rad_s
%     psi_rad
%     y];

% U = [T
%     delta_e_rad
%     delta_a_rad
%     delta_r_rad];

X = [Trim_Vector(1:4); Op_Points.h; 0; Trim_Vector(5:9); 0];
U = Trim_Vector(10:13);

%% retorna Xdot y recibe 0,X,U
% Xdot = dynamics(0,X,U,Flight_Cond);

load('Example (C1)'); %% 'CAircraft'
load('CSConfig'); %% Loaded or received?
load('CSTrim'); %% Loaded or received?

load('CSTrimState'); %% Loaded or received?

Trim_in=[0;...
        u(1);...
        u(2);...
        u(3);...
        u(4)];

U

save('CSTrim','Trim_in');

% X = [V         1 x
%     alpha_rad  2 x
%     q_rad_s    3 x
%     theta_rad  4 x
%     h          5 x
%     x          6 x
%     beta_rad   7 x
%     phi_rad    8 x
%     p_rad_s    9 x
%     r_rad_s   10 x
%     psi_rad   11 x
%     y];       12 x

CSConfig.InitVel=[X(1)*cos(Op_Points.gamma_rad) , X(1)*sin(Op_Points.gamma_rad), X(1)*sin(X(7))];
CSConfig.InitRot=[X(9),X(3),X(10)];
CSConfig.InitOr=[X(8),X(4),X(11)];
CSConfig.InitPos=[X(6),X(12),-X(5)];

Csimout=sim('CSim6_C1','SrcWorkspace','current','StopTime',num2str(1));

% % CSim.AAlpha=Csimout.get('AAlpha');
% % CSim.AAlt=Csimout.get('AAlt');
% % CSim.AAng=Csimout.get('AAng');
% % CSim.ABeta=Csimout.get('ABeta');
Xdot = [Csimout.get('Airspeed'),...
    Csimout.get('Alpha'),...
    Csimout.get('q_rs'),...
    Csimout.get('Thetha'),...
    Csimout.get('Altitude'),...
    Csimout.get('X_pos_e'),...
    Csimout.get('Beta'),...
    Csimout.get('Phi'),...
    Csimout.get('p_rs'),...
    Csimout.get('r_rs'),...
    Csimout.get('Psi'),...
    Csimout.get('Y_pos_e')];  

%%
hdot_eq = Op_Points.V*sin(Op_Points.gamma_rad);
xdot_eq = Op_Points.V*cos(Op_Points.gamma_rad);
ydot_eq = 0;

F = [Xdot(1).signals.values(2)
    Xdot(2).signals.values(2)
    Xdot(3).signals.values(2)
    Xdot(4).signals.values(2)-Op_Points.thetadot_rad_s
    Xdot(5).signals.values(2)-hdot_eq
    Xdot(6).signals.values(2)-xdot_eq
    Xdot(7).signals.values(2)
    Xdot(8).signals.values(2)
    Xdot(9).signals.values(2)
    Xdot(10).signals.values(2)
    Xdot(11).signals.values(2)-Op_Points.psidot_rad_s
    Xdot(12).signals.values(2)-ydot_eq
    X(7)];

end
