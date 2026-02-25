clear all
close all

% coordinate libere: 
% 1. x = traslazione centro disco 1
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

Lm=[1    0;
    -1/R1e       0;
    1   -dR*spsi0;
    0       dR*cpsi0;
    -R1i/R2/R1e     -dR/R2];
Lk=[1    0;
    -1    dR*spsi0;
    0     -dR*cpsi0];
Lc=Lk;
Lq=[-1/R1e      0;
    1   -dR*spsi0;
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

