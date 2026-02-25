clear all
close all

m1=4;
m2=1;
J1=0.1;
J2=0.1;
L=0.25;
R=L/2;
k1=1000;
k2=1000;
c1=1;
c2=1;


mph=diag([m1 J1 m2 J2]);
kph=diag([k1 k2]);
cph=diag([c1 c2]);

Lm=[L      0;
    1      0;
    2*L    R;
    0      1];
Lk=[-L     2*R;
    -2*L  -R];
Lc=Lk;

MFF=Lm'*mph*Lm;
CFF=Lc'*cph*Lc;
KFF=Lk'*kph*Lk;

%...............................................

[eigenmodes eigenvalues]=eig(MFF\KFF);

freq=sqrt(diag(eigenvalues))/2/pi
eigenmodes

%...............................................

i=sqrt(-1);
F0=1; y0=0;
Q0=[L;0]*F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*MFF+i*ome*CFF+KFF;
    x0=A\Q0;
    theta=x0(1);
    phi=x0(2);
    phipp=-phi*ome^2;
    dL1=-L*theta+2*R*phi;
    Fel1=dL1*(k1+i*ome*c1);
    T=Fel1+J2/R*phipp;
    mod1(k)=abs(theta);
    fas1(k)=angle(theta);
    mod2(k)=abs(phi);
    fas2(k)=angle(phi);
    mod3(k)=abs(T);
    fas3(k)=angle(T);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('theta/F')
subplot 212;plot(vett_f,fas1*180/pi);grid

figure
subplot 211;plot(vett_f,mod2);grid;title('phi/F')
subplot 212;plot(vett_f,fas2*180/pi);grid

figure
subplot 211;plot(vett_f,mod3);grid;title('T/F')
subplot 212;plot(vett_f,fas3*180/pi);grid

