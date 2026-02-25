clear all
close all

% independent coordinates: 
% 1. theta = rotation of disk 1 
% 2. phi_r = relative rotation of disk 2

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
    -R1e-dR*spsi0   R2*spsi0;
    dR*cpsi0       -R2*cpsi0;
    1       1];
Lk=[-R1e               0;
    R1e+dR*spsi0   -R2*spsi0;
    -dR*cpsi0       R2*cpsi0];
Lc=Lk;
Lq=[1                    0;
   -(R1e+dR*spsi0)   R2*spsi0;
    dR*cpsi0        -R2*cpsi0];

KII_el2=k2*dL02*[dR*cpsi0  -R2*cpsi0;-R2*cpsi0  R2^2/dR*cpsi0];
KII_el3=k3*dL03*[dR*spsi0  -R2*spsi0;-R2*spsi0  R2^2/dR*spsi0]; 
KG2=m2*g*[-dR*spsi0  R2*spsi0;R2*spsi0  -R2^2/dR*spsi0];

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
F=[C0;F0*cos(beta);F0*sin(beta)];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    phi_r=x0(2);
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

%..................................
% FRF 2

C0=0;
F0=1;
F=[C0;F0*cos(beta);F0*sin(beta)];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    phi_r=x0(2);
    xc2=-(R1e+dR*spsi0)*theta+R2*spsi0*phi_r;
    yc2=dR*cpsi0*theta-R2*cpsi0*phi_r;
    dL2=-xc2;
    Fel2=(k2+i*ome*c2)*dL2;
    mod1(k)=abs(yc2);
    phase1(k)=angle(yc2);
    mod2(k)=abs(Fel2);
    phase2(k)=angle(Fel2);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/N]');title('yc2/F0')
subplot 212;plot(vett_f,phase1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/N]');title('Fel2/F0')
subplot 212;plot(vett_f,phase2*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')


%..................................
% FRF 3

C0=1;
F0=0;
F=[C0;F0*cos(beta);F0*sin(beta)];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    phi_r=x0(2);
    xc1=-R1e*theta;
    xc2=-(R1e+dR*spsi0)*theta+R2*spsi0*phi_r;
    yc2=dR*cpsi0*theta-R2*cpsi0*phi_r;
    dL1=xc1;
    dL2=-xc2;
    dL3=-yc2;
    Fel1=(k1+i*ome*c1)*dL1;
    Fel2=(k2+i*ome*c2)*dL2;
    Fel3=(k3+i*ome*c3)*dL3;
    xddc1=-ome^2*xc1;
    xddc2=-ome^2*xc2;
    yddc2=-ome^2*yc2;
    T=Fel1+m1*xddc1-Fel2+m2*xddc2-F0*cos(beta);
    N=-Fel3+m2*yddc2-F0*sin(beta);
    mod1(k)=abs(T);
    phase1(k)=angle(T);
    mod2(k)=abs(N);
    phase2(k)=angle(N);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[N/Nm]');title('T/C0')
subplot 212;plot(vett_f,phase1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/Nm]');title('N/C0')
subplot 212;plot(vett_f,phase2*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')
 

%.........................................

Nst=m1*g+m2*g-k3*dL03;
ind_freq=201;
Ndyn=mod2(ind_freq);
C_old=C0;
C_new=C0*Nst/Ndyn








