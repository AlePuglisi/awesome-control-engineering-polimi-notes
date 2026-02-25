clear all
close all

m1=10;
m2=5;
J2=0.1;
Rg=1;
R=0.2;
r=0.15;
k1=15000;
k2=15000;
c1=10;
c2=5;
psi0=pi/3;
phi0=pi/6;
g=9.81;
sinpsi0=sin(psi0);
cospsi0=cos(psi0);
sinphi0=sin(phi0);
cosphi0=cos(phi0);
csi=(Rg-R)/R;

% dL02=m2*g*(r*cosphi0-R*sinpsi0)/(k2*R*cospsi0)
% dL01=-(m1+m2)*g/k1
dL02=-0.0014;
dL01=-0.0098;

mph=diag([m1 m2 m2 J2])
cph=diag([c1 c2])
kph=diag([k1 k2])

Lm=[1           0;
    0       (Rg-R)*cospsi0+r*csi*sinphi0;
    1       (Rg-R)*sinpsi0-r*csi*cosphi0;
    0          -csi]
Lk=[1     0;
    0     (Rg-R)*cospsi0]
Lc=Lk
Lq=[1          0]

KG2=zeros(2);KG2(2,2)=m2*g*((Rg-R)*cospsi0-r*csi^2*sinphi0);
KelII2=zeros(2);KelII2(2,2)=-k2*dL02*(Rg-R)*sinpsi0;

M=Lm'*mph*Lm
C=Lc'*cph*Lc
K=Lk'*kph*Lk+KG2+KelII2

[modes,eigenvalues]=eig(M\K)
freq=sqrt(diag(eigenvalues))/2/pi


% .............................................................
% FRF 1-2

i=sqrt(-1);
F0=1;
vett_F0=[F0];
Q0=Lq'*vett_F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    y=x0(1);
    psi=x0(2);
    yC=y+(Rg-R)*sinpsi0*psi;
    yG2=y+((Rg-R)*sinpsi0-r*csi*cosphi0)*psi;
    xG2=((Rg-R)*cospsi0+r*csi*sinphi0)*psi;
    dL2=(Rg-R)*cospsi0*psi;
    xG2dd=-ome^2*xG2;
    yG2dd=-ome^2*yG2;
    Fel2=(k2+i*ome*c2)*dL2;
    N=-(Fel2+m2*xG2dd)*sinpsi0+m2*yG2dd*cospsi0-(k2*dL02*cospsi0+m2*g*sinpsi0)*psi;
    T=(Fel2+m2*xG2dd)*cospsi0+m2*yG2dd*sinpsi0+(m2*g*cospsi0-k2*dL02*sinpsi0)*psi;
    mod1(k)=abs(yC);
    fas1(k)=angle(yC);
    mod2(k)=abs(xG2);
    fas2(k)=angle(xG2);
    mod3(k)=abs(N);
    fas3(k)=angle(N);
    mod4(k)=abs(T);
    fas4(k)=angle(T);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/N]');title('yC/F0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/N]');title('xG2/F0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/N]');title('N/F0')
subplot 212;plot(vett_f,fas3);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod4);grid;xlabel('[Hz]');ylabel('[N/N]');title('T/F0')
subplot 212;plot(vett_f,fas4);grid;xlabel('[Hz]');ylabel('[rad]')

% ......................

psi0=pi/6;
phi0=pi/3;
sinpsi0=sin(psi0);
cospsi0=cos(psi0);
sinphi0=sin(phi0);
cosphi0=cos(phi0);
dL02=m2*g*(r*cosphi0-R*sinpsi0)/(k2*R*cospsi0)
dL01=-(m1+m2)*g/k1

