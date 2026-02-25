clear all
close all

%DATA
m = 10; mA = 5;
J = 0.2; R = 1;
L = 0.25; H = 0.15; h = 0.05;
k1 = 3000; k2 = 9000;
DL01 = 0.0051; DL02 = 0.0134;
c1 = 3; c2 = 9;
theta0 = pi/6; phi0 = pi/12; beta = pi/6;
st0 = sin(theta0); ct0 = cos(theta0);
sp0 = sin(phi0); cp0 = cos(phi0);
g = 9.81;

%QUESTION 1
mph=diag([mA mA m m J]);
cph=diag([c1 c2]);
kph=diag([k1 k2]);

Lm=[-R*ct0          0;
    -R*st0          0;
    -R*ct0      -(L*sp0 + h*cp0);
    -R*st0        L*cp0 - h*sp0;
       0            1];
Lk=[R*ct0           2*L*sp0;
    R*st0          H*sp0 - L*cp0];
Lc=Lk;

Lf = [-R*ct0    -2*L*sp0;
      -R*st0     2*L*cp0;
       -R*st0    -H*sp0+L*cp0];

KelII1 = zeros(2,2); KelII1(1,1)=-k1*DL01*R*st0; KelII1(2,2)=k1*DL01*2*L*cp0;
KelII2 = zeros(2,2); KelII2(1,1)=k2*DL02*R*ct0; KelII2(2,2)=k2*DL02*(L*sp0 + H*cp0);
KelII=KelII1 + KelII2;
KGA = zeros(2,2); KGA(1,1)=-mA*g*R*ct0;
KGt = zeros(2,2); KGt(1,1)=-m*g*R*ct0; KGt(2,2)=-m*g*(L*sp0 + h*cp0);
KG=KGA + KGt;

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KelII+KG;
MFF=M;
CFF=C;
KFF=K;

%..............................................
% natural frequencies and modes of vibration
%QUESTION 2
[eigenvectors eigenvalues]=eig(MFF\KFF);

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%..............................................
% frequency response
%QUESTION 3
i=sqrt(-1);
vett_f=[0:0.01:10];
F0 = Lf'*[cos(beta); sin(beta); 0];
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    x=A\F0;
    out1=-R*ct0*x(1)-(L*sp0 + h*cp0)*x(2);
    out2=-R*st0*x(1)+(L*cp0 - h*sp0)*x(2);
    YA = -R*st0*x(1);
    YAdd = -ome^2*YA;
    YG = -R*st0*x(1)+(L*cp0 - h*sp0)*x(2);
    YGdd = -ome^2*YG;
    DL2dyn = R*st0*x(1) + (H*sp0 - L*cp0)*x(2);
    out3 = 1/ct0*(m*YGdd + m*YAdd - (k2+i*ome*c2)*DL2dyn - 1*sin(beta));
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
    mod3(k)=abs(out3);
    fas3(k)=angle(out3);
end

figure(1)
subplot 211;plot(vett_f,mod1);grid
title('FRF of x_{G} for unit F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure(2)
subplot 211;plot(vett_f,mod2);grid;
title('FRF of y_{G} for unit F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

%QUESTION 4
vett_f=[0:0.01:10];
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    F0 = Lf'*[0; 0; k2+i*c2*ome];
    x=A\F0;
    out1=(k1 + i*ome*c1)*(R*ct0*x(1) + 2*L*sp0*x(2));
    out2=(k2 + i*ome*c2)*(R*st0*x(1) + (H*sp0-L*cp0)*x(2) + 1); 
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
end

figure(3)
subplot 211;plot(vett_f,mod1);grid
title('FRF of Fel_{1dyn} for unit y0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure(4)
subplot 211;plot(vett_f,mod2);grid;
title('FRF of V_{2} for unit y0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

figure(5)
subplot 211;plot(vett_f,mod3);grid;
title('FRF of V_{A} for unit F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas3);grid
xlabel('Freq. [Hz]');

Fmax4Hz = mod3(4/0.01) 

%QUESTION 6
theta0 = pi/3;
H = 0.45;
h = 0.15;
m = 20;
st0 = sin(theta0); ct0 = cos(theta0);

A = [-2*L*sp0     L*cp0-H*sp0;
        ct0         st0];
b = [L*cp0*m*g-h*sp0;   m*g*st0+m*g*st0];
Fels_vec = A^-1*b;
DL01 = Fels_vec(1)/k1
DL02 = Fels_vec(2)/k2

