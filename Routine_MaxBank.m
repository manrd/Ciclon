%% Configuration

%Reference stall alpha?
Alpha_test=15;

Vstart=14; %Initial Airspeed for sweep
Vend=19; %Final Airspeed for sweep
Vqty=100; %Airspeed test points

%% Max Roll angle attaiable for constant altitude

[Conditions.rho,~,~,~]=ISA(Op_Points(FCT).h);
n_X=Trimmed_Cond(Flight_Cond).X_eq;
n_X(2)=Alpha_test*pi/180;

Vp=linspace(Vstart,Vend,Vqty);

for i=1:Vqty
    n_X(1)=Vp(i);
    [CL,~,~,~,~,~] = CAero_read(n_X,Trimmed_Cond(Flight_Cond).U_eq,Flight_Cond);
    L(i)=(1/2)*Conditions.rho*(n_X(1)^2)*aircraft.S*CL;
    if (aircraft.m*g)<(L(i))
        MaxBankAngle(i)=acos(aircraft.m*g/L(i))*180/pi;
    else
        MaxBankAngle(i)=-1;
    end
end

figure('Color',[1 1 1],'Name','Bank Angle Limit');
plot(Vp,MaxBankAngle,'LineWidth',2);
title('Maximun Bank for Constant Altitude')
xlabel('Airspeed [m/s]')
ylabel('phi [deg]')