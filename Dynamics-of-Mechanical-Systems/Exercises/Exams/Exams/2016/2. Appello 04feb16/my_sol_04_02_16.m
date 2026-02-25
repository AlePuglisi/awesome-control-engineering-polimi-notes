clear all
close all

%% Parameters 
m1=5;
m2=10;
J1=0.2;
J2=1.2;
L1=0.7;
L2=1.2;
AB=0.4;
AC=08;
k1=1000;
k2=2000;
DL01=-0.0654;
DL02=-0.0286;
c1=2;
c2=0.2;
th0=pi/6;
alpha=pi/6;
g=9.81;
c0=cos(th0);
s0=sin(th0);

% Physical matrices
mph=diag([m1 m1 J1 m2 m2 J2]);
cph=diag([c1 c2]);
kph=diag([k1 k2]);

% Jacobian matrices
Lm=[-L1/2*s0 0;
    -L1/2*c0 0;
    1 0;
    -L1*s0 0;
    -L1*c0 L2/2-AB;
    0 1];
Lk=[-L1*c0 -AB;
    -L1*c0 L2-AB];
Lc=Lk;
Lq=[1 0;
    -L1*s0 0;
    -L1*c0 L2/2-AB];

% Stiffness matrices
KelII1=zeros(2,2); KelII1(1,1)=k1*DL01*L1*s0;
KelII2=zeros(2,2); KelII2(1,1)=k2*DL02*L1*s0;
Kg1=zeros(2,2); Kg1(1,1)=m1*g*L1*s0/2;
Kg2=zeros(2,2); Kg2(1,1)=m2*g*L1*s0;

% Final matrices
M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KelII1+KelII2+Kg1+Kg2;

%..............................................
% natural frequencies and modes of vibration

[eigenvectors eigenvalues]=eig(M\K);

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%..............................................
%% FRF 3-5

i=sqrt(-1);
vett_f=[0:0.01:10];
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    F=Lq'*[1; 0; 0];
    x=A\F; % x(1)=theta, x(2)=phi 
    out1=x(2); % phi
    out2=-L1/2*s0*x(1); % xg1
    DL1=-L1*c0*x(1)-AB*x(2);
    DL2=-L1*c0*x(1)+(L2-AB)*x(2);
    xg2=out2;
    yg2=-L1*c0*x(1)+(L2/2-AB)*x(2);
    xg2_dd=-ome^2*xg2;
    yg2_dd=-ome^2*yg2;
    Fel1=(k1+i*ome*c1)*DL1;
    Fel2=(k2+i*ome*c2)*DL2;
    out3=(Fel1+Fel2+m2*yg2_dd)*s0+m2*xg2_dd*c0; % Ta
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
    mod3(k)=abs(out3);
    fas3(k)=angle(out3);
end

figure
subplot 211;plot(vett_f,mod1);grid
title('phi/C0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure
subplot 211;plot(vett_f,mod2);grid;
title('xg1/C0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

figure
subplot 211;plot(vett_f,mod3);grid;
title('Ta/C0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas3);grid
xlabel('Freq. [Hz]');

%% FRF 4
i=sqrt(-1);
vett_f=[0:0.01:10];
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    F=Lq'*[0; cos(alpha); sin(alpha)];
    x=A\F; % x(1)=theta, x(2)=phi 
    out1=x(2)+x(1); % phi_rel
    DL2=-L1*c0*x(1)+(L2-AB)*x(2);
    out2=(k2+i*ome*c2)*DL2; % Fel2
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
    mod3(k)=abs(out3);
    fas3(k)=angle(out3);
end

figure
subplot 211;plot(vett_f,mod1);grid
title('phi_rel/F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure
subplot 211;plot(vett_f,mod2);grid;
title('Fel2/F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

%% Preload computation
AB=0.8;
AC=0.4;
M1=[AB -AC;
    1 1];
M2=[m2*g*(L2/2-AB);
    -m1*g/2-m2*g];
Fel0=M1\M2;
Fel01=Fel0(1);
Fel02=Fel0(2);
DL01=Fel01/k1
DL02=Fel02/k2

