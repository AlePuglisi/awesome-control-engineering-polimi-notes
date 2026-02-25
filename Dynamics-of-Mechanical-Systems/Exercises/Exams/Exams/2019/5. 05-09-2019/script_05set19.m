clear all
close all

m1=10;
L1=0.5;
J1=0.2;
m2=5;
J2=0.1;
m3=10;
L3=0.5;
J3=0.2;
k1=3000;
k2=6000;
k3=3000;
c1=3;
c2=3;
c3=3;
g=9.81;
theta0=pi/6;
phi0=pi/6;
L0=0.75;
h=0.1;

cth0=cos(theta0);
sth0=sin(theta0);
cphi0=cos(phi0);
sphi0=sin(phi0);

Fel03=m3*g/2*tan(phi0);
Fel02=-(m2+m3)*g*sth0+Fel03*cth0;
xD=L0*cth0-h*sth0;
xG3=xD+L3*sphi0;
yE=L0*sth0+h*cth0-2*L3*cphi0;
Fel01=(-m1*g*L1*cth0-m2*g*xD-m3*g*xG3-Fel03*yE)/(2*L1*cth0);

% dL01=Fel01/k1
% dL02=Fel02/k2
% dL03=Fel03/k3

dL01=-0.055;
dL02=-0.016;
dL03=0.009;

mph=diag([m1 J1 m2 m2 J2 m3 m3 J3]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[L1                 0     0;
    1                  0     0;
    -L0*sth0-h*cth0   cth0   0;
     L0*cth0-h*sth0   sth0   0;
    1                  0     0;
    -L0*sth0-h*cth0   cth0   L3*cphi0;
     L0*cth0-h*sth0   sth0   L3*sphi0;
    0                  0     1];
Lk=[2*L1*cth0          0     0;
    0                  1     0;
    L0*sth0+h*cth0   -cth0  -2*L3*cphi0];
Lc=Lk;
Lq=[2*L1*cth0          0     0;
    -L0*sth0-h*cth0   cth0   2*L3*cphi0];

Kg1=zeros(3);Kg1(1,1)=-m1*g*L1*sth0;
Kg2=m2*g*[-L0*sth0-h*cth0   cth0   0;
          cth0               0     0;
           0                 0     0];
Kg3=m3*g*[-L0*sth0-h*cth0   cth0   0;
          cth0               0     0;
           0                 0     L3*cphi0];
Kel1=zeros(3);Kel1(1,1)=-k1*dL01*2*L1*sth0;   
Kel3=k3*dL03*[L0*cth0-h*sth0   sth0   0;
               sth0               0     0;
                0                 0     2*L3*sphi0];
            
M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+Kg1+Kg2+Kg3+Kel1+Kel3;

[modes eigenvalues]=eig(M\K);
freq=sqrt(diag(eigenvalues))/2/pi
modes

i=sqrt(-1);
vett_f=0:0.01:10;
F01=1; F02=0;
F0=[F01;F02];
Q0=Lq'*F0;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    x=x0(2);
    phi=x0(3);
    yD=(L0*cth0-h*sth0)*theta+sth0*x;
    mod1(k)=abs(yD);
    fas1(k)=angle(yD);
    mod2(k)=abs(phi);
    fas2(k)=angle(phi);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/N]');title('yD/F01')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[rad/N]');title('phi/F01')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')

F01=0; F02=1;
F0=[F01;F02];
Q0=Lq'*F0;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    x=x0(2);
    phi=x0(3);
    xD=(-L0*sth0-h*cth0)*theta+cth0*x;
    xG3=(-L0*sth0-h*cth0)*theta+cth0*x+L3*cphi0*phi;
    xddG1=L1*theta*ome^2*sth0;
    xddD=-xD*ome^2;
    xddG3=-xG3*ome^2;
    dL3=(L0*sth0+h*cth0)*theta-cth0*x-2*L3*cphi0*phi;
    Fel3=(k3+i*ome*c3)*dL3;
    HA=m1*xddG1+m2*xddD+m3*xddG3-F02-Fel3;
    mod1(k)=abs(HA);
    fas1(k)=angle(HA);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[N/N]');title('HA/F02')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

% .................................................

theta0=pi/4;
phi0=pi/4;
cth0=cos(theta0);
sth0=sin(theta0);
cphi0=cos(phi0);
sphi0=sin(phi0);

Fel03=m3*g/2*tan(phi0);
Fel02=-(m2+m3)*g*sth0+Fel03*cth0;
xD=L0*cth0-h*sth0;
xG3=xD+L3*sphi0;
yE=L0*sth0+h*cth0-2*L3*cphi0;
Fel01=(-m1*g*L1*cth0-m2*g*xD-m3*g*xG3-Fel03*yE)/(2*L1*cth0);

dL01=Fel01/k1
dL02=Fel02/k2
dL03=Fel03/k3
