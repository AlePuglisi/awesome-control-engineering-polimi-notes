clear all
close all

m=25;
M=10;
R=0.25;
L=1;
J1=2;
J=0.25;
k1=1000;
k2=1000;
k3=2000;
r1=2;
r2=2;
r3=4;
dt1=0.6;
dt2=0.255;
T1=0.65;
T2=0.27;
C0=10;
y0=0.002;
g=9.81;

mf=diag([M J m m m 2*J1]);
rf=diag([r1 r2 r3]);
kf=diag([k1 k2 k3]);

% matrici di trasformazione delle coordinate

Lm=[0 1 0;
    L/R -1/R 1/R;
    L/2 0 1;
    0 0 1;
    -L/2 0 0;
    1 0 0];

% questo sopra è lo jacobiano lambda delle masse

Lk=[-L/2 0 0;
    -3/2*L 2 -2;
    0 -1 0];
Lr=Lk;

%matrici in coordinate indipendenti

MM=Lm'*mf*Lm;
RR=Lr'*rf*Lr;
Kg=zeros(3);
Kg(1,1)=-m*g*L/2;
KK=Lk'*kf*Lk+Kg;

% partizione delle matrici

MLL=MM(1:2,1:2);
MLV=MM(1:2,3);
MVL=MM(3,1:2);
MVV=MM(3,3);

RLL=RR(1:2,1:2);
RLV=RR(1:2,3);
RVL=RR(3,1:2);
RVV=RR(3,3);

KLL=KK(1:2,1:2);
KLV=KK(1:2,3);
KVL=KK(3,1:2);
KVV=KK(3,3);

%frequenze proprie e modi di vibrare

[modi, lambda]=eig(MLL\KLL);
modi

vett_lambda=diag(lambda);         
omega=sqrt(vett_lambda);
freq=omega/2/pi

%............................................................PUNTO 3

C01=1;
Q=[L/R; -1/R]*C01;
i=sqrt(-1);
ff=0:0.01:7;
for k=1:length(ff)
    omF=2*pi*ff(k);
    A=-omF^2*MLL+i*omF*RLL+KLL;
    x=A\Q;
    phi=L/R*x(1)-1/R*x(2);
    mod1(k)=abs(x(1));
    fas1(k)=angle(x(1));
    mod2(k)=abs(phi);
    fas2(k)=angle(phi);
end

figure
subplot(211)
plot(ff,mod1)
title('FdT rotazione asta theta/C')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT rotaz. disco phi/C')
grid
subplot(212)
plot(ff,fas2)
grid

%.........................................................PUNTO 4

y01=1;
i=sqrt(-1);                        
ff=0:0.01:7;                       
for k=1:length(ff)
    omF=2*pi*ff(k);
    A=-omF^2*MLL+i*omF*RLL+KLL;
    x=-A\(-omF^2*MLV+i*omF*RLV+KLV);
    yB=-L*x(1);
    mod1(k)=abs(yB);
    fas1(k)=angle(yB);
    mod2(k)=abs(x(2));
    fas2(k)=angle(x(2));
end

figure
subplot(211)
plot(ff,mod1)
title('FdT spostamento verticale punto B xB/y0')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT spostamento orizzontale centro disco x/y0')
grid
subplot(212)
plot(ff,fas2)
grid

%.........................................................PUNTO 5

y01=1;
i=sqrt(-1);                        
ff=0:0.01:7;                       
for k=1:length(ff)                  
    omF=2*pi*ff(k);                 
    A=-omF^2*MLL+i*omF*RLL+KLL;
    x=-A\(-omF^2*MLV+i*omF*RLV+KLV);
    Ry=(-omF^2*MVL+i*omF*RVL+KVL)*x+(-omF^2*MVV+i*omF*RVV+KVV)-C0/R;
    mod1(k)=abs(Ry);      
    fas1(k)=angle(Ry);
end

figure
subplot(211)
plot(ff,mod1)
title('FdT reazione vincolare Ry/y0')
grid
subplot(212)
plot(ff,fas1)
grid

%.............................................................PUNTO 6+7 (NON SONO GIUSTI!)

%costruisco la forzante e lo spostamento periodici
dt=0.001;
tt=0:dt:3.5;
vc=C0*cos((tt-dt1)*2*pi/T1);
vy=y0*sin((tt+dt2)*2*pi/T2);

figure
plot(tt,vc);axis([0 3.5 -10 10])
figure
plot(tt,vy);axis([0 3.5 -0.002 0.002])

%devo scrivere le due funzioni come esponenziali
ome1=2*pi/T1;
phase1=-ome1*dt1;
vc_cmplx=C0*exp(i*phase1);

ome2=2*pi/T2;
phase2=ome2*dt2;
vy_cmplx=y0*exp(i*(phase2-pi/2));   %devo togliere pi/2 perchè la vy è un seno


A1=-ome1^2*MLL+i*ome1*RLL+KLL;
Q1=[L/R;-1/R]*vc_cmplx;
x1=A1\Q1;    %parte relativa alla forzante

A2=-ome2^2*MLL+i*ome2*RLL+KLL;
Q2=-(-ome2^2*MLV+i*ome2*RLV+KLV)*vy_cmplx;
x2=A2\Q2;    %parte relativa allo spostamento

phi1=L/R*x1(1)-x1(2)/R;         %non devo considerare lo spostamento impresso
phi2=L/R*x2(1)-x2(2)/R+vy_cmplx/R;
Rx1=(-ome1^2*MVL+i*ome1*RVL+KVL)*x1-vc_cmplx/R;
Rx2=(-ome2^2*MVL+i*ome2*RVL+KVL)*x2+(-ome2^2*MVV+i*ome2*RVV+KVV)*vy_cmplx;

phi_t1=abs(phi1)*cos(ome1*tt+angle(phi1));
phi_t2=abs(phi2)*cos(ome2*tt+angle(phi2));
phi_tot=phi_t1+phi_t2;
Rx_t1=abs(Rx1)*cos(ome1*tt+angle(Rx1));
Rx_t2=abs(Rx2)*cos(ome2*tt+angle(Rx2));
Rx_tot=Rx_t1+Rx_t2;

figure
plot(tt,phi_tot);grid
figure
plot(tt,Rx_tot);grid
