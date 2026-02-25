clear all
close all

m1=5;
m2=5;
R=0.25;
r=0.15;
L=0.25;
J1=0.05;
J2=0.1;
k1=5000;
k2=5000;
k3=5000;
c1=1;
c2=1;
c3=1;
g=9.81;
phi_r0=pi/18;
F0_th=[200 150 100];
phi_th=[pi/6 0 -pi/6];
omega_th=[4 8 16]*pi;
C02=10;
phi_t=-pi/3;
omega_t=25*pi;
dt=0.001;
T=1;

cosr0=cos(phi_r0);
sinr0=sin(phi_r0);

N=m1*g/2;
Fel03=N*sinr0;
mtx_A=[1  1;L*cosr0 -L*cosr0];
vett_b=[-N*cosr0-m2*g;Fel03*L*sinr0];
vett_x=mtx_A\vett_b;
Fel01=vett_x(1);
Fel02=vett_x(2);

dL01=Fel01/k1;
dL02=Fel02/k2;
dL03=Fel03/k3;
dL01=-0.0072;
dL02=-0.0074;
dL03=8.5e-04;

mph=diag([m1 J1 m2 m2 J2]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[r           0;
    1           0;
    R*cosr0     0;
    R*sinr0     0;
    1           1];
Lk=[(R*sinr0-L*cosr0)     -L*cosr0;
    (R*sinr0+L*cosr0)      L*cosr0;
    (R*cosr0+L*sinr0)      L*sinr0];
Lc=Lk;
Lq=[1                         0;
    (R*sinr0+L*cosr0)      L*cosr0];

Kg1=zeros(2);Kg1(1,1)=m1*g*r;
Kg2=zeros(2);Kg2(1,1)=m2*g*R*cosr0;Kg2(2,2)=-m2*g*R*cosr0;
KII_el1=k1*dL01*[(R*cosr0+L*sinr0)   L*sinr0;L*sinr0   (L*sinr0-R*cosr0)];
KII_el2=k2*dL02*[(R*cosr0-L*sinr0)   -L*sinr0;-L*sinr0  (-L*sinr0-R*cosr0)];
KII_el3=k3*dL03*[(-R*sinr0+L*cosr0)   L*cosr0;L*cosr0   (R*sinr0+L*cosr0)];
    
M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KII_el1+KII_el2+KII_el3+Kg1+Kg2;


%..................................

[modes eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi

%..................................
% FRF 1

vett_f=0:0.01:15;
i=sqrt(-1);
C0=1;
F0=0;
F=[C0;F0];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    phir=x0(2);
    xG=theta*r;
    phi=theta+phir;
    mod1(k)=abs(xG);
    phase1(k)=angle(xG);
    mod2(k)=abs(phi);
    phase2(k)=angle(phi);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('xG/C0')
subplot 212;plot(vett_f,phase1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[rad/Nm]');title('phi/C0')
subplot 212;plot(vett_f,phase2*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

%..................................
% FRF 2

C0=0;
F0=1;
F=[C0;F0];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    phir=x0(2);
    xG1=theta*r;
    xG2=R*cosr0*theta;
    xG1dd=-ome^2*xG1;
    xG2dd=-ome^2*xG2;
    dL3=(R*cosr0+L*sinr0)*theta+L*sinr0*phir;
    dL1=(R*sinr0-L*cosr0)*theta-L*cosr0*phir;
    Fel1=dL1*(k1+i*ome*c1);
    Fel3=dL3*(k3+i*ome*c3);
    H=m1*xG1dd+m2*xG2dd+Fel3;
    mod1(k)=abs(H);
    phase1(k)=angle(H);
    mod2(k)=abs(Fel1);
    phase2(k)=angle(Fel1);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[N/N]');title('H/F0')
subplot 212;plot(vett_f,phase1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/N]');title('Fel1/F0')
subplot 212;plot(vett_f,phase2*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

%..................................
% time history

C0=0;
vett_t=0:dt:T;
vett_H=zeros(1,length(vett_t));
for iarm=1:3
    ome=omega_th(iarm);
    F0=F0_th(iarm)*exp(i*phi_th(iarm));
    F=[C0;F0];
    Q0=Lq'*F;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    phir=x0(2);
    xG1=theta*r;
    xG2=R*cosr0*theta;
    xG1dd=-ome^2*xG1;
    xG2dd=-ome^2*xG2;
    dL3=(R*cosr0+L*sinr0)*theta+L*sinr0*phir;
    Fel3=dL3*(k3+i*ome*c3);
    H=m1*xG1dd+m2*xG2dd+Fel3;
    vett_H=vett_H+abs(H)*cos(ome*vett_t+angle(H));
end

F0=0;
C0=C02*exp(i*phi_t);
F=[C0;F0];
Q0=Lq'*F;
ome=omega_t;
A=-ome^2*M+i*ome*C+K;
x0=A\Q0;
theta=x0(1);
phir=x0(2);
xG1=theta*r;
xG2=R*cosr0*theta;
xG1dd=-ome^2*xG1;
xG2dd=-ome^2*xG2;
dL3=(R*cosr0+L*sinr0)*theta+L*sinr0*phir;
Fel3=dL3*(k3+i*ome*c3);
H=m1*xG1dd+m2*xG2dd+Fel3;
vett_H=vett_H+abs(H)*cos(ome*vett_t+angle(H));

figure;plot(vett_t,vett_H);grid





















