clear all
close all

m1=6;
m2=4;
J1=0.12;
J2=0.1;
r=0.2;
L=0.25;
R=1.0;
psi0=pi/6;
k1=5000;
k2=5000;
c1=2;
c2=2;
sinpsi0=sin(psi0);
cospsi0=cos(psi0);
g=9.81;
Rt=R+r;

% dL02=0.002; Fel02=dL02*k2;
% dL01=-(m1*g+m2*g+Fel02)/(2*k1*sinpsi0)
 
dL01=-0.0216;
dL02=0.002;

mph=diag([m1 m1 J1 m2 m2 J2]);
cph=diag([c1 c2]);
kph=diag([k1 k2]);

a=2*Rt*cospsi0;
L1=sqrt(a^2+Rt^2-2*a*Rt*cospsi0);
% der1=a*Rt*sinpsi0/L1;
% der2=(a*Rt*L1*cospsi0-a*Rt*sinpsi0*der1)/L1^2;
der1=a*Rt*sinpsi0/L1;
der2=(a*Rt*L1*cospsi0-a*Rt*sinpsi0*der1)/L1^2;


Lm=[Rt*sinpsi0       0;
    Rt*cospsi0       0;
       -Rt/r         0;
    Rt*sinpsi0       L;
    Rt*cospsi0       0;
       0            1   ];
Lk=[der1           0;
    Rt*cospsi0     0];
Lc=Lk;
Lq=[Rt/r             0 ;
    Rt*sinpsi0       2*L];

Kel1=k1*dL01*[der2 0;0 0];
Kel2=k2*dL02*[-Rt*sinpsi0  0 ;0  2*L];

Kg1=m1*g*[-Rt*sinpsi0 0; 0 0];
Kg2=m2*g*[-Rt*sinpsi0 0;0 L];

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+Kel1+Kel2+Kg1+Kg2;

[modes eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi

%............................................
% FRF 1 

i=sqrt(-1);
vett_f=0:0.01:5;
C0=1; F0=0;
F=[C0;F0];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    psi_d=x0(1);
    theta=x0(2);
    xc=Rt*sinpsi0*psi_d;
    mod1(k)=abs(xc);
    phase1(k)=angle(xc);
    mod2(k)=abs(theta);
    phase2(k)=angle(theta);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('xc/C0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[rad/Nm]');title('theta/C0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')

%............................................
% FRF 2, 3 

C0=0; F0=1;
F=[C0;F0];
Q0=Lq'*F;
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*M+i*ome*C+K;
   x0=A\Q0;
   psi_d=x0(1);
   theta=x0(2);
   Fel1=der1*psi_d*k1;
   xc=Rt*sinpsi0*psi_d;
   xd=Rt*sinpsi0*psi_d+L*theta;
   phi=-Rt/r*psi_d;
   phidd=-phi*ome^2;
   xddc=-xc*ome^2;
   xddg=-xd*ome^2;
   T=J1*phidd/r;
   N=(T*sinpsi0+F0-m1*xddc-m2*xddg-Fel1*cospsi0)/cospsi0;
   mod1(k)=abs(Fel1);
   phase1(k)=angle(Fel1);
   mod2(k)=abs(xd);
   phase2(k)=angle(xd);
   mod3(k)=abs(N);
   phase3(k)=angle(N);
   mod4(k)=abs(T);
   phase4(k)=angle(T);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[N/N]');title('Fel1/F0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/N]');title('xd/F0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/N]');title('N/F0')
subplot 212;plot(vett_f,phase3);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod4);grid;xlabel('[Hz]');ylabel('[N/N]');title('T/F0')
subplot 212;plot(vett_f,phase4);grid;xlabel('[Hz]');ylabel('[rad]')

