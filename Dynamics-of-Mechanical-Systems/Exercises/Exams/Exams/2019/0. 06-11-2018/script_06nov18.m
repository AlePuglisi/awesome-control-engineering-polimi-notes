clear all
close all

m1=15;
m2=5;
m3=5;
J2=0.1;
J3=0.15;
r=0.2;
R=1.0;
L=0.3;
k1=6000;
k2=6000;
k3=6000;
k4=6000;
c1=2;
c2=2;
c3=4;
c4=4;
psi0=pi/12;
theta0=pi/6;

spsi0=sin(psi0);
cpsi0=cos(psi0);
sth0=sin(theta0);
cth0=cos(theta0);
g=9.81;

% dL03=m3*g/2/k3*sth0/cth0
% dL01=0.03;
% Fel02=m2*g+m3*g-(k1*dL01-k3*dL03)/spsi0*cpsi0;
% dL02=Fel02/k2
% dL04=(k1*dL01-k3*dL03)/k4

dL01=0.03;
dL02=-0.0868;
dL03=0.0024;
dL04=0.0276;
dL01_new=0.015;

mph=diag([m1 m2 m2 J2 m3 m3 J3]);
cph=diag([c1 c2 c3 c4]);
kph=diag([k1 k2 k3 k4]);

Lm=[1    0       0;
    1  -r*cpsi0  0;
    0   r*spsi0  0;
    0    1       0;
    1  -r*cpsi0  L*cth0;
    0   r*spsi0   L*sth0;
    0    0       1];
Lk=[1  -r*cpsi0  0;
    0  -r*spsi0  0;
   -1   r*cpsi0  -2*L*cth0;
   -1   0         0];
Lc=Lk;
Lq=[0    1       0;
    1  -r*cpsi0  2*L*cth0];

KII_el1=zeros(3); KII_el1(2,2)=k1*dL01*r^2/(R-r)*spsi0;
KII_el2=zeros(3); KII_el2(2,2)=-k2*dL02*r^2/(R-r)*cpsi0;
KII_el3=zeros(3); KII_el3(2,2)=-k3*dL03*r^2/(R-r)*spsi0; KII_el3(3,3)=k3*dL03*2*L*sth0;
KG2=zeros(3); KG2(2,2)=m2*g*r^2/(R-r)*cpsi0;
KG3=zeros(3); KG3(2,2)=m3*g*r^2/(R-r)*cpsi0; KG3(3,3)=m3*g*L*cth0;

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KII_el1+KII_el2+KII_el3+KG2+KG3;

%..................................

[modes eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi


%..................................
% FRF 1

vett_f=0:0.01:10;
i=sqrt(-1);
C0=1;
F=[C0;0];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    x=x0(1);
    phi=x0(2);
    theta_d=x0(3);
    xa=x-r*cpsi0*phi+2*L*cth0*theta_d;
    mod1(k)=abs(x);
    phase1(k)=angle(x);
    mod2(k)=abs(xa);
    phase2(k)=angle(xa);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('x/C0')
subplot 212;plot(vett_f,phase1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('xa/C0')
subplot 212;plot(vett_f,phase2*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')


%..................................
% FRF 2,3

C0=0;
y0=1;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    Fel_y=(k3+i*ome*c3)*y0;
    F=[C0;Fel_y];
    Q0=Lq'*F;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    x=x0(1);
    phi=x0(2);
    theta_d=x0(3);
    yc=r*spsi0*phi;
    xa=x-r*cpsi0*phi+2*L*cth0*theta_d;
    dL3=-xa+y0;
    Fy=(k3+i*ome*c3)*dL3;
    xg=x-r*cpsi0*phi+L*cth0*theta_d;
    xddg=-ome^2*xg;
    phidd=-ome^2*phi;
    Fel3=(k3+i*ome*c3)*dL3;
    Hc=m3*xddg-Fel3;
    T=(J2*phidd-C0)/r;
    mod1(k)=abs(yc);
    phase1(k)=angle(yc);
    mod2(k)=abs(Fy);
    phase2(k)=angle(Fy);
    mod3(k)=abs(Hc);
    phase3(k)=angle(Hc);
    mod4(k)=abs(T);
    phase4(k)=angle(T);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/m]');title('yc/y0')
subplot 212;plot(vett_f,phase1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/m]');title('Fy/y0')
subplot 212;plot(vett_f,phase2*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/m]');title('Hc/y0')
subplot 212;plot(vett_f,phase3*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod4);grid;xlabel('[Hz]');ylabel('[N/m]');title('T/y0')
subplot 212;plot(vett_f,phase4*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

dL01=dL01_new;
dL03=m3*g/2/k3*sth0/cth0
Fel02=m2*g+m3*g-(k1*dL01-k3*dL03)/spsi0*cpsi0;
dL02=Fel02/k2
dL04=(k1*dL01-k3*dL03)/k4












