clear all
close all

m1=10;
m2=10;
m3=5;
J1=0.8;
J2=2.0;
J3=0.15;
L1=0.5;
L2=0.75;
L3=0.3;
L0=1.0;
k1=15000;
k2=15000;
k3=15000;
c1=2;
c2=2;
c3=0.5;
theta0=pi/6;
phi0=2/3*pi;
g=9.81;
sinth0=sin(theta0);
costh0=cos(theta0);
sinphi0=sin(phi0);
cosphi0=cos(phi0);
a=L0+L2;

% dL03=-m3*g/2/k3
% dL02=-(m2*g+m3*g+k3*dL03)*sinth0/k2
% dL01=-(m1*g*L1+m2*g*L0+0.5*m3*g*(L0+L2))/(2*L1*k1)
dL02=-0.0058;
dL01=-0.0127;
dL03=-0.0016;

mph=diag([m1 J1 m2 m2 J2 m3 m3 J3]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[L1           0         0;
    1            0         0;
   -L0*sinth0  costh0      0;
    L0*costh0  sinth0      0;
    1            0         0;
   -a*sinth0   costh0      L3*sinphi0;
    a*costh0   sinth0     -L3*cosphi0;
    0            0          1];
Lk=[2*L1*costh0     0         0;
    0               1         0;
    a*costh0   sinth0     -2*L3*cosphi0];
Lc=Lk;
Lq=[a*costh0   sinth0    0];

KG1=zeros(3);KG1(1,1)=-m1*g*L1*sinth0;
KG2=zeros(3);KG2(1,1)=-m2*g*L0*sinth0;KG2(1,2)=m2*g*costh0;KG2(2,1)=m2*g*costh0;
KG3=zeros(3);KG3(1,1)=-m3*g*a*sinth0;KG3(1,2)=m3*g*costh0;KG3(2,1)=m3*g*costh0;KG3(3,3)=m3*g*L3*sinphi0;
KelII1=zeros(3);KelII1(1,1)=-k1*dL01*2*L1*sinth0;
KelII3=zeros(3);KelII3(1,1)=-k3*dL03*a*sinth0;KelII3(1,2)=k3*dL03*costh0;KelII3(2,1)=k3*dL03*costh0;KelII3(3,3)=k3*dL03*2*L3*sinphi0;

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KG1+KG2+KG3+KelII1+KelII3;

[modes,eigenvalues]=eig(M\K);
modes
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
    theta_d=x0(1);
    s=x0(2);
    phi=x0(3);
    yC=a*costh0*theta_d+s*sinth0;
    xD=-a*sinth0*theta_d+s*costh0+2*L3*sinphi0*phi;
    xG1=-L1*sinth0*theta_d;    
    xG2=-L0*sinth0*theta_d+s*costh0;
    xG3=-a*sinth0*theta_d+s*costh0+L3*sinphi0*phi;    
    xG1dd=-ome^2*xG1;
    xG2dd=-ome^2*xG2;
    xG3dd=-ome^2*xG3;
    HO=m1*xG1dd+m2*xG2dd+m3*xG3dd;
    mod1(k)=abs(yC);
    fas1(k)=angle(yC);
    mod2(k)=abs(xD);
    fas2(k)=angle(xD);
    mod3(k)=abs(HO);
    fas3(k)=angle(HO);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/N]');title('yC/F0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/N]');title('xD/F0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/N]');title('HO/F0')
subplot 212;plot(vett_f,fas3);grid;xlabel('[Hz]');ylabel('[rad]')

% ......................

theta0=pi/4;
phi0=pi;
sinth0=sin(theta0);
costh0=cos(theta0);
sinphi0=sin(phi0);
cosphi0=cos(phi0);

dL03=-m3*g/2/k3
dL02=-(m2*g+m3*g+k3*dL03)*sinth0/k2
dL01=-(m1*g*L1+m2*g*L0+0.5*m3*g*(L0+L2))/(2*L1*k1)


