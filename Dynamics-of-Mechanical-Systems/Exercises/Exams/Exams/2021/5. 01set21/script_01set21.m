clear all
close all

m1=10;
m2=15;
J1=0.05;
J2=0.2;
L1=0.25;
L2=0.40;
k1=5000;
k2=5000;
c1=5;
c2=5;
g=9.81;
theta0=pi/6;
phi0=pi/12;

costh0=cos(theta0);
sinth0=sin(theta0);
cosphi0=cos(phi0);
sinphi0=sin(phi0);
tanphi0=sinphi0/cosphi0;
 
mph=diag([m1 J1 m2 m2 J2]);
cph=diag([c1 c2]);
kph=diag([k1 k2]);
 
csi0=L1*costh0/sinphi0;
% dL01=(m1*g/k1)*(csi0-L2)/L1*(cosphi0/costh0)
% dL02=(m1*g*L1*sinth0+m2*g*((csi0-L2)*cosphi0+L1*sinth0))/(2*L1*k2*costh0)
dL01=0.0382;
dL02=0.0428;

Lm=[L1                                          0;
    1                                           0;
    L1*costh0-L1*sinth0/tanphi0       -L1*costh0/sinphi0^2+L2*sinphi0;
         0                                 -L2*cosphi0;
         0                                      1];
Lk=[L1*costh0-L1*sinth0/tanphi0       -L1*costh0/sinphi0^2;
    -2*L1*costh0                                0];
Lq=[1       0;
    0   -2*L2*cosphi0];
Lc=Lk;

KG1=zeros(2);KG1(1,1)=m1*g*L1*costh0;
KG2=zeros(2);KG2(2,2)=m2*g*L2*sinphi0;
Kel1=k1*dL01*[-L1*sinth0-L1*costh0/tanphi0    L1*sinth0/sinphi0^2;
              L1*sinth0/sinphi0^2             2*L1*costh0*cosphi0/sinphi0^3];
Kel2=zeros(2);Kel2(1,1)=k2*dL02*2*L1*sinth0;

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KG1+KG2+Kel1+Kel2;

[modes,eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi

% .............................................................
% FRF 1

i=sqrt(-1);
C0=1;
F0=0;
vett_F0=[C0;F0];
Q0=Lq'*vett_F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta_d=x0(1);
    phi_d=x0(2);
    yg2=-L2*cosphi0*phi_d;
    xb=(L1*costh0-L1*sinth0/tanphi0)*theta_d-L1*costh0/sinphi0^2*phi_d;
    mod1(k)=abs(yg2);
    fas1(k)=angle(yg2);
    mod2(k)=abs(xb);
    fas2(k)=angle(xb);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('yg2/C0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('xb/C0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')

% .............................................................
% FRF 2

C0=0;
F0=1;
vett_F0=[C0;F0];
Q0=Lq'*vett_F0;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta_d=x0(1);
    phi_d=x0(2);
    xg2=(L1*costh0-L1*sinth0/tanphi0)*theta_d-(L1*costh0/sinphi0^2+L2*sinphi0)*phi_d;
    dL2=-2*L1*costh0*theta_d;
    Fel2= (k2+i*ome*c2)*dL2;
    mod1(k)=abs(xg2);
    fas1(k)=angle(xg2);
    mod2(k)=abs(Fel2);
    fas2(k)=angle(Fel2);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/N]');title('xg2/F0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/N]');title('Fel2/F0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')

% .....................................................................
% FRF3

Nst=m2*g*L2/csi0*cosphi0;

i=sqrt(-1);
C0=0;
F0=1;
vett_F0=[C0;F0];
Q0=Lq'*vett_F0;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta_d=x0(1);
    phi_d=x0(2);
    xg2=(L1*costh0-L1*sinth0/tanphi0)*theta_d-(L1*costh0/sinphi0^2+L2*sinphi0)*phi_d;
    yg2=-L2*cosphi0*phi_d;
    xddg2=-ome^2*xg2;
    yddg2=-ome^2*yg2;
    phidd=-phi_d*yg2;
    Nd=(Nst*L1*sinth0/sinphi0*theta_d+Nst*L1*costh0*cosphi0/sinphi0^2*phi_d+m2*g*L2*sinphi0*phi_d+m2*yddg2*L2*cosphi0-m2*xddg2*L2*sinphi0-J2*phidd)/csi0;
    mod1(k)=abs(Nd);
    fas1(k)=angle(Nd);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[N/N]');title('Nd/F0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

% ......................

m1=15;
m2=20;
dL01=(m1*g/k1)*(csi0-L2)/L1*(cosphi0/costh0)
dL02=(m1*g*L1*sinth0+m2*g*((csi0-L2)*cosphi0+L1*sinth0))/(2*L1*k2*costh0)

