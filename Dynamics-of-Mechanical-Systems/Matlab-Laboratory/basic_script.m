clear all
close all

%--DATA--
m1 = 10; m2 = 5; m3 = 2.5; m4 = 5; 
J2 = 0.4; J3 = 0.05; J4 = 0.05;
L = 0.5;
R = 0.15;
k1 = 3000; k2 = 3000; k3 = 3000;
DL01 = -0.0098; DL02 = 0.0082; DL03 = 0;
c1 = 3; c2 = 3; c3 = 3;
g = 9.81;
theta0 = pi/3;
phi0 = pi/6; %recomputed respect data
st0 = sin(theta0); ct0 = cos(theta0);
sp0 = sin(phi0); cp0 = cos(phi0);
X01 = 0.04; ome1 = 10; phi01 = -pi/3;
Y02 = 0.025; ome2 = 30; phi02 = pi/3;

%-- matrix evaluation -- 
mph=diag([m1 m2 m2 J2 m3 m3 J3 m4 J4]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[1       0       0;
    1       0       L*ct0;
    0       0       -L*st0;
    0       0       1;
    1     -L/2*sp0  L*ct0;
    0      L/2*cp0  -L*st0;
    0       1           0;
    1       0         2*L*ct0;
    -1/R    0       -2*L/R*ct0];
Lk=[0       0       -2*L*st0;
    0       -L*cp0  L*st0;
    -1      0       -2*L*ct0];
Lc=Lk;

Lf = [0     L*cp0   -L*st0;
      -1/R    0     -2*L/R*ct0];

KelII1 = zeros(3,3); KelII1(3,3)=-2*L*ct0*k1*DL01;
KelII2 = zeros(3,3);KelII2(2,2)=L*sp0*k2*DL02;KelII2(3,3)=L*ct0*DL02*k2;
KelII3 = zeros(3,3);KelII3(3,3)=2*L*st0*DL03;
KelII=KelII1 + KelII2 + KelII3;
KG2 = zeros(3,3); KG2(3,3)=-L*ct0*m2*g;
KG3 = zeros(3,3);KG3(2,2)=-L/2*sp0*m3*g; KG3(3,3)=-L*ct0*m3*g;
KG=KG2 + KG3;

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KelII+KG;
MFF = M;
CFF= C;
KFF= K;

%..............................................
% natural frequencies and modes of vibration

[eigenvectors eigenvalues]=eig(MFF\KFF);

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%..............................................
% frequency response
%FRF OF QUESTION 3:
i=sqrt(-1);
vett_f=[0:0.01:10];
F0 = Lf'*[0;  1];
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    X0 = A^-1*F0;
    out1=-2*L*st0*X0(3);
    out2=-X0(3) + X0(2);
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
end

figure(1)
subplot 211;plot(vett_f,mod1);grid
title('FRF of y_{A} for unit C');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure(2)
subplot 211;plot(vett_f,mod2);grid;
title('FRF of \alpha for unit C');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

%FRF OF QUESTION 4:
i=sqrt(-1);
vett_f=[0:0.01:10];
F0 = Lf'*[1;  0];
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    X0 = A^-1*F0;
    out1=-2*L/R*ct0*X0(3)- 1/R*X0(1);
    out2=L*ct0*X0(3) + X0(1) - L/2*sp0*X0(2);
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
end

figure(3)
subplot 211;plot(vett_f,mod1);grid
title('FRF of \psi for unit y');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure(4)
subplot 211;plot(vett_f,mod2);grid;
title('FRF of X_{G2} for unit y');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

% ---QUESTION 5---
t = [0:0.001:2];
%if now x become the new forcing effect we should evaluate
MFF = M(2:3,2:3);
CFF = C(2:3, 2:3);
KFF = K(2:3, 2:3);
MFC = M(2:3,1);
CFC = C(2:3,1);
KFC = K(2:3,1);

%1) EFFECT OF X
X = X01*exp(i*phi01);
F1 = -(-ome1^2*MFC + i*ome1*CFC + KFC)*X;
A=-ome1^2*MFF+i*ome1*CFF+KFF;
X01 = A\F1;
Psi = -2*L/R*ct0*X01(2)-1/R*X;
Psidd = -ome1^2*Psi;
T1 = J4/R*Psidd;
T1t = abs(T1)*cos(ome1*t + angle(T1));

YG2 = -L*st0*X01(2);
YG2dd = -ome1^2*YG2;
YG3 = -L*st0*X01(2) + L/2*cp0*X;
YG3dd = -ome1^2*YG2;
DL1 = -2*L*st0*X01(2);
DL2 = L*st0*X01(2) - L*cp0*X;
DL1d = -i*ome1*DL1;
DL2d = -i*ome1*DL2;
N1 = m2*YG2dd + m3*YG3dd + (k1 + c1*ome1*i)*DL1 + (k2 + c2*ome1*i)*DL2
N1t = abs(N1)*cos(ome1*t + angle(N1));

%2) EFFECT OF Y
Y = Y02*exp(i*phi02);
ome = ome2;
F = [0 ; Y];
F2 = Lf(:,2:3)'*F;
A=-ome2^2*MFF+i*ome2*CFF+KFF;
X02 = A\F2;

Psi = -2*L/R*ct0*X02(1);
Psidd = -ome2^2*Psi;
T2 = J4/R*Psidd;
T2t = abs(T2)*cos(ome2*t + angle(T2));

YG3 = -L*st0*X02(2) + L/2*cp0*X02(1);
YG3dd = -ome2^2*YG2;
YG2 = -L*st0*X02(2);
YG2dd = -ome2^2*YG2;
DL1 = -2*L*st0*X02(2);
DL2 = L*st0*X02(2) - L*cp0*X02(1);
DL1d = -i*ome2*DL1;
DL2d = -i*ome2*DL2;
N2 = m2*YG2dd + m3*YG3dd + (k1 + c1*ome2*i)*DL1 + (k2 + c2*ome2*i)*DL2 -(k2 +i*ome2*c2)*Y;
N2t = abs(N2)*cos(ome2*t + angle(N2));

Tt = T1t + T2t;
Nt = N1t + N2t;
%PLOTTING
figure(5)
plot(t, Nt);
title('N time history')

figure(6)
plot(t, Tt);
title('T time history')