clear all
close all

m1=10;
m2=10;
J1=0.15;
J2=0.08;
R1=0.25;
Rg=1.0;
L0=0.35;
H=0.1;
k1=3000;
k2=3000;
k3=3000;
c1=3;
c2=3;
c3=3;
g=9.81;
theta0=pi/6;
phi0=pi/12;
% x01=0.04;
% omega1=10;
% phi01=-pi/3;
% y02=0.025;
% omega2=30;
% phi02=pi/3;
% T=2;
% dt=0.001;

costh0=cos(theta0);
sinth0=sin(theta0);
cosphi0=cos(phi0);
sinphi0=sin(phi0);

mph=diag([m1 J1 m2 m2 J2]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

dL03=0.02;
Fel03=dL03*k3;
num=(m2*g-Fel03)*((L0-R1)*cosphi0+(R1+H)*sinphi0);
den=(L0-R1)*sinphi0-(R1+H)*cosphi0;
Fel02=num/den;
Fel01=Fel02*cosphi0+(m2*g-Fel03)*sinphi0;
% dL01=Fel01/k1
% dL02=Fel02/k2
dL01=-0.0041;
dL02=-0.0076;


Lm=[     R1                                   0;
         1                                    0;
    -R1*costh0-(R1-L0)*sinphi0-H*cosphi0     -cosphi0;
    -R1*sinth0+(R1-L0)*cosphi0-H*sinphi0     -sinphi0;
         1                                    0];
Lk=[     0                                    1;
    -R1*costh0-(R1-L0)*sinphi0-H*cosphi0     -cosphi0;
     R1*sinth0-(R1-L0)*cosphi0+H*sinphi0      sinphi0];
Lq=[     1                                      0;
    -R1*costh0-(R1-L0)*sinphi0-H*cosphi0     -cosphi0];
Lc=Lk;

KG1=zeros(2);KG1(1,1)=m1*g*R1^2/(Rg-R1)*costh0;
KG2=m2*g*[R1^2/(Rg-R1)*costh0-(R1-L0)*sinphi0-H*cosphi0         -cosphi0; -cosphi0  0];
Kel2=k2*dL02*[-R1^2/(Rg-R1)*sinth0-(R1-L0)*cosphi0+H*sinphi0     sinphi0; sinphi0 0];
Kel3=k3*dL03*[-R1^2/(Rg-R1)*costh0+(R1-L0)*sinphi0+H*cosphi0     cosphi0; cosphi0 0];

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KG1+KG2+Kel2+Kel3;

[modes,eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi


% .............................................................
% FRF 1

i=sqrt(-1);
C0=1;
y0=0; Fel_y=0;
F0=[C0;Fel_y];
Q0=Lq'*F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    phi_d=x0(1);
    s_d=x0(2);
    xc2=(-R1*costh0-(R1-L0)*sinphi0-H*cosphi0)*phi_d-cosphi0*s_d;
    mod1(k)=abs(phi_d);
    fas1(k)=angle(phi_d);
    mod2(k)=abs(xc2);
    fas2(k)=angle(xc2);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[rad/Nm]');title('theta/C0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('xc2/C0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')


% .............................................................
% FRF 2

C0=0;
y0=1; 
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    Fel_y=(k2+i*ome*c2)*y0;
    F0=[C0;Fel_y];
    Q0=Lq'*F0;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    phi_d=x0(1);
    s_d=x0(2);
    xc1=-R1*costh0*phi_d;
    dL3=(R1*sinth0-(R1-L0)*cosphi0+H*sinphi0)*phi_d+sinphi0*s_d;
    Fel3= (k3+i*ome*c3)*dL3;
    mod1(k)=abs(xc1);
    fas1(k)=angle(xc1);
    mod2(k)=abs(Fel3);
    fas2(k)=angle(Fel3);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/m]');title('xc1/y0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/m]');title('Fel3/y0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')

% .....................................................................
% FRF3

A=[costh0 -sinth0;sinth0 costh0];
vett_b=[k2*dL02;(m1+m2)*g-k3*dL03];
x=A\vett_b;
Tst=x(1);
Nst=x(2);

C0=0;
y0=1; 
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    Fel_y=(k2+i*ome*c2)*y0;
    F0=[C0;Fel_y];
    Q0=Lq'*F0;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    phi_d=x0(1);
    s_d=x0(2);
    xc1=-R1*costh0*phi_d;
    xc2=(-R1*costh0-(R1-L0)*sinphi0-H*cosphi0)*phi_d-cosphi0*s_d;
    yc1=-R1*sinth0+(R1-L0)*phi_d;
    yc2=(-R1*sinth0+(R1-L0)*cosphi0-H*sinphi0)*phi_d-sinphi0*s_d;
    dL2=(-R1*costh0-(R1-L0)*sinphi0-H*cosphi0)*phi_d-cosphi0*s_d-y0;
    dL3=(R1*sinth0-(R1-L0)*cosphi0+H*sinphi0)*phi_d+sinphi0*s_d;
    Fel2= (k2+i*ome*c2)*dL2;
    Fel3= (k3+i*ome*c3)*dL3;
    xddc1=-ome^2*xc1;
    xddc2=-ome^2*xc2;
    yddc1=-ome^2*yc1;
    yddc2=-ome^2*yc2;
    vett_b(1)=m1*xddc1+m2*xddc2+Fel2;
    vett_b(2)=m1*yddc1+m2*yddc2-Fel3;
    x=A\vett_b;
    Td=x(1);
    Nd=x(2);
    mod1(k)=abs(Nd);
    fas1(k)=angle(Nd);
    mod2(k)=abs(Td);
    fas2(k)=angle(Td);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[N/m]');title('Nd/y0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/m]');title('Td/y0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')






