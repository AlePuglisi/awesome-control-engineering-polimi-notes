clear all
close all

m1=10;
m2=15;
m3=5;
J1=0.8;
J2=2.5;
J3=0.1;
L1=0.5;
L2=0.75;
L0=1.0;
R=0.2;
k1=10000;
k2=5000;
k3=2500;
c1=10;
c2=5;
c3=1;
beta=pi/6;
g=9.81;

dL03=0.01;
% dL02=2*k3*dL03/k2
% dL01=(k2*dL02*(2*L1-R)-m2*g*L2-m3*g*L0)/(2*L2*k1)
dL01=-0.0080;
dL02=0.0100;

mph=diag([m1 J1 m2 m2 J2 m3 m3 J3])
cph=diag([c1 c2 c3])
kph=diag([k1 k2 k3])

Lm=[L1           0;
    1            0;
    2*L1         0;
    L2           0;
    1            0;
    2*L1-R      -R;
    L0           0;
    1            1];
Lk=[2*L2         0;
    -(2*L1-R)    R;
    0           -2*R]
Lc=Lk
Lq=[2*L1-R      -R
    L0           0]

KG1=zeros(2);KG1(1,1)=m1*g*L1;
KG2=zeros(2);KG2(1,1)=m2*g*2*L1;
KG3=zeros(2);KG3(1,1)=m3*g*(2*L1-R);KG3(2,1)=m3*g*(-R);KG3(1,2)=m3*g*(-R);
KelII1=zeros(2);KelII1(1,1)=k1*dL01*2*L1;
KelII2=zeros(2);KelII2(1,1)=k2*dL02*L0;

M=Lm'*mph*Lm
C=Lc'*cph*Lc
K=Lk'*kph*Lk+KG1+KG2+KG3+KelII1+KelII2

[modes,eigenvalues]=eig(M\K)
% modes
freq=sqrt(diag(eigenvalues))/2/pi



% .............................................................
% FRF 1-2

i=sqrt(-1);
F0=1;
vett_F0=[F0*cos(beta);F0*sin(beta)];
Q0=Lq'*vett_F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    phi=x0(2);
    xC=(2*L1-R)*theta-R*phi;
    yC=L0*theta;
    dL3=-2*R*phi;
    phiadd=-ome^2*(phi+theta);
    yCdd=-ome^2*yC;
    Fel3=(k3+i*ome*c3)*dL3;
    N1=m3*yCdd-F0*cos(beta)+k2*dL02*theta;
    N2=m3*yCdd-F0*cos(beta);
    T=J3*phiadd/R-Fel3;
    mod1(k)=abs(xC);
    fas1(k)=angle(xC);
    mod2(k)=abs(yC);
    fas2(k)=angle(yC);
    mod3(k)=abs(N1);
    fas3(k)=angle(N1);
    mod4(k)=abs(N2);
    fas4(k)=angle(N2);
    mod5(k)=abs(T);
    fas5(k)=angle(T);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/N]');title('xC/F0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/N]');title('yC/F0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod3,vett_f,mod4);grid;xlabel('[Hz]');ylabel('[N/N]');title('N/F0');legend('compl.','simpl.')
subplot 212;plot(vett_f,fas3,vett_f,fas4);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod5);grid;xlabel('[Hz]');ylabel('[N/N]');title('T/F0')
subplot 212;plot(vett_f,fas5);grid;xlabel('[Hz]');ylabel('[rad]')

% ......................

m3=10;
dL02=2*k3*dL03/k2
dL01=(k2*dL02*(2*L1-R)-m2*g*L2-m3*g*L0)/(2*L2*k1)

