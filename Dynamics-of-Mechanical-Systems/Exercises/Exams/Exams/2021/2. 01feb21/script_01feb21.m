clear all
close all

m1=10;
m2=5;
m3=2.5;
m4=5;
J2=0.4;
J3=0.05;
J4=0.05;
L=0.5;
R=0.15;
k1=3000;
k2=3000;
k3=3000;
c1=3;
c2=3;
c3=3;
g=9.81;
theta0=pi/3;
phi0_rel=pi/3;
x01=0.04;
omega1=10;
phi01=-pi/3;
y02=0.025;
omega2=30;
phi02=pi/3;
T=2;
dt=0.001;

phi0=phi0_rel-(pi/2-theta0);
costh0=cos(theta0);
sinth0=sin(theta0);
cosphi0=cos(phi0);
sinphi0=sin(phi0);



mph=diag([m1 m2 m2 J2 m3 m3 J3 m4 J4]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Fel02=m3*g;
Fel01=-(m2*g*sinth0+m3*g*(sinth0-0.5*cosphi0)-Fel02*(sinth0-cosphi0))/(2*sinth0);
% dL01=Fel01/k1
% dL02=Fel02/k2
dL01=-0.0098;
dL02=0.0082;
dL03=0;


Lm=[     1                 0             0;
         1               L*costh0        0;
         0              -L*sinth0        0;
         0                 1              0;
         1               L*costh0      -0.5*L*sinphi0;
         0              -L*sinth0       0.5*L*cosphi0;
         0                 0              1;
         1             2*L*costh0         0;
        -1/R          -2*L/R*costh0       0];
Lk=[0    -2*L*sinth0        0;
    0       L*sinth0       -L*cosphi0;
   -1    -2*L*costh0        0];
Lq=[-1/R    -2*L/R*costh0       0;
    0        -L*sinth0       L*cosphi0];
Lc=Lk;

KG2=zeros(3);KG2(2,2)=m2*g*(-L*costh0);
KG3=zeros(3);KG3(2,2)=m3*g*(-L*costh0);KG3(3,3)=m3*g*(-0.5*L*sinphi0);
Kel1=zeros(3);Kel1(2,2)=-k1*dL01*2*L*costh0;
Kel2=zeros(3);Kel2(2,2)=k2*dL02*L*costh0;Kel2(3,3)=k2*dL02*L*sinphi0;
Kel3=zeros(3);

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KG2+KG3+Kel1+Kel2+Kel3;

[modes,eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi


% .............................................................
% FRF 1

i=sqrt(-1);
C0=1;
y0=0; Fel_y=0;
F0=[C0;Fel_y];
Q0=Lq'*F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    x=x0(1);
    theta_d=x0(2);
    phi_d=x0(3);
    ya=-2*L*sinth0*theta_d;
    rel_ang=phi_d-theta_d;
    mod1(k)=abs(ya);
    fas1(k)=angle(ya);
    mod2(k)=abs(rel_ang);
    fas2(k)=angle(rel_ang);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('ya/C0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[rad/Nm]');title('abs. phi-theta/C0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')


% .............................................................
% FRF 2

C0=0;
y0=1; 
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    Fel_y=(k2+i*ome*c2)*y0;
    F0=[C0;Fel_y];
    Q0=Lq'*F0;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    x=x0(1);
    theta_d=x0(2);
    phi_d=x0(3);
    psi=-x/R-2*L/R*costh0*theta_d;
    xg3= x+L*costh0*theta_d-0.5*L*sinphi0*phi_d;
    mod1(k)=abs(psi);
    fas1(k)=angle(psi);
    mod2(k)=abs(xg3);
    fas2(k)=angle(xg3);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[rad/m]');title('psi/y0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/m]');title('m/y0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')

% .....................................................................
% time history

% 1) matrices partition

MFF=M(2:3,2:3);
CFF=C(2:3,2:3);
KFF=K(2:3,2:3);

MFC=M(2:3,1);
CFC=C(2:3,1);
KFC=K(2:3,1);

vett_t=0:dt:T;

% 2) x(t)

y0=0; Fel_y=0;
ome=omega1;
x0C=x01*exp(i*phi01);
Q0FC=-(-ome^2*MFC+i*ome*CFC+KFC)*x0C;
A=-ome^2*MFF+i*ome*CFF+KFF;
x0=A\Q0FC;
theta_d=x0(1);
phi_d=x0(2);
dL1=-2*L*sinth0*theta_d;
dL2=L*sinth0*theta_d-L*cosphi0*phi_d;
yg2=-L*sinth0*theta_d;
yg3=-L*sinth0*theta_d+0.5*L*cosphi0*phi_d;
yg2dd=-ome^2*yg2;
yg3dd=-ome^2*yg3;
psidd=-ome^2*phi_d;
Fel1=(k1+i*ome*c1)*dL1;
Fel2=(k2+i*ome*c2)*dL2;
Nst=(m2+m3+m4)*g+k1*dL01-k2*dL02;
Ndyn=m2*yg2dd+m3*yg3dd-Fel2-Fel_y+Fel1;
Tdyn=J4*psidd/R;
vett_N=Nst+abs(Ndyn)*cos(ome*vett_t+angle(Ndyn));
vett_T=abs(Tdyn)*cos(ome*vett_t+angle(Tdyn));

% 3) y(t)

C0=0;
ome=omega2;
y0=y02*exp(i*phi02); Fel_y=(k2+i*ome*c2)*y0;
F0=[C0;Fel_y];
Q0=Lq(:,2:3)'*F0;
A=-ome^2*MFF+i*ome*CFF+KFF;
x0=A\Q0;
theta_d=x0(1);
phi_d=x0(2);
dL1=-2*L*sinth0*theta_d;
dL2=L*sinth0*theta_d-L*cosphi0*phi_d;
yg2=-L*sinth0*theta_d;
yg3=-L*sinth0*theta_d+0.5*L*cosphi0*phi_d;
yg2dd=-ome^2*yg2;
yg3dd=-ome^2*yg3;
psidd=-ome^2*phi_d;
Fel1=(k1+i*ome*c1)*dL1;
Fel2=(k2+i*ome*c2)*dL2;
Ndyn=m2*yg2dd+m3*yg3dd-Fel2-Fel_y+Fel1;
Tdyn=J4*psidd/R;
vett_N=vett_N+abs(Ndyn)*cos(ome*vett_t+angle(Ndyn));
vett_T=vett_T+abs(Tdyn)*cos(ome*vett_t+angle(Tdyn));

figure;plot(vett_t,vett_N);grid;xlabel('[t]');ylabel('[N]');title('N')
figure;plot(vett_t,vett_T);grid;xlabel('[t]');ylabel('[N]');title('T')


