figure(1)

vo_cg150_T=-[1.98,2.97,3.96,4.92,5.88,6.75,7.59];
vo_cg160_T=-[0.855,1.575,2.28,2.97,3.66,4.275,4.83];
vo_cg165_T=-[0.285,0.87,1.44,1.995,2.55,3.03,3.465];

vo_cg150=-[1.98,2.97,3.96,4.92,5.88,6.75,7.59]+2.97;
vo_cg160=-[0.855,1.575,2.28,2.97,3.66,4.275,4.83]+1.575;
vo_cg165=-[0.285,0.87,1.44,1.995,2.55,3.03,3.465]+0.87;

% Cg150=-Cg150;
% Cg160=-Cg160;
% Cg165=-Cg165;

Deltanvo=linspace(-0.2,1,7);

scatter(Deltanvo,vo_cg150)
hold on
scatter(Deltanvo,vo_cg160)
scatter(Deltanvo,vo_cg165)
hold off
xlabel('delta_N')
ylabel('Deflexao Profundor (º)')
title('Profundor requerido para manobrar a V_o, Voo reto e nivelado')
grid on

figure(2)

Deltanvs=linspace(-0.6,0.2,5);

vs_cg150_T=-[13.2,26.5,39.2,50.6,63.8].*(15/100);
vs_cg160_T=-[5.7,15.3,24.4,32.3,42.7].*(15/100);
vs_cg165_T=-[2,9.7,17,23.1,32].*(15/100);

vs_cg150=(-[13.2,26.5,39.2,50.6,63.8]+50.6).*(15/100);
vs_cg160=(-[5.7,15.3,24.4,32.3,42.7]+32.3).*(15/100);
vs_cg165=(-[2,9.7,17,23.1,32]+23.1).*(15/100);

scatter(Deltanvs,vs_cg150)
hold on
scatter(Deltanvs,vs_cg160)
scatter(Deltanvs,vs_cg165)
hold off
xlabel('delta_N')
ylabel('Deflexao Profundor (º)')
title('Profundor requerido para manobrar a V_s, Voo reto e nivelado')
grid on



