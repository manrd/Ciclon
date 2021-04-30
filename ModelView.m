% % load('CiclonAir.mat')
load('CAircraft.mat')
% % % patch(a(2).vertices(:,1),a(2).vertices(:,2),a(2).vertices(:,3),'red')
% % b.faces=a(2).faces;
% % 
% % b.vertices(:,1)=a(2).vertices(:,1);
% % b.vertices(:,2)=a(2).vertices(:,2);
% % b.vertices(:,3)=a(2).vertices(:,3);
% % 
% % b.FaceColor=a(2).cdata(1,:);
% % c.faces=a(1).faces;
% % 
% % c.vertices(:,1)=a(1).vertices(:,1);
% % c.vertices(:,2)=a(1).vertices(:,2);
% % c.vertices(:,3)=a(1).vertices(:,3);
% % 
% % c.FaceColor=a(1).cdata(1,:);
% patch(b)
% patch(c)

d.vertices=[0 0 0;
            0 1 0
            1 1 0
            1 0 0
            0 0 1
            0 1 1
            1 1 1
            1 0 1];
d.faces=[1 2 3 4;
         5 6 7 8
         1 2 5 6
         3 4 7 8
         2 3 6 7
         1 4 5 8];
d.FaceColor=[0 1 0];
% patch(d)
oi=1;
% % for ala=1:geo.nwing
% %     for sec=1:geo.nelem(ala)
% %         
% %         
% %         
% %         
% %         cts(ala,sec)=geo.c(ala)*(prod(geo.T(ala,1:sec)));
% %         
% %         if sec==1
% %             ocsx=geo.startx(ala);
% %             ocsy=geo.starty(ala);
% %         else
% %             ocsx=geo.startx(ala)+sum(geo.b(ala,1:(sec-1)));
% %             ocsy=geo.starty(ala)++sum(geo.b(ala,1:(sec-1)).*sin(geo.SW(ala,1:(sec-1))));
% %         end
% %         
% %         ocsz=geo.startz(ala); % recordar el twist
% %         
% %         ep=geo.c(ala)*0.15;
% % 
% %         crs=geo.c(ala);
% %         
% %         if sec==1
% %             crs=geo.c(ala);
% %         else
% %             crs=cts(ala,sec-1);
% %         end
% %         
% %         %cambios en envergadura
% %         if sec==1
% %             de(ala,sec)=geo.b(ala,sec)*cos(geo.dihed(ala,sec));
% %         else
% %             de(ala,sec)=sum(de(ala,1:(sec-1)))+geo.b(ala,sec)*cos(geo.dihed(ala,sec));
% %         end
% %         
% %         %cambios en cuerda
% %         dc=cts(ala,sec)+geo.b(ala,sec)*sin(geo.SW(ala,sec));
% %         tle=geo.c(ala)*0.25-cts*0.25+geo.b(ala,sec)*sin(geo.SW(ala,sec));
% %         if sec==1
% %             rle=0;
% %         else
% %             rle=tle(ala,sec);
% %         end
% %         cs(oi).vertices=[ocsx ocsy ocsz 
% %             ocsx ocsy+crs+rle ocsz
% %             ocsx+de(ala,sec) tle(ala,sec) ocsz
% %             ocsx+de(ala,sec) tle(ala,sec)+dc ocsz];
% %         cs(oi).vertices(5:8,1:2)=cs(oi).vertices(1:4,1:2);
% %         cs(oi).vertices(5:8,3)=cs(oi).vertices(1:4,3)+ep;
% % 
% %         cs(oi).faces=[1 2 4 3;
% %                  5 6 8 7
% %                  1 2 6 5
% %                  3 4 8 7
% %                  2 4 8 6
% %                  1 3 7 5];
% %         cs(oi).FaceColor=[0 1 0];
% %         oi=oi+1;
% %     end
% % end
for n=1:3
    patch(cs(n))
end