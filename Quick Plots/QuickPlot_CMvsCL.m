%% Configurate

SecondIndex=3;

SelectedX=Coef_Matrices.CL(:,SecondIndex,i);

for i=3:-1:1
    SelectedY(:,i)=Coef_Matrices.Cm(:,SecondIndex,i);
end

xName='CL';
yName='CM';

%% Initialize
figufre1=figure;

axes1 = axes('Parent',figufre1);
hold(axes1,'on');
% CoMa=Coef_Matrices
% CoMa=Coef_Derivatives

%% Set back image
HMBackImage = axes('units','normalized','position',[0 0 1 1]);
% Move the background axes to the bottom
uistack(HMBackImage,'bottom');
% Load in a background image and display it using the correct colors
HMBI=imread('FondoCiclon2.jpg');
imagesc(HMBI);
% colormap gray
% Turn the handlevisibility off so that we don't inadvertently plot into the axes again
% Also, make the axes invisible
set(HMBackImage,'handlevisibility','off','visible','off')

%% Plot the Data

for i=1:size(SelectedY,2)
plo1=plot(SelectedX,SelectedY(:,i));
set(plo1,'MarkerFaceColor',[0.800000011920929 0.800000011920929 0.800000011920929],...
    'MarkerEdgeColor',[0 0 0],...
    'Marker','o',...
    'LineWidth',2.5);
end
xl1=xlim();
yl1=ylim();

line([0,0],ylim()+[-100 100],'LineWidth',2,...
    'Color',[0.87058824300766/2 0.490196079015732/2 0])
line(xlim()+[-100 100],[0,0],'LineWidth',2,...
    'Color',[0.87058824300766/2 0.490196079015732/2 0])

box(axes1,'on');
set(axes1,'GridAlpha',0.35,'GridLineStyle','--','MinorGridAlpha',0.35,...
    'XGrid','on','XMinorGrid','on','YGrid','on','YMinorGrid','on');

axis([xl1 yl1])

xlabel(xName);
ylabel(yName);
