clear all
close all

%% Parameters

m1=10;m2=2;m3=5;
J1=0.8;J2=0.01;J3=0.2;
L1=1;L2=0.3;L0=0.6;R=0.3;
k1=1000;k2=2000;k3=3000;
dL02=0.1;dL03=0.0828;
c1=2;c2=4;c3=6;
y02=0.01;y03=0.02;
C01=100;
phi1=pi/6;phi2=-pi/6;phi3=pi/3;
om1=28;om2=14;om3=7;
g=9.81;

% Physical matrices
mph=diag([m1 m1 J1 m2 m2 J2 m3 m3 J3]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);


% Jacobian matrices
Lm=[0 0 0;
    0 L1/2 1;
    0 1 0;
    0 -L2/2 0;
    0 L1 1;
    0 1 0;
    1 0 0;
    0 L0 1;
    0 L0/R 1/R];
Lk=[1 0 0;
    0 L1 1;
    0 -2*L0 -2];
Lc=Lk;
Lq=[0 L0/R 0;
    0 0 1];

% Stiffness matrices
KelII3=k3*dL03*[0 -2 0;
    -2 0 0;
    0 0 0];
Kg2=zeros(3,3); Kg2(2,2)=-m2*g*L2/2;
Kg3=m3*g*[0 1 0;
          1 0 0;
          0 0 0];

% Final matrices
M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KelII3+Kg2+Kg3;

% Matrix partitioning
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

%..............................................
%% FRF 3

i=sqrt(-1);
vett_f=[0:0.01:10];
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    Qf=-Lq(1,1:2)'; %C0=1
    X=A\Qf;
    y=0;
    theta=X(2);
    out1=L0/R*theta; %phi
    out2=L0*theta+y; %yC
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
title('y_c/C0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

%% FRF 4
i=sqrt(-1);
vett_f=[0:0.01:10];
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    Qfc=-(-ome^2*MFC+i*ome*CFC+KFC); %y0=1
    X=A\Qfc;
    DL3=-2*L0*X(2)-2;
    out1=X(1); %xc=x
    out2=(k3+i*ome*c3)*DL3; %Fel3
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
end

figure
subplot 211;plot(vett_f,mod1);grid
title('x_c/Fy');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure
subplot 211;plot(vett_f,mod2);grid;
title('F_{el3}/Fy');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

%% Time history
t=[0:0.001:1.8];

% Vo due to C0
ome=om1;
A=-ome^2*MFF+i*ome*CFF+KFF;
Qf=-Lq(1,1:2)'*C01*exp(i*phi1);
X=A\Qf;
Vo_c=(-ome^2*MCF+i*ome*CCF+KCF)*X;
Vo_ct=abs(Vo_c)*cos(ome*t+angle(Vo_c));

% Vo due to periodic y02
ome=om2;
A=-ome^2*MFF+i*ome*CFF+KFF;
Qfc=-(-ome^2*MFC+i*ome*CFC+KFC)*y02*exp(i*phi2);
X=A\Qfc;
Vo_y2=(-ome^2*MCF+i*ome*CCF+KCF)*X+(-ome^2*MCC+i*ome*CCC+KCC)*y02*exp(i*phi2);
Vo_y2t=abs(Vo_y2)*cos(ome*t+angle(Vo_y2));

% Vo due to periodic y03
ome=om3;
A=-ome^2*MFF+i*ome*CFF+KFF;
Qfc=-(-ome^2*MFC+i*ome*CFC+KFC)*y03*exp(i*phi3);
X=A\Qfc;
Vo_y3=(-ome^2*MCF+i*ome*CCF+KCF)*X+(-ome^2*MCC+i*ome*CCC+KCC)*y03*exp(i*phi3);
Vo_y3t=abs(Vo_y3)*cos(ome*t+angle(Vo_y3));

% plotting
figure
plot(t,Vo_ct,t,Vo_y2t+Vo_y3t,'r',t,Vo_ct+Vo_y2t+Vo_y3t,'g'); grid
title('Time history reaction force at O')
legend('Due to C01','Due to y02+y03','total')

%% 6. Static preload k3
dL02_new=2*dL02;
Fel02=dL02_new*k2;
b=sqrt(L1^2+L2^2);
Fel03=m3*g/2+L1*Fel02+b*m2*g;
DL03_new=Fel03/k3