clear all
close all

m1=10;
m2=5;
R=0.25;
L=0.2;
a=0.25;
J1=0.3;
J2=0.1;
k1=2500;
k2=2500;
k3=2500;
c1=1;
c2=1;
c3=1;
g=9.81;
theta_0=pi/12;
y0_th=[2 1.5 1]*1e-3;
phi_th=[pi/6 0 -pi/6];
omega_th=[4 8 16]*pi;
C02=1;
phi_t=-pi/3;
omega_t=25*pi;
dt=0.001;
T0=1;

costh0=cos(theta_0);
sinth0=sin(theta_0);
tanth0=tan(theta_0);

% dL01=0.005;
% Fel01=k1*dL01;
% Fel03=m2*g*(a-L*costh0)/a+2*Fel01*tanth0;
% Fel02=(m2*g-Fel03)*sinth0-2*Fel01*costh0;
% dL02=Fel02/k2
% dL03=Fel03/k3
dL01=0.005;
dL02=-0.0064;
dL03=0.0071;

mph=diag([m1 J1 m2 m2 J2]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[0                       -R;
    0                        1;
    L*sinth0                 0;
    a/costh0^2-L*costh0  R*tanth0;
    1                        0];
Lk=[0              -2*R;
    -a*sinth0/costh0^2   -R/costh0;
    -a/costh0^2          -R*tanth0];
Lc=Lk;
Lq=[1                         0;
    a/costh0^2          R*tanth0];

Kg2=m2*g*[2*a*sinth0/costh0^3+L*sinth0    R/costh0^2;R/costh0^2    0];
KII_el2=k2*dL02*[-a*(1+sinth0^2)/costh0^3   -R*sinth0/costh0^2;-R*sinth0/costh0^2  0];
KII_el3=k3*dL03*[-2*a*sinth0/costh0^3    -R/costh0^2;-R/costh0^2    0];
    
M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KII_el2+KII_el3+Kg2;


%..................................

[modes eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi

%..................................
% FRF 1

vett_f=0:0.01:10;
i=sqrt(-1);
C0=1;
Fel_y=0;
F=[C0;Fel_y];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    phi=x0(2);
    xg=L*sinth0*theta;
    mod1(k)=abs(xg);
    phase1(k)=angle(xg);
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
y0=1;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    Fel_y=(k3+i*ome*c3)*y0;
    F=[C0;Fel_y];
    Q0=Lq'*F;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    phi=x0(2);
    phidd=-ome^2*phi;
    dL1=-2*R*phi;
    Fel1=dL1*(k1+i*ome*c1);
    T=-Fel1+J1*phidd/R;
    dL2=-a*sinth0/costh0^2*theta-R/costh0*phi;
    Fel2=dL2*(k2+i*ome*c2);
    mod1(k)=abs(T);
    phase1(k)=angle(T);
    mod2(k)=abs(Fel2);
    phase2(k)=angle(Fel2);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[N/m]');title('T/y0')
subplot 212;plot(vett_f,phase1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/m]');title('Fel2/y0')
subplot 212;plot(vett_f,phase2*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

%..................................
% time history

C0=0;
vett_t=0:dt:T0;
vett_HB=zeros(1,length(vett_t));
for iarm=1:3
    ome=omega_th(iarm);
    y0=y0_th(iarm)*exp(i*phi_th(iarm));
    Fel_y=(k3+i*ome*c3)*y0;
    F=[C0;Fel_y];
    Q0=Lq'*F;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    phi=x0(2);
    phidd=-ome^2*phi;
    dL1=-2*R*phi;
    Fel1=dL1*(k1+i*ome*c1);
    T=-Fel1+(J1*phidd-C0)/R;
    xg=L*sinth0*theta;
    xc=-R*phi;
    xgdd=-ome^2*xg;
    xcdd=-ome^2*xc;
    HB=Fel1-T+m1*xcdd+m2*xgdd;
    vett_HB=vett_HB+abs(HB)*cos(ome*vett_t+angle(HB));
end

Fel_y=0;
C0=C02*exp(i*phi_t);
F=[C0;Fel_y];
Q0=Lq'*F;
ome=omega_t;
A=-ome^2*M+i*ome*C+K;
x0=A\Q0;
theta=x0(1);
phi=x0(2);
phidd=-ome^2*phi;
dL1=-2*R*phi;
Fel1=dL1*(k1+i*ome*c1);
T=-Fel1+(J1*phidd-C0)/R;
xg=L*sinth0*theta;
xc=-R*phi;
xgdd=-ome^2*xg;
xcdd=-ome^2*xc;
HB=Fel1-T+m1*xcdd+m2*xgdd;
vett_HB=vett_HB+abs(HB)*cos(ome*vett_t+angle(HB));

figure;plot(vett_t,vett_HB);grid





















