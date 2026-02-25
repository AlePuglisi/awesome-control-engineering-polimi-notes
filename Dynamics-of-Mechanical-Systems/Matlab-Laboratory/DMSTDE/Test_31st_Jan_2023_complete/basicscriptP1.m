%PROBLEM 1 
clear all
close all
% ---PROBLEAM DATA---
g=9.81;
m1=10; m2=10;
J1=1.5; J2=0.8;
L=0.75; L0=0.75; h=0.1;
R=2;
k1=20000; k2=30000; k3=20000;
DL01=-8.20e-05;DL02=0.0017; DL03=0.0101;
c1=20; c2=40; c3=40;
theta0=pi/6; psi0=pi/12;
st0=sin(theta0); ct0=cos(theta0);
sp0=sin(psi0); cp0=cos(psi0);

%--MATRIX DEFINITION---(LIN. EQUATION OF MOTION) 
%QUESTION 1
mph=diag([m1 m1 J1 m2 m2 J2]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[-R*cp0          0           -L*st0;
    -R*sp0          0            L*ct0;
    0               0               1;
    -R*cp0          ct0         -L0*st0-h*ct0;
    -R*sp0          st0         L0*ct0-h*st0;
    0               0               1];

Lk=[R*cp0           0           2*L*st0;
    0               1           0;
    R*sp0           -st0    h*st0-L0*ct0];
Lc=Lk;

Lf=[-R*sp0      st0         -h*st0+L0*ct0];

KelII1=zeros(3,3);KelII1(1,1)=k1*DL01*(-R*sp0);KelII1(3,3)=k1*DL01*2*L*ct0;
KelII2=zeros(3,3);
KelII3=zeros(3,3);KelII3(1,1)=k3*DL03*R*cp0;KelII3(3,3)=k3*DL03*(h*ct0+L0*st0);
KelII3(2,3)=-k3*DL03*ct0;KelII3(3,2)=KelII3(2,3);
KelII=KelII1+KelII2+KelII3;

KG1=zeros(3,3);KG1(1,1)=-m1*g*R*cp0;KG1(3,3)=-m1*g*st0*L;
KG2=zeros(3,3);KG2(1,1)=-m2*g*R*cp0; KG2(3,3)=-m2*g*(h*ct0+L0*st0);
KG2(2,3)=m2*g*ct0;KG2(3,2)=KG2(2,3);
KG=KG1+KG2;

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KelII+KG;

%PARTITIONING OF MATRIX
MFF=M; %select correct (rows,columns) respect free coordinates
CFF=C;
KFF=K;

%..............................................
% natural frequencies and modes of vibration
%QUESTION 2
[eigenvectors eigenvalues]=eig(MFF\KFF);

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%..............................................
% frequency response FRF
%QUESTION 3 and 4
i=sqrt(-1);
vett_f=[0:0.01:15];
y0=1;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    F=Lf'*(k3+i*ome*c3)*y0;
    x=A\F; 
    xG2=-R*cp0*x(1)+st0*x(2)-(L0*st0+h*ct0)*x(3);
    yB=-R*sp0*x(1)+2*L*ct0*x(2);
    DL1d=R*cp0*x(1)+2*L*st0*x(3);
    DL3d=R*sp0*x(1)-st0*x(3)+(h*st0-L0*ct0)*x(3);
    xG1=-R*cp0*x(1)-L*st0*x(3);
    xG1dd=-ome^2*xG1;
    xG2dd=-ome^2*xG2;
    Fel1=(k1+i*ome*c1)*DL1d;
    Fel3=(k3+i*ome*c3)*DL3d;
    NA=-(m2*xG2dd+m2*xG1dd)*sp0-(m1*g+m2*g)*sp0*x(1)+k1*DL01*cp0*x(1)-Fel1*sp0-k3*DL03*sp0*x(1)+Fel3*cp0+(k3+i*ome*c3)*y0*cp0;
    mod1(k)=abs(xG2);
    fas1(k)=angle(xG2);
    mod2(k)=abs(yB);
    fas2(k)=angle(yB);
    mod3(k)=abs(NA);
    fas3(k)=angle(NA);
end

figure(1)
subplot 211;plot(vett_f,mod1);grid
title('x_{G2}/y0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure(2)
subplot 211;plot(vett_f,mod2);grid;
title('y_{B}/y0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

figure(3)
subplot 211;plot(vett_f,mod3);grid;
title('N_{A}/y0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas3);grid
xlabel('Freq. [Hz]');

%QUESTION 5 PRE-LOAD:
m2=15;
mtrx=[-2*L*st0     0           L0*ct0*k3;
      k1*cp0        0            k3*sp0;
      0             k2          -k3*st0];
b=[(m1*L+m2*L0)*ct0;  (m1+m2)*g*sp0;   -m2*g*st0];

DL0=mtrx^-1*b;
DL01=DL0(1)
DL02=DL0(2)
DL03=DL0(3)

