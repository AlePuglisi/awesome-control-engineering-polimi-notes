clear all
close all

% coordinate libere: 
% 1. theta = rotazione disco 1
% 2. psi = angolo formato tra la congiungente dei due cerchi e la direzione orizzontale

m1=15;
m2=5;
J1=0.6;
J2=0.05;
R1e=0.5;
R1i=0.4;
R2=0.1;
k1=20000;
k2=10000;
k3=20000;
c1=6;
c2=2;
c3=2;
psi0=pi/6;
beta=2*pi/3;

spsi0=sin(psi0);
cpsi0=cos(psi0);
g=9.81;
dR=R1i-R2;

% dL03=0.05;
% Fel03=k3*dL03;
% Fel02=(Fel03-m2*g)*cpsi0/spsi0;
% Fel01=Fel02*(1+dR/R1e*spsi0)-(Fel03-m2*g)*dR/R1e*cpsi0;
% dL01=Fel01/k1
% dL02=Fel02/k2

dL01=0.0824;
dL02=0.1647;
dL03=0.05;

mph=diag([m1 J1 m2 m2 J2]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[-R1e    0;
    1       0;
    -R1e   -dR*spsi0;
    0       dR*cpsi0;
    R1i/R2     -dR/R2];
Lk=[-R1e    0;
    R1e    dR*spsi0;
    0     -dR*cpsi0];
Lc=Lk;
Lq=[1      0;
   -R1e   -dR*spsi0;
    0     dR*cpsi0];

KII_el2=zeros(2); KII_el2(2,2)=k2*dL02*dR*cpsi0;
KII_el3=zeros(2); KII_el3(2,2)=k3*dL03*dR*spsi0; 
KG2=zeros(2); KG2(2,2)=-m2*g*dR*spsi0;

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KII_el2+KII_el3+KG2;

%..................................

[modes eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi

%..................................
% FRF 1

vett_f=0:0.01:10;
i=sqrt(-1);
C0=1;
F0=0;
F=[C0;F0;F0];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    psi=x0(2);
    phi_r=dR/R2*(theta-psi);
    mod1(k)=abs(theta);
    phase1(k)=angle(theta);
    mod2(k)=abs(phi_r);
    phase2(k)=angle(phi_r);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[rad/Nm]');title('theta/C0')
subplot 212;plot(vett_f,phase1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[rad/Nm]');title('phi_rel/C0')
subplot 212;plot(vett_f,phase2*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')
