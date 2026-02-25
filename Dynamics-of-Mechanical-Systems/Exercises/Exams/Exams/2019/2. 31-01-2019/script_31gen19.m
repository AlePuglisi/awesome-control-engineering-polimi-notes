clear all
close all

m1=5;
m2=5;
J1=0.1;
J2=0.01;
L=0.20;
L0=0.3;
R=0.05;
k1=8000;
k2=4000;
c1=2;
c2=1;
theta0=pi/4;
F01=200;
omega1=6*pi;
phi1=pi/3;
y02=0.05;
omega2=12*pi;
phi2=-pi/3;

sth0=sin(theta0);
cth0=cos(theta0);
g=9.81;

% NB=(2*m1*g*L*sth0+m2*g*R*cth0+m2*g*(2*L-L0)*sth0)/(4*L*cth0);
% Fel01=(2*L*NB*cth0+m1*g*L*sth0+m2*g*(L0*sth0-R*cth0))/(2*L*sth0);
% dL01=Fel01/k1
% dL02=-m2*g/k2*cth0

dL01=0.0111;
dL02=-0.0087;

mph=diag([m1 2*J1 m1 m1 m2 m2 J2]);
cph=diag([c1 c2]);
kph=diag([k1 k2]);

Lm=[L                            0;
    1                            0;
    -L*cth0                      0;
    -3*L*sth0                    0;
    (-2*L+L0)*cth0+R*sth0      sth0;
   -(2*L+L0)*sth0+R*cth0       cth0;
    -1      -1/R];
Lk=[4*L*sth0   0;
    0          1];
Lc=Lk;
Lq=[-(2*L+L0)*sth0+R*cth0       cth0;
    -4*L*sth0                    0];

KII_el2=k1*dL01*[4*L*cth0 0;0 0];
KG1a=m1*g*[-L*cth0 0;0 0];
KG1b=m1*g*[-3*L*cth0 0;0 0];
KG2=m2*g*[-(2*L+L0)*cth0-R*sth0   -sth0;-sth0   0];

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KII_el2+KG1a+KG1b+KG2;

%..................................

[modes eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi

%..................................
% FRF 1

vett_f=0:0.01:10;
i=sqrt(-1);
F0=1;
F=[F0;0];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    x=x0(2);
    phi=-theta-x/R;
    mod1(k)=abs(theta);
    phase1(k)=angle(theta);
    mod2(k)=abs(phi);
    phase2(k)=angle(phi);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[rad/N]');title('theta/F0')
subplot 212;plot(vett_f,phase1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[rad/N]');title('phi/F0')
subplot 212;plot(vett_f,phase2*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

%..................................
% FRF 2

F0=0;
y0=1;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    F=[F0;(k1+i*ome*c1)*y0];
    Q0=Lq'*F;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    x=x0(2);
    xc=((-2*L+L0)*cth0+R*sth0)*theta+sth0*x;
    dL1=y0+4*L*sth0*theta;
    Fel1=(k1+i*ome*c1)*dL1;
    mod1(k)=abs(xc);
    phase1(k)=angle(xc);
    mod2(k)=abs(Fel1);
    phase2(k)=angle(Fel1);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/m]');title('xc/y0')
subplot 212;plot(vett_f,phase1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/m]');title('Fel1/y0')
subplot 212;plot(vett_f,phase2*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')


%.........................................................................
% time history

vett_t=0:0.001:1;

for j=1:2
    if j==1
        y0=0;
        F0=F01*exp(i*phi1);
        F=[F0;0];
        Q0=Lq'*F;
        ome=omega1;
    else
        F0=0;
        y0=y02*exp(i*phi2);
        ome=omega2;
        F=[F0;(k1+i*ome*c1)*y0];
        Q0=Lq'*F;
    end
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    x=x0(2);
    yg1=-L*sth0*theta;
    yg2=-3*L*sth0*theta;
    yc=(-(2*L+L0)*sth0+R*cth0)*theta+cth0*x;
    yg1dd=-ome^2*yg1;
    yg2dd=-ome^2*yg2;
    ycdd=-ome^2*yc;
    dL1=y0+4*L*sth0*theta;
    Fel1=(k1+i*ome*c1)*dL1;

    V=m1*yg1dd+m1*yg2dd-Fel1+m2*ycdd-F0;

    if j==1
        vett_V=abs(V)*cos(ome*vett_t+angle(V));
    else
        vett_V=vett_V+abs(V)*cos(ome*vett_t+angle(V));
    end
end
  
figure;plot(vett_t,vett_V);grid;title('V')

% ....................................................................

theta0=pi/6;
sth0=sin(theta0);
cth0=cos(theta0);

NB=(2*m1*g*L*sth0+m2*g*R*cth0+m2*g*(2*L-L0)*sth0)/(4*L*cth0);
Fel01=(2*L*NB*cth0+m1*g*L*sth0+m2*g*(L0*sth0-R*cth0))/(2*L*sth0);
dL01=Fel01/k1
dL02=-m2*g/k2*cth0


