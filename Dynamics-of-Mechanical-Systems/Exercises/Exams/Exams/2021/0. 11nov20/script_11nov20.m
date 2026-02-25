clear all
close all

m1=50;
m2=2;
J2=0.05;
L=0.2;
m3=15;
h=0.3;
b=0.15;
k2=6000;
c2=30;
k3=1e4;
c3=10;
g=9.81;
theta0=pi/12;
costh0=cos(theta0);
sinth0=sin(theta0);

mph=diag([m1 2*m2 2*m2 2*J2 m3 m3]);
cph=diag([c2 c3]);
kph=diag([k2 k3]);

% dL03=-(m1+2*m2+m3)*g/k3
% dL02=(m2*g+m3*g+k3*dL03)/k2*sqrt(4*L^2+h^2+4*L*h*sinth0)/h
dL03=-0.0677;
dL02=-0.1583;

num=2*L*h*costh0;
den=sqrt(4*L^2+h^2+4*L*h*sinth0);
der_dL2=num/den;
der2_dL2=(-2*L*h*sinth0*den-(2*L*h*costh0)^2/den)/den^2;

Lm=[1  0;
    0  -L*sinth0;
    1  -L*costh0;
    0   1;
    0  -2*L*sinth0;
    1  -2*L*costh0];
Lk=[0  der_dL2; 1  -2*L*costh0];
Lq=[1  0; 1  -2*L*costh0];
Lc=Lk;

KG2=zeros(2);KG2(2,2)=2*m2*g*L*sinth0;
KG3=zeros(2);KG3(2,2)=m3*g*2*L*sinth0;
Kel2=zeros(2);Kel2(2,2)=k2*dL02*der2_dL2;
Kel3=zeros(2);Kel3(2,2)=k3*dL03*2*L*sinth0;

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KG2+KG3+Kel2+Kel3;

[modes,eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi

% .............................................................
% FRF 1

i=sqrt(-1);
F=1;
z0=0;
Fel_z=0;
F0=[F;Fel_z];
Q0=Lq'*F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    y=x0(1);
    theta_d=x0(2);
    yg2=y-L*costh0*theta_d;
    mod1(k)=abs(yg2);
    fas1(k)=angle(yg2);
    mod2(k)=abs(theta_d);
    fas2(k)=angle(theta_d);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/N]');title('yg2/F0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[rad/N]');title('theta/F0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')


% .............................................................
% FRF 2

F=0;
z0=1;
HBst=-(m3*g+k3*dL03)*b/h;
VBst=-HBst*sinth0/costh0-m2*g/2;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    Fel_z=(k3+i*ome*c3)*z0;
    F0=[F;Fel_z];
    Q0=Lq'*F0;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    y=x0(1);
    theta_d=x0(2);
    xg2=-L*sinth0*theta_d;
    xg3=-2*L*sinth0*theta_d;
    yg2=y-L*costh0*theta_d;
    yg3=y-2*L*costh0*theta_d;
    dL3=(y-2*L*costh0*theta_d)-z0;
    Fz=-(k3+i*ome*c3)*dL3;
    Fel3=(k3+i*ome*c3)*dL3;
    xddg2=-ome^2*xg2;
    xddg3=-ome^2*xg3;
    yddg2=-ome^2*yg2;
    yddg3=-ome^2*yg3;
    thetadd=-ome^2*theta_d;
    HB=-(m3*yddg3+Fel3)*b/h+m3*xddg3/2;
    VB2=-(2*L*HB*sinth0+2*L*HBst*costh0*theta_d+m2*xddg2*L*sinth0+m2*yddg2*L*costh0-m2*g*L*sinth0*theta_d-J2*thetadd)/(2*L*costh0);
    VB3=-(2*L*HB*sinth0+m2*xddg2*L*sinth0+m2*yddg2*L*costh0-J2*thetadd)/(2*L*costh0);
    mod1(k)=abs(xg2);
    fas1(k)=angle(xg2);
    mod2(k)=abs(Fz);
    fas2(k)=angle(Fz);
    mod3(k)=abs(HB);
    fas3(k)=angle(HB);
    mod4(k)=abs(VB2);
    fas4(k)=angle(VB2);
    mod5(k)=abs(VB3);
    fas5(k)=angle(VB3);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/m]');title('xG2/z0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/m]');title('Fz/z0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/m]');title('HB/z0')
subplot 212;plot(vett_f,fas3);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod4);grid;xlabel('[Hz]');ylabel('[N/m]');title('VB2/z0')
subplot 212;plot(vett_f,fas4);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod5);grid;xlabel('[Hz]');ylabel('[N/m]');title('VB3/z0')
subplot 212;plot(vett_f,fas5);grid;xlabel('[Hz]');ylabel('[rad]')


