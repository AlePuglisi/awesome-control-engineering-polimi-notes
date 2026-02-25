clear all
close all

m1=5;
m2=10;
m3=5;
J1=0.4;
J2=3.0;
J3=0.15;
L1=0.5;
L2=1.0;
R=0.25;
a=1.2;
k1=6000;
k2=1500;
k3=3000;
c1=10;
c2=3;
c3=6;
g=9.81;
theta0=pi/4;
phi0=pi/6;
beta=pi/6;
costh0=cos(theta0);
sinth0=sin(theta0);
cosphi0=cos(phi0);
sinphi0=sin(phi0);

mph=diag([m1 m1 J1 m2 J2 m3 m3 J3]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Fel01=-m1*g/2*tan(theta0);
Fel02=-m3*g*tan(phi0);
num=Fel01*(2*L1*costh0-0.5*L2*sinphi0)+m1*g*(L1*sinth0+0.5*L2*cosphi0)-0.5*m2*g*L2*cosphi0-m3*g*(a*cosphi0-R*sinphi0)+Fel02*(R*cosphi0+a*sinphi0);
den=1.5*L2*cosphi0;
Fel03=num/den;
% dL01=Fel01/k1
% dL02=Fel02/k2
% dL03=Fel03/k3
dL01=-0.0041;
dL02=-0.0189;
dL03=-0.0213;


Lm=[-L1*costh0      0.5*L2*sinphi0       0;
    -L1*sinth0     -0.5*L2*cosphi0       0;
        1                 0              0;
        0               0.5*L2           0;
        0                 1              0;
        0    -a*sinphi0-R*cosphi0    -R*cosphi0;
        0     a*cosphi0-R*sinphi0    -R*sinphi0;
        0                 1              1];
Lk=[-2*L1*costh0     0.5*L2*sinphi0       0;
        0       -a*sinphi0-R*cosphi0    -R*cosphi0;
        0           1.5*L2*cosphi0        0];
Lq=[    0         -0.5*L2*cosphi0       0;
    -2*L1*costh0   0.5*L2*sinphi0       0;
    -2*L1*sinth0  -0.5*L2*cosphi0       0];
Lc=Lk;

KG1=zeros(3);KG1(1,1)=m1*g*(-L1*costh0);KG1(2,2)=m1*g*(0.5*L2*sinphi0);
KG2=zeros(3);KG2(2,2)=m2*g*(-0.5*L2*sinphi0);
KG3=zeros(3);KG3(2,2)=m3*g*(-a*sinphi0-R*cosphi0);KG3(2,3)=m3*g*(-R*cosphi0);KG3(3,2)=KG3(2,3);
Kel1=zeros(3);Kel1(1,1)=k1*dL01*(2*L1*sinth0);Kel1(2,2)=k1*dL01*(0.5*L2*cosphi0);
Kel2=zeros(3);Kel2(2,2)=k2*dL02*(-a*cosphi0+R*sinphi0);Kel2(2,3)=k2*dL02*(R*sinphi0);Kel2(3,2)=Kel2(2,3);
Kel3=zeros(3);Kel3(2,2)=k3*dL03*(-1.5*L2*sinphi0);

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KG1+KG2+KG3+Kel1+Kel2+Kel3;

[modes,eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi

% .............................................................
% FRF 1

i=sqrt(-1);
F01=1;
F02=0;
F0=[F01;F02*cos(beta);F02*sin(beta)];
Q0=Lq'*F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta_d=x0(1);
    phi_d=x0(2);
    psi=x0(3);
    yc=(a*cosphi0-R*sinphi0)*phi_d-R*sinphi0*psi;
    psi_a=phi_d+psi;
    mod1(k)=abs(yc);
    fas1(k)=angle(yc);
    mod2(k)=abs(psi_a);
    fas2(k)=angle(psi_a);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/N]');title('yc/F01')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[rad/N]');title('abs. psi/F01')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')


% .............................................................
% FRF 2

F01=0;
F02=1;
F0=[F01;F02*cos(beta);F02*sin(beta)];
Q0=Lq'*F0;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta_d=x0(1);
    phi_d=x0(2);
    psi=x0(3);
    xg1=-L1*costh0*theta_d+0.5*L2*sinphi0*phi_d;
    yg1=-L1*sinth0*theta_d-0.5*L2*cosphi0*phi_d;
    dL1=-2*L1*costh0*theta_d+0.5*L2*sinphi0*phi_d;
    dL3=1.5*L2*cosphi0*phi_d;
    Fel1=(k1+i*ome*c1)*dL1;
    Fel3=(k3+i*ome*c3)*dL3;
    xddg1=-ome^2*xg1;
    yddg1=-ome^2*yg1;
    HB=m1*xddg1+Fel1-F02*cos(beta);
    VB=m1*yddg1-F02*sin(beta);
    mod1(k)=abs(xg1);
    fas1(k)=angle(xg1);
    mod2(k)=abs(Fel3);
    fas2(k)=angle(Fel3);
    mod3(k)=abs(HB);
    fas3(k)=angle(HB);
    mod4(k)=abs(VB);
    fas4(k)=angle(VB);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/N]');title('xG1/F02')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/N]');title('Fel3/F02')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/N]');title('HB/F02')
subplot 212;plot(vett_f,fas3);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod4);grid;xlabel('[Hz]');ylabel('[N/N]');title('VB/F02')
subplot 212;plot(vett_f,fas4);grid;xlabel('[Hz]');ylabel('[rad]')


