clear all
close all

%% Parameters
m1=2;
m2=6;
m3=3;
J1=0.002;
J2=0.05;
J3=0.015;
R=0.1;
L1=0.1;
L2=0.3;
L0=0.2;
k1=1000;
k2=1200;
c1=1;
c2=0.5;
y01=0.01;
phi01=pi/6;
om01=15;
g=9.81;

% Physical matrices
mph=diag([m1 m1 J1 m2 m2 J2 m3 m3 J3]);
cph=diag([c1 c2]);
kph=diag([k1 k2]);

% Jacobian matrices
Lm=[-L1 0 1;
    0 0 0;
    1 0 0;
    0 0 1;
    L2 0 0;
    1 0 0;
    -R 1 1;
    L0 0 0;
    1 -1/R 0];
Lk=[0 1 0;
    2*L2 0 0];
Lc=Lk;
Lq=[-R 1 1;
    0 0 1];

% Stiffness matrices
Kg1=zeros(3,3); Kg1(1,1)=-m1*g*L1;
Kg3=m3*g*[-R 1 0;
          1 0 0;
          0 0 0];

% Final matrices
M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+Kg1+Kg3;

% Matrix partition
MFF=M(1:2,1:2); %from row 1 to 2 take the 1 and 2 column element
CFF=C(1:2,1:2);
KFF=K(1:2,1:2);
MFC=M(1:2,3); %from row 1 to 2 take the 3 column element
CFC=C(1:2,3);
KFC=K(1:2,3);
MCF=M(3,1:2);
CCF=C(3,1:2);
KCF=K(3,1:2);
MCC=M(3,3);
CCC=C(3,3);
KCC=K(3,3);
%..............................................
%% natural frequencies and modes of vibration

[eigenvectors eigenvalues]=eig(MFF\KFF);

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%..............................................
%% FRF 3

i=sqrt(-1);
vett_f=[0:0.01:10];
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    F0=1;
    Q0=Lq(1,1:2)'*F0;
    X=A\Q0;
    x=X(2);
    out1=X(1); % theta
    out2=-x/R+out1; % absolute rotation
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
end

figure
subplot 211;plot(vett_f,mod1);grid
title('(\theta)/F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure
subplot 211;plot(vett_f,mod2);grid;
title('(\phi)^{A}/F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

%% FRF 4
i=sqrt(-1);
vett_f=[0:0.01:10];
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    y0=1;
    QFC=-(-ome^2*MFC+i*ome*CFC+KFC)*y0;
    X=A\QFC;
    x=X(2);
    theta=X(1);
    DL2=2*L2*theta;
    out1=-R*theta+x+y0; % xc
    out2=(k2+i*ome*c2)*DL2; % Fel2
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
end

figure
subplot 211;plot(vett_f,mod1);grid
title('xc/Fy');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure
subplot 211;plot(vett_f,mod2);grid;
title('F_{el2}/Fy');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

%% Time history (modified just y, not F periodic)
t=[0:0.005:1];
% Vo due to y0 constraint displacement
ome=om01;
A=-ome^2*MFF+i*ome*CFF+KFF;
y0=y01*exp(phi01);
QFC=-(-ome^2*MFC+i*ome*CFC+KFC)*y0;
X=A\QFC;
theta=X(1);
DL2=2*L2*theta;
Fel2=(k2+i*ome*c2)*DL2;
theta_pp=-ome^2*theta;
Vo_y=(L2*m2+L0*m3)-Fel2;
Vo_yt=abs(Vo_y)*cos(ome*t+angle(Vo_y));

% plotting
figure
plot(t,Vo_yt);
title('Vo due to y')