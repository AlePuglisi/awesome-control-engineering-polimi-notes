clear all
close all
%% Parameters
m1=10;
m2=5;
J1=0.8;
J2=0.2;
L=1;
L0=0.6;
R=0.3;
k1=1000;
k2=2000;
k3=3000;
DL02=0.125;
DL03=0.1;
c1=2;
c2=4;
c3=6;
y02=0.001;
y03=0.002;
C01=2;
phi1=pi/6;
phi2=-pi/6;
phi3=pi/3;
om1=30;
om2=20;
om3=10;
g=9.81;

% Physical matrices
mph=diag([m1 m1 J1 m2 m2 J2]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

% Jacobian matrices
Lm=[L/2 0 1;
    0 0 0;
    1 0 0;
    L0 0 1;
    0 -1 0;
    L0/R 0 0];
Lk=[0 1 0;
    -2*L0 0 -2;
    L 0 0];
Lc=Lk;
Lq=[L0/R 0 0;
    0 0 1];

% Stiffness matrices
KelII2=k2*DL02*[0 -2 0;
                -2 0 0
                0 0 0];
Kg1=zeros(3,3); Kg1(1,1)=m1*g*L/2;
Kg2=zeros(3,3); Kg2(1,1)=m2*g*L0;

% Final matrices
M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KelII2+Kg1+Kg2;
MFF=M(1:2,1:2);
CFF=C(1:2,1:2);
KFF=K(1:2,1:2);
MFC=M(1:2,3);
CFC=C(1:2,3);
KFC=K(1:2,3);
MCF=M(3,1:2);
CCF=C(3,1:2);
KCF=K(3,1:2);
MCC=M(3,3);
CCC=C(3,3);
KCC=K(3,3);
%..............................................
% natural frequencies and modes of vibration

[eigenvectors eigenvalues]=eig(MFF\KFF);

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%% Static preload k3
DL02_new=2*DL02;
Fel02=DL02_new*k2;
Fel03=2*L0*Fel02/L;
DL03_new=Fel03/k3
%..............................................
% frequency response

i=sqrt(-1);
vett_f=[0:0.01:10];
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    Qf=Lq(1,1:2)'; %C0=1
    X=A\Qf;
    y=0;
    theta=X(1);
    out1=L0/R*theta; %phi
    out2=L0*theta+y;
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
end

figure
subplot 211;plot(vett_f,mod1);grid
title('\phi/C0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure
subplot 211;plot(vett_f,mod2);grid;
title('x_c/C0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

i=sqrt(-1);
vett_f=[0:0.01:10];
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    Qfc=-(-ome^2*MFC+i*ome*CFC+KFC); %y0=1
    X=A\Qfc;
    DL2=-2*L0*X(1)-2;
    out1=-X(2); %yc=-x
    out2=(k2+i*ome*c2)*DL2; %Fel2
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
end

figure
subplot 211;plot(vett_f,mod1);grid
title('y_c/Fy');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure
subplot 211;plot(vett_f,mod2);grid;
title('F_{el2}/Fy');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

%% Time history
t=[0:0.001:1.3];

% Ho due to C0
ome=om1;
A=-ome^2*MFF+i*ome*CFF+KFF;
Qf=Lq(1,1:2)'*C01*exp(i*phi1);
X=A\Qf;
Ho_c=(-ome^2*MCF+i*ome*CCF+KCF)*X;
Ho_ct=abs(Ho_c)*cos(ome*t+angle(Ho_c));

% Ho due to periodic y02
ome=om2;
A=-ome^2*MFF+i*ome*CFF+KFF;
Qfc=-(-ome^2*MFC+i*ome*CFC+KFC)*y02*exp(i*phi2);
X=A\Qfc;
Ho_y2=(-ome^2*MCF+i*ome*CCF+KCF)*X+(-ome^2*MCC+i*ome*CCC+KCC)*y02*exp(i*phi2);
Ho_y2t=abs(Ho_y2)*cos(ome*t+angle(Ho_y2));

% Ho due to periodic y03
ome=om3;
A=-ome^2*MFF+i*ome*CFF+KFF;
Qfc=-(-ome^2*MFC+i*ome*CFC+KFC)*y03*exp(i*phi3);
X=A\Qfc;
Ho_y3=(-ome^2*MCF+i*ome*CCF+KCF)*X+(-ome^2*MCC+i*ome*CCC+KCC)*y03*exp(i*phi3);
Ho_y3t=abs(Ho_y3)*cos(ome*t+angle(Ho_y3));

% plotting
figure
plot(t,Ho_ct,t,Ho_y2t+Ho_y3t,'r',t,Ho_ct+Ho_y2t+Ho_y3t,'g'); grid
title('Time history reaction force at O')
legend('Due to C01','Due to y02+y03','total')