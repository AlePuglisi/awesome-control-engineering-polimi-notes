clear all
close all

m1 = 10; m2 = 5;
J2 = 0.1;
RG = 1; R = 0.2; r = 0.15;
Rc = RG-R;
k1 = 15000; k2 = 15000;
c1 = 10; c2 = 5;
DL01 = -0.0098; DL02 = -0.0014;
psi0 = pi/3; phi0 = pi/6;
cpsi0 = cos(psi0); spsi0 = sin(psi0);
cphi0 = cos(phi0); sphi0 = sin(phi0);
g = 9.81;

mph=diag([m1 m2 m2 J2]);
cph=diag([c1 c2]);
kph=diag([k1 k2]);

Lm=[1                   0;
    0                (RG-R)*cpsi0 + r*Rc/R*sphi0;
    1               (RG-R)*spsi0 - r*Rc/R*cphi0;
    0                 -Rc/R];
Lk=[1                   0;
    0                   (RG-R)*cpsi0];
Lc=Lk;

KelII1=zeros(2,2);
KelII2=zeros(2,2); KelII2(2,2)=-k2*DL02*(RG-R)*spsi0;
KelII=KelII1 + KelII2;
KG1 = zeros(2,2);
KG2 = zeros(2,2); KG2(2,2)=m2*g*((RG-R)*cpsi0 - r*Rc^2/R^2*sphi0);
KG=KG1 + KG2;

Lf = [1     0];

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KelII+KG;
MFF=M;
CFF=C;
KFF=K;

%..............................................
% natural frequencies and modes of vibration

[eigenvectors eigenvalues]=eig(MFF\KFF);

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%..............................................
% frequency response

i=sqrt(-1);
vett_f=[0:0.01:10];
ome = 2*pi*vett_f;
F0 = Lf'*1;
for k=1:length(vett_f)
    A=-ome(k)^2*MFF+i*ome(k)*CFF+KFF;
    x=A\F0;
    out1=Rc*spsi0*x(2) + x(1);
    out2=(Rc*cpsi0 + r*sphi0*Rc/R)*x(2);
    XG2 = out2;
    YG2 = x(1) + (Rc*spsi0 - r*Rc/R*cphi0)*x(2);
    XG2dd = -ome(k)^2*XG2;
    YG2dd= -ome(k)^2*YG2;
    DL2 = Rc*cpsi0*x(2);
    Np = -m2*spsi0*XG2dd + m2*cpsi0*YG2dd - (k2 + i*ome(k)*c2)*DL2*spsi0;
    Tp = m2*YG2dd*sphi0 + m2*cpsi0*XG2dd + (k2 + i*ome(k)*c2)*DL2*cpsi0;
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
    mod3(k)=abs(Np);
    fas3(k)=angle(Np);
    mod4(k)=abs(Tp);
    fas4(k)=angle(Tp);
end

figure(1)
subplot 211;plot(vett_f,mod1);grid
title('FRF of y_{c} for unit F');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure(2)
subplot 211;plot(vett_f,mod2);grid;
title('FRF of x_{G2} for unit F');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

figure(3)
subplot 211;plot(vett_f,mod3);grid;
title('FRF of N_{p} for unit F');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas3);grid
xlabel('Freq. [Hz]');

figure(4)
subplot 211;plot(vett_f,mod4);grid;
title('FRF of T_{p} for unit F');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas4);grid
xlabel('Freq. [Hz]');

psi0 = pi/6; cpsi0 = cos(psi0); spsi0 = sin(psi0);
phi0 = pi/3; cphi0 = cos(phi0); sphi0 = sin(phi0);
DL01 = -(m1 + m2)*g/k1
DL02 = m2*g*(r*cphi0 - R*spsi0)/(k2*R*cpsi0)