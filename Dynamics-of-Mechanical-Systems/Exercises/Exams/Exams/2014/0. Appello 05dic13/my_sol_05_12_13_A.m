clear all
%close all

%% Parameters
m1=2;
m2=10;
m3=3;
m4=3;
R1=0.1;
R3=0.2;
L=0.6;
J1=0.02;
J3=0.06;
J4=0.1;
k1=1000;
k2=1000;
k3=1000;
c1=1;
c2=1;
c3=1;
C01=0.1;
phi1=pi/6;
om1=16;
g=9.81;

% Physical matrices
mph=diag([J1 m2 m3+m4 m3+m4 J3 J4]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

% Jacobian matrices
Lm=[1/R1 0 0;
    1 0 0;
    1 L 0;
    0 0 0;
    -1/R3 -L/R3 1/R3;
    0 1 0];
Lk=[2 0 0;
    1 2*L -1;
    -1 -2*L 0];
Lc=Lk;
Lq=[1/R1 0 0;
    0 0 1];

% Stiffness matrices
Kg34=(m3+m4)*g*[0 0 0;
    0 -L 0;
    0 0 0];
% Final matrices
M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+Kg34;

% Matrix partitioning
MFF=M(1:2,1:2);
MFC=M(1:2,3);
MCF=M(3,1:2);
MCC=M(3,3);
CFF=C(1:2,1:2);
CFC=C(1:2,3);
CCF=C(3,1:2);
CCC=C(3,3);
KFF=K(1:2,1:2);
KFC=K(1:2,3);
KCF=K(3,1:2);
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
    Q0=Lq(1,1:2)';
    X=A\Q0;
    out1=X(1)/R1; %theta1
    out2=-1/R3*X(1)-L*X(2)/R3; %theta3 (y0=0)
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
end

figure
subplot 211;plot(vett_f,mod1);grid
title('\theta1/C0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure
subplot 211;plot(vett_f,mod2);grid;
title('\theta3/C0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

%% FRF 4

i=sqrt(-1);
vett_f=[0:0.01:10];
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    Qfc=-(-ome^2*MFC+i*ome*CFC+KFC);
    X=A\Qfc;
    out1=X(1)+L*X(2); %xg
    DL3=-2*L*X(2)-X(1);
    out2=(k3+i*ome*c3)*DL3; %Fel3
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
end

figure
subplot 211;plot(vett_f,mod1);grid
title('x_g/Fy');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure
subplot 211;plot(vett_f,mod2);grid;
title('F_{el3}/Fy');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

%% Time history (not periodic y)
t=[0:0.01:1];
% Ha due to C0
ome=om1;
 A=-ome^2*MFF+i*ome*CFF+KFF;
 Q0=Lq(1,1:2)'*C01*exp(i*phi1);
 X=A\Q0;
 xg=X(1)+L*X(2);
 xg_dd=-ome^2*xg;
 DL2=X(1)+2*L*X(2); %(y=0)
 Fel2=(2+i*ome*c2)*DL2;
 DL3=-2*L*X(2)-X(1);
 Fel3=(k3+i*ome*c3)*DL3;
 Fy=(-ome^2*MCF+i*ome*CCF+KCF)*X;
 Ha_c=(m3+m4)*xg_dd+Fel2-Fel3-Fy;
 Ha_ct=abs(Ha_c)*cos(om1*t+angle(Ha_c));
 
 % plotting
 figure
 plot(t,Ha_ct); grid
 title('Ha due to C0')