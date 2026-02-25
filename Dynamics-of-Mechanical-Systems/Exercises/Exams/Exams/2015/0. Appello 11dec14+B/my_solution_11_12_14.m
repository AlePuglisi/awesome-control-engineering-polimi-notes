clear all
close all

%% Parameters
m1=10;
m2=5;
m3=3;
J1=0.2;
J2=0.02;
J3=0.01;
L1=0.50/2; % in my solution I've consider the bars length 2L1 and 2L2
L2=0.25/2;
L0=0.10;
k1=3000;
k2=1000;
k3=1000;
DL02=0.02;
DL03=0.02;
c1=10;
c2=0.5;
c3=0.5;
F0=100;
C0=10;
phi1=pi/6;
phi2=pi/3;
om1=2*pi;
om2=4*pi;
g=9.81;

% Physical matrices
mph=diag([m1 m1 J1 m2 m2 J2 m3 m3 J3]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

% Jacobian matrices
Lm=[L1 0;
    0 0;
    1 0;
    2*L1 0;
    L2 0;
    1 0;
    2*L1 1;
    L0 1;
    1 0];
Lk=[L1 0;
    0 1 ;
    -2*L1 -1];
Lc=Lk;
Lq=[1 0;
    2*L1 1];

% Stiffness matrices
KelII3=zeros(2,2); KelII3(1,1)=k3*DL03*L0;
Kg1=zeros(2,2); Kg1(1,1)=m1*g*L1;
Kg2=zeros(2,2); Kg2(1,1)=m2*g*2*L1;
Kg3=m3*g*[2*L1 1;
          1 0];
% Final matrices
M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KelII3+Kg1+Kg2+Kg3;


%..............................................
%% natural frequencies and modes of vibration

[eigenvectors eigenvalues]=eig(M\K);

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%..............................................
%% FRF 3

i=sqrt(-1);
vett_f=[0:0.01:5];
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    F=Lq'*[0; 1];
    X=A\F;
    out1=X(1); % theta
    x=X(2);
    DL3=-2*L1*out1-x;
    out2=(k3+i*ome*c3)*DL3; % Fel3
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
end

figure(1)
subplot 211;plot(vett_f,mod1);grid
title('(\theta)/F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure(2)
subplot 211;plot(vett_f,mod2);grid;
title('F_{el3}/F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');
%% Time history
t=[0:0.005:1];
% Vo due to F01 excitation
ome=om1;
A=-ome^2*M+i*ome*C+K;
F01=F0*exp(i*phi1);
F=Lq'*[0; F01];
X=A\F;
theta=X(1);
theta_pp=-ome^2*theta;
Vo_f=-(m2*L2+m3*L0)*theta_pp;
Vo_ft=abs(Vo_f)*cos(ome*t+angle(Vo_f));

% Vo due to C02 excitation
ome=om2;
A=-ome^2*M+i*ome*C+K;
C02=C0*exp(i*phi2);
F=Lq'*[C02; 0];
X=A\F;
theta=X(1);
theta_pp=-ome^2*theta;
Vo_c=-(m2*L2+m3*L0)*theta_pp;
Vo_ct=abs(Vo_c)*cos(ome*t+angle(Vo_c));

% plotting
figure(3)
plot(t, Vo_ft+Vo_ct, t, Vo_ft,'r--', t, Vo_ct, 'g--'); grid
title('Vertical reaction force at O')
legend('totalforce','effect of F01', 'effect of C02')


%% 4. Preload computation
Fel03=k3*DL03;
Fel01=2*Fel03-g*(m2*L2+m3*L0)/L1;
DL01=Fel01/k1