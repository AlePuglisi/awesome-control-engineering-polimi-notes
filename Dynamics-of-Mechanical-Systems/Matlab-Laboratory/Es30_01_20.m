clear all
close all

%PROBLEM DATA
m1=6; m2=10;
J1=0.08; J2=0.3;
L1=0.2; L2=0.3;
DL01=0.02; DL02=0.0356; DL03=0.0787;
k1=5000; k2=5000; k3=5000;
c1=2; c2=2; c3=2;
theta0=pi/3; phi0=pi/6; beta=pi/4;
F01=100; phi01=pi/3; ome01=10*pi;
Y02=0.02; phi02=pi/6; ome02=14*pi;
ct0=cos(theta0); st0=sin(theta0);
cp0=cos(phi0); sp0=sin(phi0);
g=9.81;

%MATRIX
mph=diag([m1 m1 J1 m2 m2 J2]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[L1*st0      0       1;
    L1*ct0      0       0;
     1          0       0;
    L1*st0     -L2*sp0  1;
    L1*ct0     -L2*cp0  0;
     0          1       0];

Lk=[2*L1*st0    0        1;
    L1*ct0    -2*L2*cp0  0;
    -L1*st0    2*L2*sp0  -1];

Lc=Lk;
Lf=[L1*st0      0       1;
    L1*ct0      0       0;
    0           0       1];

KelII1=zeros(3,3);KelII1(1,1)=k1*DL01*2*L1*ct0;
KelII2=zeros(3,3);KelII2(1,1)=-k2*DL02*L1*st0;KelII2(2,2)=k2*DL02*2*L2*sp0;
KelII3=zeros(3,3);KelII3(1,1)=-k3*DL03*L1*ct0;KelII3(2,2)=k3*DL03*2*L2*cp0;
KelII=KelII1 + KelII2 + KelII3;

KG1 = zeros(3,3);KG1(1,1)=-m1*g*L1*st0;
KG2 = zeros(3,3);KG2(1,1)=-m2*g*L1*st0;KG2(2,2)=m2*g*L2*sp0;
KG=KG1+KG2;

M=Lm'*mph*Lm
C=Lc'*cph*Lc
K=Lk'*kph*Lk+KelII+KG
%PARTITIONING
MFF=M(1:2,1:2);
CFF=C(1:2,1:2);
KFF=K(1:2,1:2);

MFC=M(1:2,3);
CFC=C(1:2,3);
KFC=K(1:2,3);

MCC=M(3,3);
CCC=C(3,3);
KCC=M(3,3);

MCF=M(3,1:2);
CCF=C(3,1:2);
KCF=K(3,1:2);

%..............................................
% natural frequencies and modes of vibration

[eigenvectors eigenvalues]=eig(MFF\KFF);

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%..............................................
% frequency response
%QUESTION 4
i=sqrt(-1);
vett_f=[0:0.01:10];
F0=[-cos(beta); sin(beta); 0];
Q=Lf'*F0;
F=Q(1:2);
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    x=A\F;
    out1=L1*st0*x(1);
    out2=L1*ct0*x(1)-L2*cp0*x(2);
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
end

figure(1)
subplot 211;plot(vett_f,mod1);grid
title('x_{G1}/F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure(2)
subplot 211;plot(vett_f,mod2);grid;
title('y_{G2}/F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');


%---QUESTIONS 5-6 ---
Y0=1;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    Q=-(-ome^2*MFC+i*ome*CFC+KFC)*Y0;
    x=A\Q;
    DL1d=L1*st0*x(1) + Y0;
    DL3d=-L1*st0*x(1) + 2*L2*sp0*x(2) -Y0;
    out1=(k3+i*ome*c3)*DL3d;%Fel3
    out2=(-ome^2*MCF + i*ome*CCF + KCF)*x + (-ome^2*MCC+i*ome*CCC + KCC)*Y0;%Hb
    %Hb otherwise found differently from 
    YG1=L1*ct0*x(1);
    YG1dd=-ome^2*YG1;
    YG2=L1*ct0*x(1)-L2*cp0*x(2);
    YG2dd=-ome^2*YG2;
    DL2=L1*ct0*x(1) - 2*L2*cp0*x(2);
    out3=m1*YG1dd + m2*YG2dd + (k2+i*ome*c2)*DL2;%Va
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
    mod3(k)=abs(out3);
    fas3(k)=angle(out3);
end

figure(3)
subplot 211;plot(vett_f,mod1);grid
title('F_{el3}/y0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure(4)
subplot 211;plot(vett_f,mod2);grid;
title('H_{B}/y0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');


figure(5)
subplot 211;plot(vett_f,mod3);grid
title('V_{A}/y0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas3);grid
xlabel('Freq. [Hz]');

%QUESTION 7
t=[0:0.001:2];
%Y02 part:
Y = Y02*exp(i*phi02);

A=-ome02^2*MFF+i*ome02*CFF+KFF;
Q=-(-ome02^2*MFC+i*ome02*CFC+KFC)*Y;
x=A\Q;
YG1=L1*ct0*x(1);
YG1dd=-ome02^2*YG1;
YG2=L1*ct0*x(1)-L2*cp0*x(2);
YG2dd=-ome02^2*YG2;
DL2=L1*ct0*x(1)-2*L2*cp0*x(2);
VA_1=m1*YG1dd + m2*YG2dd + (k2+i*ome02*c2)*DL2;
VAt_1=abs(VA_1)*cos(ome02*t + angle(VA_1));

%F0 part:
F0=[-cos(beta)*F01*exp(phi01*i); sin(beta)*F01*exp(phi01*i); 0];
Q=Lf'*F0;
F=Q(1:2);
A=-ome01^2*MFF+i*ome01*CFF+KFF;
x=A\F;
YG1=L1*ct0*x(1);
YG1dd=-ome01^2*YG1;
YG2=L1*ct0*x(1)-L2*cp0*x(2);
YG2dd=-ome01^2*YG2;
DL2=L1*ct0*x(1)-2*L2*cp0*x(2);
VA_2=m1*YG1dd + m2*YG2dd + (k2+i*ome01*c2)*DL2-F01*sin(beta);
VAt_2=abs(VA_2)*cos(ome01*t + angle(VA_2));

%OVERALL AND PLOT
VAt = VAt_1 + VAt_2;
figure(7);
plot(t,VAt);
title('V_{A}(t)');