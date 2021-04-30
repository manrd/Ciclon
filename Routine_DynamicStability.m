%% Configuration

% Set the indexes for each mode on the Eigenvalues matrix

%Longitudinal modes
sp=[2 3]; %Short period pair
% lp=[6 7]; %Long Period pair
lp=[4 5]; %Long Period pair

%Latero-Directional modes
DutchRoll=[2 3]; %Dutch Roll pair
PureRoll=1; %Pure Roll mode
Spiral=4; %Spiral mode  %%% UNSURE ABOUT THIS ONE, 11 or 12 maybe

% THIS ROUTINE NEEDS IN-DEEP CHECK

disp(' ')
disp('Dynamic Stability Computation')

%% Longitudinal Dynamic Stability

%Preparations for Dynamic Stability


[eigenvectors,eigenvalues] = eig(Reduced_Model_Long(Flight_Cond).A);



% [eigenvectors,eigenvalues] = eig(Linearized_Model(Flight_Cond).A);


ldsi=[sp lp];

LP_Eigenvalues=[];
SP_Eigenvalues=[];

% % % % data.eigenvalues=eigenvalues;
% % % % data.eigenvectors=eigenvectors;

%Test if Short Period eigenvalues are a pair
ave1=imag(eigenvalues(sp(1),sp(1)))+imag(eigenvalues(sp(2),sp(2)));
ave2=real(eigenvalues(sp(1),sp(1)))-real(eigenvalues(sp(2),sp(2)));

%Test stability of Short Period
if (ave1==0)&&(ave2==0)
    SP_Eigenvalues=eigenvalues(sp(1),sp(1));
    if real(SP_Eigenvalues)<0
       stab='Stable: '; 
    elseif real(SP_Eigenvalues)==0
       stab='Non-oscilatory: ';
    else
       stab='Unstable: ';
    end
    disp(' ')
    disp(['Short period OK, ',stab,num2str(SP_Eigenvalues)])
else
    disp(' ')
    disp('Short period FAIL (Check index or data)')
end

%Test if Long Period eigenvalues are a pair
ave1=imag(eigenvalues(lp(1),lp(1)))+imag(eigenvalues(lp(2),lp(2)));
ave2=real(eigenvalues(lp(1),lp(1)))-real(eigenvalues(lp(2),lp(2)));

%Test stability of Long Period
if (ave1==0)&&(ave2==0)
    LP_Eigenvalues=eigenvalues(lp(1),lp(1));
    if real(LP_Eigenvalues)<0
       stab='Stable: ';
    elseif real(LP_Eigenvalues)==0
        stab='Non-oscilatory: ';
    else
       stab='Unstable: ';
    end
    disp(' ')
    disp(['Long period OK, ',stab,num2str(LP_Eigenvalues)])
else
    disp(' ')
    disp('Long period FAIL (Check index or data)')
end

%%Calculations for Dynamic Stability (MUST CHECK IF IT HAS THE CORRECTION!)

[rtc_wn,rtc_z]=damp(eigenvalues);

disp(' ')
disp(['Order of data:     ','Short period','   ','Long period'])
Long_Eigenvalues=[SP_Eigenvalues LP_Eigenvalues];

%natural frequency
wn=sqrt(real(Long_Eigenvalues).^2+imag(Long_Eigenvalues).^2);
% rtc_wn(ldsi); %Alternative calculation (will output 4 values)
disp(['Natural Frequency (Hz): ',num2str(wn)])

%damping ratio
d=-real(Long_Eigenvalues)./wn;
% rtc_z(ldsi); %Alternative calculation (will output 4 values)
disp(['Damping Ratio: ',num2str(d)])

%period
tau=2*pi()./imag(Long_Eigenvalues);
disp(['Period (s): ',num2str(tau)])

%half life gamma
thalf=log(2)./(d.*wn);
disp(['Time to half or double amplitude (s): ',num2str(thalf)])

%n for half
nhalf=(0.11).*sqrt(1-d.^2)./abs(d);
disp(['Cycles to half or double amplitude (n): ',num2str(nhalf)])

% % % % data.wn=wn;
% % % % data.d=d;
% % % % 
% % % % config.td=data;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot eigenvalues

if true
    if exist('figure1','var')
    else
        figure1=[];
    end
if ishandle(figure1)
    figure(figure1)
else
figure1=figure(71);
set(figure1,'Color',[1 1 1],'Name','Eigenvalues');
% Create axes
axes1 = axes('Parent',figure1);

box(axes1,'on');
hold(axes1,'all');
end
% Create plot
hold on
for i = 1:size(ldsi,2)
plot(real(eigenvalues(ldsi(i),ldsi(i))),imag(eigenvalues(ldsi(i),ldsi(i))),'MarkerFaceColor',[1 1 0],'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',10,...
    'Marker','diamond',...
    'LineStyle','none');
end
hold off

line([0,0],ylim(),'LineWidth',2,...
    'Color',[0.87058824300766 0.490196079015732 0])
line(xlim(),[0,0],'LineWidth',2,...
    'Color',[0.87058824300766 0.490196079015732 0])

hold on
for i = 1:size(ldsi,2)
plot(real(eigenvalues(ldsi(i),ldsi(i))),imag(eigenvalues(ldsi(i),ldsi(i))),'MarkerFaceColor',[1 1 0],'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',10,...
    'Marker','diamond',...
    'LineStyle','none');
end
hold off

% Create xlabel
xlabel('Real');

% Create ylabel
ylabel('Imaginary');

title('Longitudinal Dynamic Stability Eigenvalues');
end
%% Latero directional dynamic stability

[eigenvectors,eigenvalues] = eig(Reduced_Model_Latdir(Flight_Cond).A);

%Test if Dutch Roll eigenvalues are a pair
ave1=imag(eigenvalues(DutchRoll(1),DutchRoll(1)))+imag(eigenvalues(DutchRoll(2),DutchRoll(2)));
ave2=real(eigenvalues(DutchRoll(1),DutchRoll(1)))-real(eigenvalues(DutchRoll(2),DutchRoll(2)));

%Test stability of Dutch Roll
if (ave1==0)&&(ave2==0)
    DR_Eigenvalues=eigenvalues(DutchRoll(1),DutchRoll(1));
    if real(DR_Eigenvalues)<0
       stab='Stable: '; 
    elseif imag(DR_Eigenvalues)==0
       stab='Non-oscilatory: ';
    else
       stab='Unstable: ';
    end
    disp(' ')
    disp(['Dutch Roll OK, ',stab,num2str(DR_Eigenvalues)])
else
    disp(' ')
    disp('Dutch Roll FAIL (Check index or data)')
end




% Tau=1./(Wn(DutchRoll(1)).*zeta(DutchRoll(1)));
% 
% disp(['Time Constant:   ',num2str(Tau),' (s)'])
% disp(['Natural Freq.:   ',num2str(Wn(DutchRoll(1))),' (rad/s)   Damping:  ',num2str(zeta(DutchRoll(1)))])
    






PR_Eigenvalues=eigenvalues(PureRoll(1),PureRoll(1));
if real(PR_Eigenvalues)<0
    stab='Stable: ';
elseif imag(PR_Eigenvalues)==0
    stab='Non-oscilatory: ';
else
    stab='Unstable: ';
end
disp(' ')
disp(['Pure Roll OK, ',stab,num2str(PR_Eigenvalues)])

%     eig(Linearized_Model(Flight_Cond).A)
%     [~,XEvalues] = eig(Linearized_Model(Flight_Cond).A);
% % % [rtc_wn,rtc_z]=damp(XEvalues);
% Tau=1./(rtc_wn.*rtc_z);
% disp(['Pure Roll Time Constant (Complete): ',num2str(Tau(PureRoll))])





SR_Eigenvalues=eigenvalues(Spiral(1),Spiral(1));
if real(SR_Eigenvalues)<0
    stab='Stable: ';
elseif imag(SR_Eigenvalues)==0
    stab='Non-oscilatory: ';
else
    stab='Unstable: ';
end
disp(' ')
disp(['Spiral OK, ',stab,num2str(SR_Eigenvalues)])


[Wn,zeta]=damp(eigenvalues);



latdirsi=[DutchRoll PureRoll Spiral];
% latdirsi=[8 9 10 11];


disp(' ')
disp(['Order of data:                          ','Dutch Roll','    ','Pure Roll','    ','Spiral'])
for i = size(latdirsi,2):-1:1
%     eiglatdir(i)=eigenvalues(latdirsi(i),latdirsi(i));
    eiglatdir(i)=eigenvalues(i,i);
end

%natural frequency
wn=sqrt(real(eiglatdir).^2+imag(eiglatdir).^2);
disp(['Natural Frequency (Hz):                 ',num2str(Wn(DutchRoll(1))),'  ',num2str(Wn(PureRoll)),'  ',num2str(Wn(Spiral))])

%damping ratio
d=-real(eiglatdir)./wn;
disp(['Damping Ratio:                          ',num2str(zeta(DutchRoll(1))),'         ',num2str(zeta(PureRoll)),'         ',num2str(zeta(Spiral))])

%period
tau=2*pi()./imag(eiglatdir);
disp(['Period (s):                             ',num2str(1/Wn(DutchRoll(1))),'  ',num2str(1/Wn(PureRoll)),'  ',num2str(1/Wn(Spiral))])

%half life gamma
thalf=log(2)./(zeta.*Wn);
disp(['Time to half or double amplitude (s):   ',num2str(thalf(DutchRoll(1))),'   ',num2str(thalf(PureRoll)),'   ',num2str(thalf(Spiral))])

%n for half
nhalf=(0.11).*sqrt(1-zeta.^2)./abs(zeta);
disp(['Cycles to half or double amplitude (n): ',num2str(nhalf(DutchRoll(1))),'         ',num2str(nhalf(PureRoll)),'         ',num2str(nhalf(Spiral))])

%Time constant
Tau=1./(Wn.*zeta);
disp(['Time Constant (s):                      ',num2str(Tau(DutchRoll(1))),'           ',num2str(Tau(PureRoll)),'           ',num2str(Tau(Spiral))])

% (DutchRoll(1)
% (DutchRoll(1)

% data.wn=wn;
% data.d=d;

% config.td=data;

% % % wnrs=wn* 2*pi;
% % % disp(['              '])
% % % disp(['Converted: Spiral Natural Frequency (rad/s): ',num2str(wnrs(1)),'   Damping Ratio: ',num2str(d(1))])
% % % disp(['Converted: Dutch R. Natural Frequency (rad/s): ',num2str(wnrs(2)),'   Damping Ratio: ',num2str(d(2))])
% % % disp(['Converted: P. Roll Natural Frequency (rad/s): ',num2str(wnrs(3)),'   Damping Ratio: ',num2str(d(3))])
%el 1 de wnrs vario.... el dr solo vario con clp del 1....



% % %For the time constant
% % % [~,XEvalues] = eig(Linearized_Model(Flight_Cond).A);
% % [~,XEvalues] = eig(Linearized_Model(Flight_Cond).A);
% % tc=1./XEvalues;
% % rtc=-real(tc);
% % % mn=7;
% % mn=4; %pure roll
% % disp(' ')
% % 
% % disp(['Pure Roll Time Constant: ',num2str(rtc(mn,mn))])



% % damp(Linearized_Model(Flight_Cond).A)
% % % % % damp(Reduced_Model(Flight_Cond).A)

% damp(Linearized_Model(Flight_Cond).A)
% [Wn,zeta] = damp(H); %¨wn: natural frequency, zeta_damping ratio
% tau = 1./(zeta.*Wn); %time constant











if true

%Plot Latdir eigens

% % [eigenvectors,eigenvalues] = eig(A);

% latdirsi=[DutchRoll PureRoll Spiral];
% latdirsi=[8 9 10 11];

%%Plot eigenvalues
if exist('figure2','var')
    else
        figure2=[];
    end
if ishandle(figure2)
    figure(figure2)
else
figure2=figure(72);
set(figure2,'Color',[1 1 1],'Name','Eigenvalues');

% Create axes
axes1 = axes('Parent',figure2);

box(axes1,'on');
hold(axes1,'all');
end
% Create plot
hold on
for i = 1:size(latdirsi,2)
plot(real(eigenvalues(latdirsi(i),latdirsi(i))),imag(eigenvalues(latdirsi(i),latdirsi(i))),'MarkerFaceColor',[1 1 0],'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',10,...
    'Marker','diamond',...
    'LineStyle','none');
end
hold on %

line([0,0],ylim(),'LineWidth',2,...
    'Color',[0.87058824300766 0.490196079015732 0])
line(xlim(),[0,0],'LineWidth',2,...
    'Color',[0.87058824300766 0.490196079015732 0])

hold on
for i = 1:size(latdirsi,2)
plot(real(eigenvalues(latdirsi(i),latdirsi(i))),imag(eigenvalues(latdirsi(i),latdirsi(i))),'MarkerFaceColor',[1 1 0],'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',10,...
    'Marker','diamond',...
    'LineStyle','none');
end
hold on %

% Create xlabel
xlabel('Real');

% Create ylabel
ylabel('Imaginary');

title('Latero-Directional Dynamic Stability Eigenvalues');

end