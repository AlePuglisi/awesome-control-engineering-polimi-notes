clear all
% close all

m1=10;
m2=15;
m3=10;
J1=0.8;
J2=0.8;
J3=0.3;
L1=0.75;
L2=0.5;
R=0.25;
theta0=pi/6;
k1=7500;
k2=7500;
c2=5;
g=9.81;
dL02=0.01;
dL01=(m1+m2)*g/2/k1+k2*dL02*tan(theta0)/k1;
% t1=0.02;
% T=0.28;
% y1=0.1;

mph=diag([m1 m1 J1 m2 m2 J2 m3 J3]);
cph=diag([c2]);
kph=diag([k1 k2]);

Lm=[-L1*sin(theta0) 0 1;
     L1*cos(theta0) 0 0;
         1          0 0;
    -L1*sin(theta0) L2 1;
     L1*cos(theta0) 0 0;
         0          1 0;
    -2*L1*sin(theta0) 0 1;
    2*L1/R*sin(theta0) 0 -1/R];
Lc=[2*L1*sin(theta0) 0 -1];
Lk=[-2*L1*cos(theta0) 0 0;
    2*L1*sin(theta0) 0 -1];

KII1=zeros(3);KII1(1,1)=k1*dL01*2*L1*sin(theta0);
KII2=zeros(3);KII2(1,1)=k2*dL02*2*L1*cos(theta0);
KG1=zeros(3);KG1(1,1)=-m1*g*L1*sin(theta0);
KG2=zeros(3);KG2(1,1)=-m2*g*L1*sin(theta0);KG2(2,2)=m2*g*L2;

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KII1+KII2+KG1+KG2;

MFF=M(1:2,1:2);
CFF=C(1:2,1:2);
KFF=K(1:2,1:2);

MFC=M(1:2,3);
CFC=C(1:2,3);
KFC=K(1:2,3);

%..............................................
% natural frequencies and modes of vibration
[eigenvectors eigenvalues]=eig(MFF\KFF);

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%..............................................
% FRF1-3

i=sqrt(-1);
F0=1;
Q0=[-L1*sin(theta0); 2*L2]*F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    x0=A\Q0;
    theta=x0(1);
    phi=x0(2);
    psi=2*L1/R*sin(theta0)*theta;
    xG2=-L1*sin(theta0)*theta+L2*phi;
    dL2=2*L1*sin(theta0)*theta;
    Fel2=(k2+i*ome*c2)*dL2;
    xB=-2*L1*sin(theta0)*theta;
    xddB=-xB*ome^2;
    psidd=-psi*ome^2;
    HB=m3*xddB-J3*psidd/R-Fel2;
    mod1(k)=abs(psi);
    fas1(k)=angle(psi);
    mod2(k)=abs(xG2);
    fas2(k)=angle(xG2);
    mod3(k)=abs(HB);
    fas3(k)=angle(HB);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[rad/N]');title('disk rotation/F0')
subplot 212;plot(vett_f,fas1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/N]');title('xG2/F0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/N]');title('HB/F0')
subplot 212;plot(vett_f,fas3);grid;xlabel('[Hz]');ylabel('[deg]')

%..............................................
% FRF2

z0=1;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    Q0=-(-ome^2*MFC+i*ome*CFC+KFC)*z0;
    x0=A\Q0;
    theta=x0(1);
    phi=x0(2);
    xG2=-L1*sin(theta0)*theta+L2*phi+z0;
    dL1=-2*L1*cos(theta0)*theta;
    Fel1=k1*dL1;
    mod1(k)=abs(xG2);
    fas1(k)=angle(xG2);
    mod2(k)=abs(Fel1);
    fas2(k)=angle(Fel1);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/m]');title('xG2/y0')
subplot 212;plot(vett_f,fas1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/m]');title('Fel1/y0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[deg]')

%..............................................
% question nr. 6

theta0=pi/4;
dL01=(m1+m2)*g/2/k1+k2*dL02*tan(theta0)/k1
