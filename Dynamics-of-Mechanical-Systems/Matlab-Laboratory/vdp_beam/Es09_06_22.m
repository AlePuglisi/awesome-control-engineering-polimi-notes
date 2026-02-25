clear all
close all

%DATA
m1=10; m2=10; m3=5;
J1=0.8; J2=2; J3=0.15;
L1=0.5; L2=0.75; L3=0.3; L0=1;
k1=15000; k2=15000; k3=15000;
DL01=-0.0127; DL02=-0.0058; DL03=-0.0016;
c1=2; c2=2; c3=0.5;
theta0 = pi/6; phi0 = 2/3*pi;
ct0 = cos(theta0); st0 = sin(theta0);
cp0 = cos(phi0); sp0 = sin(phi0);
g=9.81;

%MATRIX
mph=diag([m1 m1 J1 m2 m2 J2 m3 m3 J3]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[-L1*st0     0       0;
    L1*ct0      0       0;
    1           0       0;
    -L0*st0         ct0     0;
    L0*ct0          st0     0;
    1           0       0;
    (-L0-L2)*st0     ct0     L3*sp0;
    (L2+L0)*ct0      st0     -L3*cp0;
    0           0       1];

Lk=[2*L1*ct0   0       0;
     0         1       0;
    (L0+L2)*ct0    st0      -2*L3*cp0];
Lc=Lk;

KelII1 = zeros(3,3); KelII1(1,1)=-k1*DL01*2*L1*st0;
KelII2 = zeros(3,3);
KelII3 = zeros(3,3); KelII3(1,1)=-k3*DL03*(L0+L2)*st0;
KelII3(1,2) = k3*DL03*ct0; KelII3(2,1) = KelII3(1,2);
KelII3(3,3) = k3*DL03*2*L3*sp0;
KelII=KelII1 + KelII2 + KelII3;

KG1 = zeros(3,3); KG1(1,1)=-m1*g*L1*st0;
KG2 = zeros(3,3); KG2(1,2)=m2*g*ct0; KG2(2,1)=KG2(1,2); KG2(1,1)=-m2*g*L0*st0;
KG3 = zeros(3,3); KG3(1,1)=-m3*g*(L2+L0)*st0; KG3(1,2)=m3*g*ct0;KG3(2,1)=KG3(1,2);
KG3(3,3)=m3*g*L3*sp0;
KG=KG1+KG2+KG3;

Lf = [(L0+L2)*ct0   st0     0];

M=Lm'*mph*Lm
C=Lc'*cph*Lc
K=Lk'*kph*Lk+KelII+KG
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
F = Lf'*1;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    x=A\F;
    thetadyn = x(1);
    xdyn = x(2);
    phidyn = x(3);
    out1=(L0+L2)*ct0*thetadyn+st0*xdyn;
    out2=-(L0+L2)*st0*thetadyn + ct0*xdyn + 2*L3*sp0*phidyn;
    XG1 = -L1*st0*thetadyn;
    XG1dd = -ome^2*XG1;
    XG2=ct0*xdyn -L0*st0*thetadyn;
    XG2dd=-ome^2*XG2;
    XG3=ct0*xdyn -(L0+L2)*st0*thetadyn + L3*sp0*phidyn;
    XG3dd=-ome^2*XG3;
    out3=m1*XG1dd + m2*XG2dd +m3*XG3dd; 
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
    mod3(k)=abs(out3);
    fas3(k)=angle(out3);
end

figure(1)
subplot 211;plot(vett_f,mod1);grid
title('y_{C}/F');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure(2)
subplot 211;plot(vett_f,mod2);grid;
title('x_{D}/F');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

figure(3)
subplot 211;plot(vett_f,mod3);grid;
title('H_{O}/F');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas3);grid
xlabel('Freq. [Hz]');

theta0 = pi/4; phi0 = pi;
ct0 = cos(theta0); st0 = sin(theta0);
cp0 = cos(phi0); sp0 = sin(phi0);

DL03 = -m3*g/(2*k3)
DL02 = -(m2 + 0.5*m3)*g*st0/k2
DL01 = 1/(k1*2*L1*ct0)*(-m1*g*L1*ct0 -m2*g*L0*ct0 -m3*g*0.5*(L0+L2)*ct0)
