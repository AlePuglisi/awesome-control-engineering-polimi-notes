clear all
close all

m1=6;
m2=10;
J1=0.08;
J2=0.3;
L1=0.2;
L2=0.3;
theta0=pi/3;
phi0=pi/6;
k1=5000;
k2=5000;
k3=5000;
c1=2;
c2=2;
c3=2;
sinth0=sin(theta0);
costh0=cos(theta0);
sinphi0=sin(phi0);
cosphi0=cos(phi0);
beta=pi/4;
g=9.81;
F01=100;
phi01=pi/3;
ome01=10*pi;
y02=0.02;
phi02=pi/6;
ome02=14*pi;
T=2; dt=0.001;


% dL01=0.02; Fel01=dL01*k1;
% mtx=[0 1 0 1;-1 0 1 0;0 0 L1*costh0 L1*sinth0; 2*L2*cosphi0 -2*L2*sinphi0 0 0];
% vett_b=[Fel01;(m1+m2)*g;-Fel01*L1*sinth0;-m2*g*L2*cosphi0];
% vett_x=mtx\vett_b;
% dL02=vett_x(1)/k2
% dL03=vett_x(2)/k3
 
dL01=0.02;
dL02=0.0356;
dL03=0.0787;

mph=diag([m1 m1 J1 m2 m2 J2]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[L1*sinth0       0        1;
    L1*costh0       0        0;
       1            0        0;
    L1*sinth0  -L2*sinphi0   1;
    L1*costh0  -L2*cosphi0   0;
       0            1        0];
Lk=[2*L1*sinth0         0        1;
      L1*costh0  -2*L2*cosphi0   0;
     -L1*sinth0   2*L2*sinphi0  -1];
Lc=Lk;
Lq=[L1*sinth0       0        1;
    L1*costh0       0        0];

Kel1=k1*dL01*[2*L1*costh0 0 0;0 0 0;0 0 0];
Kel2=k2*dL02*[-L1*sinth0  0 0;0 2*L2*sinphi0 0;0 0 0];
Kel3=k3*dL03*[-L1*costh0  0 0;0 2*L2*cosphi0 0;0 0 0];

Kg1=m1*g*[-L1*sinth0 0 0;0 0 0;0 0 0];
Kg2=m2*g*[-L1*sinth0 0 0;0 L2*sinphi0 0;0 0 0];

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+Kel1+Kel2+Kel3+Kg1+Kg2;

MFF=M(1:2,1:2);
CFF=C(1:2,1:2);
KFF=K(1:2,1:2);

MFC=M(1:2,3);
CFC=C(1:2,3);
KFC=K(1:2,3);

MCF=M(3,1:2);
CCF=C(3,1:2);
KCF=K(3,1:2);

MCC=M(3,3);
CCC=C(3,3);
KCC=K(3,3);

[modes eigenvalues]=eig(MFF\KFF);
modes
freq=sqrt(diag(eigenvalues))/2/pi

%............................................
% FRF 1 

i=sqrt(-1);
vett_f=0:0.01:10;
F0=1;
F=[-F0*cos(beta);F0*sin(beta)];
Q0=Lq'*F; Q0F=Q0(1:2);
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*MFF+i*ome*CFF+KFF;
   x0=A\Q0F;
   theta_d=x0(1);
   phi_d=x0(2);
   xg1=L1*sinth0*theta_d;
   yg2=L1*costh0*theta_d-L2*cosphi0*phi_d;
   mod1(k)=abs(xg1);
   phase1(k)=angle(xg1);
   mod2(k)=abs(yg2);
   phase2(k)=angle(yg2);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/N]');title('xg1/F0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/N]');title('yg2/F0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')

%............................................
% FRF 2 

y0=1;
F0=0;
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*MFF+i*ome*CFF+KFF;
   Q0FC=-(-ome^2*MFC+i*ome*CFC+KFC)*y0;
   x0=A\Q0FC;
   theta_d=x0(1);
   phi_d=x0(2);
   Fy=(-ome^2*MCF+i*ome*CCF+KCF)*x0+(-ome^2*MCC+i*ome*CCC+KCC)*y0;
   dL1=2*L1*sinth0*theta_d+y0;
   dL2=L1*costh0*theta_d-2*L2*cosphi0*phi_d;
   dL3=-L1*sinth0*theta_d+2*L2*sinphi0*phi_d-y0;
   Fel1=(k1+i*ome*c1)*dL1;
   Fel2=(k2+i*ome*c2)*dL2;
   Fel3=(k3+i*ome*c3)*dL3;
   xg1=L1*sinth0*theta_d+y0;
   xg2=L1*sinth0*theta_d-L2*sinphi0*phi_d+y0;
   yg1=L1*costh0*theta_d;
   yg2=L1*costh0*theta_d-L2*cosphi0*phi_d;
   xg1dd=-ome^2*xg1;
   xg2dd=-ome^2*xg2;
   yg1dd=-ome^2*yg1;
   yg2dd=-ome^2*yg2;
   NA=m1*yg1dd+m2*yg2dd+Fel2-F0*sin(beta);
   NB=m1*xg1dd+m2*xg2dd-Fel3+Fel1+F0*cos(beta);
   mod1(k)=abs(Fel3);
   phase1(k)=angle(Fel3);
   mod2(k)=abs(NA);
   phase2(k)=angle(NA);
   mod3(k)=abs(Fy);
   phase3(k)=angle(Fy);
   mod4(k)=abs(NB);
   phase4(k)=angle(NB);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[N/m]');title('Fel3/y0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/m]');title('NA/y0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod3,vett_f,mod4);grid;xlabel('[Hz]');ylabel('[N/m]');title('NB/y0')
subplot 212;plot(vett_f,phase3);grid;xlabel('[Hz]');ylabel('[rad]')


%............................................
% Question 7


vett_t=0:dt:T;
F0=F01*exp(i*phi01);
F=[-F0*cos(beta);F0*sin(beta)];
Q0=Lq'*F; Q0F=Q0(1:2);
ome=ome01;
A=-ome^2*MFF+i*ome*CFF+KFF;
x0=A\Q0F;
theta_d=x0(1);
phi_d=x0(2);
dL2=L1*costh0*theta_d-2*L2*cosphi0*phi_d;
Fel2=(k2+i*ome*c2)*dL2;
yg1=L1*costh0*theta_d;
yg2=L1*costh0*theta_d-L2*cosphi0*phi_d;
yg1dd=-ome^2*yg1;
yg2dd=-ome^2*yg2;
NA=m1*yg1dd+m2*yg2dd+Fel2-F0*sin(beta);
vett_NA=abs(NA)*cos(ome*vett_t+angle(NA));

F0=0;
y0=y02*exp(i*phi02);
ome=ome02;
A=-ome^2*MFF+i*ome*CFF+KFF;
Q0FC=-(-ome^2*MFC+i*ome*CFC+KFC)*y0;
x0=A\Q0FC;
theta_d=x0(1);
phi_d=x0(2);
dL2=L1*costh0*theta_d-2*L2*cosphi0*phi_d;
Fel2=(k2+i*ome*c2)*dL2;
yg1=L1*costh0*theta_d;
yg2=L1*costh0*theta_d-L2*cosphi0*phi_d;
yg1dd=-ome^2*yg1;
yg2dd=-ome^2*yg2;
NA=m1*yg1dd+m2*yg2dd+Fel2-F0*sin(beta);
vett_NA=vett_NA+abs(NA)*cos(ome*vett_t+angle(NA));

figure;plot(vett_t,vett_NA);grid;title('Na')

%............................................
% Question 8

theta0=pi/4;
phi0=pi/3;
sinth0=sin(theta0);
costh0=cos(theta0);
sinphi0=sin(phi0);
cosphi0=cos(phi0);

dL01=0.02; Fel01=dL01*k1;
mtx=[0 1 0 1;-1 0 1 0;0 0 L1*costh0 L1*sinth0; 2*L2*cosphi0 -2*L2*sinphi0 0 0];
vett_b=[Fel01;(m1+m2)*g;-Fel01*L1*sinth0;-m2*g*L2*cosphi0];
vett_x=mtx\vett_b;
dL02=vett_x(1)/k2
dL03=vett_x(2)/k3
