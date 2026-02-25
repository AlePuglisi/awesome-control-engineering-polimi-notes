clear all
close all

% coordinate libere: 
% 1. theta = rotazione disco 1
% 2. phi = rotazione assoluta disco 2

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

Lm=[-R1e             0;
    1                0;
    -R1e-R1i*spsi0   R2*spsi0;
    R1i*cpsi0       -R2*cpsi0;
    0       1];
Lk=[-R1e               0;
    R1e+R1i*spsi0   -R2*spsi0;
    -R1i*cpsi0       R2*cpsi0];
Lc=Lk;
Lq=[1                 0;
   -R1e-R1i*spsi0   R2*spsi0;
    R1i*cpsi0       -R2*cpsi0];

KII_el2=k2*dL02*cpsi0*[R1i^2/dR  -R1i*R2/dR;-R1i*R2/dR  R2^2/dR];
KII_el3=k3*dL03*spsi0*[R1i^2/dR  -R1i*R2/dR;-R1i*R2/dR  R2^2/dR]; 
KG2=m2*g*spsi0*[-R1i^2/dR  R1i*R2/dR;R1i*R2/dR  -R2^2/dR];

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KII_el2+KII_el3+KG2;

%..................................

[modes eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi







