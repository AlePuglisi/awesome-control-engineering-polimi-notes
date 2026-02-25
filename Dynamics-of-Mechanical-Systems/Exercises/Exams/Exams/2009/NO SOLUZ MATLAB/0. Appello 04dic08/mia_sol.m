clear all
close all

m1=5;
m2=5;
m3=15;
J1=0.5;
J2=0.5;
R1=0.2;
k1=1000;
k2=1000;
k3=1000;
r1=2;
r2=2;
r3=2;
f1=1;
f2=2;
gamma=pi/6;
g=9.81;
i=sqrt(-1);
nDOFL=2;    %non conta il vincolo impresso


Mph=diag([m1 m1 J1 m2 m2 J2 m3]);
Kph=diag([k1 k2 k3]);
Cph=diag([r1 r2 r3]);

Jm=[1 2*R1*cos(gamma);
    0 2*R1*sin(gamma);
    0 1;
    1 3*R1/2*cos(gamma);
    0 3/2*R1*sin(gamma);
    0 1;
    1 0];
Jel=[0 2*R1;
    0 -3*R1/2;
    -1 0];
Jc=Jel;

M=Jm'*Mph*Jm;
K=Jel'*Kph*Jel;
C=Jc'*Cph*Jc;

%..................................................................
%CALCOLARE AUTOVALORI E MODI DEL SISTEMA NON SMORZATO
[eigenvectors, eigenvalues]=eig(M\K);
freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors


%................................................................PUNTO 3

vett_f=0:0.01:3;
Q=[1;3/2*R1*cos(gamma)];
for k=1:length(vett_f)
    omega=2*pi*vett_f(k);
    A=-omega^2*M+i*omega*C+K;
    x=A\Q;
    theta=x(1);
    yG2=x(2);
    mod1(k)=abs(theta);
    fas1(k)=angle(theta);
    mod2(k)=abs(yG2);
    fas2(k)=angle(yG2);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('x/F0');xlabel('Hz');ylabel('m/N')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;title('alfa/F0');xlabel('Hz');ylabel('rad/N')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')

%................................................................PUNTO 4+6

vett_f=0:0.01:3;
Q=[0;1];
for k=1:length(vett_f)
    omega=2*pi*vett_f(k);
    A=-omega^2*M+i*omega*C+K;
    x=A\Q;
    theta=x(2);
    yG2=3/2*R1*sin(gamma)*x(2);
    Fel3=(k3+i*omega*r3)*(x(1));
    mod1(k)=abs(theta);
    fas1(k)=angle(theta);
    mod2(k)=abs(yG2);
    fas2(k)=angle(yG2);
    mod3(k)=abs(Fel3);
    fas3(k)=angle(Fel3);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('theta/C0');xlabel('Hz');ylabel('rad/Nm')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;title('y_G2/C0');xlabel('Hz');ylabel('m/Nm')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod3,'r','LineWidth', 2);grid;title('Fel3/C0');xlabel('Hz');ylabel('N/Nm')
subplot 212;plot(vett_f,fas3);grid;xlabel('[Hz]');ylabel('[rad]')
zoom 'XON'

%..................................................................PUNTO 5

tempo=0:0.01:3;
np=length(tempo);
vett_spost=zeros(1,np);
ome1=2*pi*f1;  %frequenza della forza armonica
A1=-ome1^2*M+i*ome1*C+K;
Q1=[1;3/2*R1*cos(gamma)]*10*exp(i*pi/6); %modulo e fase della forzante
x1=A1\Q1;
vett_spost=vett_spost+abs(x1(1))*cos(ome1*tempo+angle(x1(1)));

ome2=2*pi*f2;  %frequenza della forza armonica
A2=-ome2^2*M+i*ome2*C+K;
Q2=[0;1]*2*exp(i*pi/3); %modulo e fase della forzante
x2=A2\Q2;
vett_spost=vett_spost+abs(x2(1))*cos(ome2*tempo+angle(x2(1)));

figure;plot(tempo,vett_spost);grid;title('x')

