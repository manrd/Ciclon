%% Configuration

alpharef_delta=1*pi/180;

%% Static Margin
disp(' ')
    disp('Determining Static Margin...')
    if config.UseTheAirbus == 1
        %--Airbus A300 Debug--% (Comment for normal execution)
        CLa=6.22; %Static Cl_p for the condition %A3
        Cma=-1.081; %Absolute contribution %3
        %--end of Debug--%
    else
        %%%Prepare Analisys (Uncoment for normal execution)
        [CL1,~,Cm1,~,~,~] = CAero_read(Trimmed_Cond(Flight_Cond).X_eq,Trimmed_Cond(Flight_Cond).U_eq,Flight_Cond);
        
        n_X=Trimmed_Cond(Flight_Cond).X_eq;
        n_X(2)=n_X(2)+alpharef_delta;
        
        [CL2,~,Cm2,~,~,~] = CAero_read(n_X,Trimmed_Cond(Flight_Cond).U_eq,Flight_Cond);
        CLa=(CL2-CL1)*180/pi;
        Cma=(Cm2-Cm1)*180/pi;
    end
    Kn=-Cma/CLa;
    disp(' ')
    disp(['Static Margin for this condition: ',num2str(Kn*100),' %'])