In=2811;
End=3096;

XGPS=XGPS(In:End);
YGPS=YGPS(In:End);
ZGPS=ZGPS(In:End);
PHI=PHI(In:End);
THETA=THETA(In:End);
PSI=PSI(In:End);
MagHead=MagHead(In:End);


XGPS(:,2)=XGPS;
YGPS(:,2)=YGPS;
ZGPS(:,2)=ZGPS;
PHI(:,2)=PHI;
THETA(:,2)=THETA;
PSI(:,2)=PSI;
MagHead(:,2)=MagHead;

TS=End-In;
TStamp=linspace(0,(TS/10),TS+1);

XGPS(:,1)=TStamp;
YGPS(:,1)=TStamp;
ZGPS(:,1)=TStamp;
PHI(:,1)=TStamp;
THETA(:,1)=TStamp;
PSI(:,1)=TStamp;
MagHead(:,1)=TStamp;