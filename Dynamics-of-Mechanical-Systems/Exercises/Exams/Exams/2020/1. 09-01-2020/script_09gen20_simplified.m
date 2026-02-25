clear all
close all
clc

m1=10;
m2=5;
m3=10;
J2=0.05;
J3=1.25;
L=0.25;
R=0.5;
k1=1000;
k2=500;
k3=1000;
c1=1;
c2=0.1;
c3=1;
g=9.81;

mph=diag([m1 m2 J2 m3 J3])
cph=diag([c1 c2 c3])
kph=diag([k1 k2 k3])

Lm=[1  0   0;
    1  -L  0;
    0  1   0;
    1  0  -R;
    0  0   1]

Lk=[1  -2*L  0;
    0   2*L  -R;
   -1   0    0]

Lc=Lk

KG=zeros(3); KG(2,2)=-m2*g*L;

MFF=Lm'*mph*Lm
CFF=Lc'*cph*Lc
KFF=Lk'*kph*Lk+KG

%..............................................
% natural frequencies and modes of vibration
[eigenvectors eigenvalues]=eig(MFF\KFF)

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%..............................................
% FRF 1, 2, 3

i=sqrt(-1);
F0=1;
Q0=[1; 0; -R]*F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    x0=A\Q0;
    x=x0(1);
    theta=x0(2);
    phi=x0(3);
    xC=x-R*phi;
    dL1=x-2*L*theta;
    dL2=2*L*theta-R*phi;
    Fel1=(k1+i*ome*c1)*dL1;
    Fel2=(k2+i*ome*c2)*dL2;
    xG=x-L*theta;
    xGdd=-ome^2*xG;
    HA=Fel1-Fel2+m2*xGdd;
    mod1(k)=abs(x);
    fas1(k)=angle(x);
    mod2(k)=abs(xC);
    fas2(k)=angle(xC);
    mod3(k)=abs(Fel1);
    fas3(k)=angle(Fel1);
    mod4(k)=abs(HA);
    fas4(k)=angle(HA);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/N]');title('x/F0')
subplot 212;plot(vett_f,fas1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/N]');title('xC/F0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/N]');title('Fel1/F0')
subplot 212;plot(vett_f,fas3);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod4);grid;xlabel('[Hz]');ylabel('[N/N]');title('HA/F0')
subplot 212;plot(vett_f,fas4);grid;xlabel('[Hz]');ylabel('[deg]')


