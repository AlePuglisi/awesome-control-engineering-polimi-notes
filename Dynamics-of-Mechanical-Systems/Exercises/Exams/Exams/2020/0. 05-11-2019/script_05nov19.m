clear all
close all

m1=1;
m2=5;
m3=1;
J1=0.005;
J2=0.1;
J3=0.005;
L=0.25;
L1=0.1;
L2=0.1;
theta0=pi/6;
k1=1000;
k2=1000;
k3=1000;
k4=1000;
c1=2;
c2=0.5;
c3=0.5;
c4=2;
sinth0=sin(theta0);
costh0=cos(theta0);
g=9.81;
y01=0.05;
ome1=20;
phi01=pi/6;
F02=100;
ome2=15;
phi02=-pi/3;


% dL01=-0.02;
% Fel04=(m2*g*(L-L1)*sinth0+m3*g*(2*L-L1-L2)*sinth0)/((2*L-L1)*costh0);
% Fel03=k1*dL01+m2*g*costh0+Fel04*sinth0;
% Fel02=Fel03+m3*g*costh0;
% dL02=Fel02/k2
% dL03=Fel03/k3
% dL04=Fel04/k4

dL01=-0.02;
dL02=0.0407;
dL03=0.0322;
dL04=0.0194;

mph=diag([J1+J2+J3 m2 m2 m3 m3]);
cph=diag([c1 c2 c3 c4]);
kph=diag([k1 k2 k3 k4]);

Lm=[1 0 0;(L-L1)*costh0 -sinth0 0;(L-L1)*sinth0 costh0 0;(2*L-L1-L2)*costh0 -sinth0 -sinth0;(2*L-L1-L2)*sinth0 costh0 costh0];
Lk=[0 1 0;0 -1 -1;0 0 1;-(2*L-L1)*costh0  sinth0 0];
Lc=Lk;
Lq=[(2*L-L1-L2)*costh0 -sinth0 -sinth0; (2*L-L1)*costh0 -sinth0 0];

Kel4=k4*dL04*[(2*L-L1)*sinth0 costh0 0;costh0 0 0;0 0 0];
Kg2=m2*g*[(L-L1)*costh0 -sinth0 0; -sinth0 0 0;0 0 0];
Kg3=m3*g*[(2*L-L1-L2)*costh0 -sinth0 -sinth0; -sinth0 0 0;-sinth0 0 0];
M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+Kel4+Kg2+Kg3;

[modes eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi

%............................................
% FRF 1 

i=sqrt(-1);
vett_f=0:0.01:10;
F=[1;0];
Q0=Lq'*F;
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*M+i*ome*C+K;
   x0=A\Q0;
   theta_d=x0(1);
   csi=x0(2);
   eta=x0(3);
   mod1(k)=abs(theta_d);
   phase1(k)=angle(theta_d);
   mod2(k)=abs(eta);
   phase2(k)=angle(eta);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[rad/N]');title('theta/F0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/N]');title('eta/F0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')

%............................................
% FRF 2 

y0=1;
F=[0;1];
Q0=Lq'*F;
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*M+i*ome*C+K;
   Fel_y=(i*ome*c4+k4)*y0;
   x0=A\Q0*Fel_y;
   theta_d=x0(1);
   csi=x0(2);
   eta=x0(3);
   yg=(L-L1)*sinth0*theta_d+costh0*csi;
   dL4=-(2*L-L1)*costh0*theta_d+sinth0*csi+y0;
   Fel4=(i*ome*c4+k4)*dL4;
   mod1(k)=abs(yg);
   phase1(k)=angle(yg);
   mod2(k)=abs(Fel4);
   phase2(k)=angle(Fel4);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/m]');title('yG2/y0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/m]');title('Fel4/y0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')

%%
T1=2*pi/ome1;
T2=2*pi/ome2;
T=max([T1 T2]);
dt=0.001;
vett_t=0:dt:5*T;

y0=y01*exp(i*phi01);
Fel_y=(i*ome*c4+k4)*y0;
F=[0;Fel_y];
Q0=Lq'*F;
ome=ome1;
A=-ome^2*M+i*ome*C+K;
x0=A\Q0;
theta_d=x0(1);
csi=x0(2);
eta=x0(3);
xg2=(L-L1)*costh0*theta_d-sinth0*csi;
xg3=(2*L-L1-L2)*costh0*theta_d-sinth0*csi-sinth0*eta;
yg2=(L-L1)*sinth0*theta_d+costh0*csi;
yg3=(2*L-L1-L2)*sinth0*theta_d+costh0*csi+costh0*eta;
thetapp=-ome^2*theta_d;
xg2pp=-ome^2*xg2;
xg3pp=-ome^2*xg3;
yg2pp=-ome^2*yg2;
yg3pp=-ome^2*yg3;
dL4=-(2*L-L1)*costh0*theta_d+sinth0*csi+y0;
Fel4=(i*ome*c4+k4)*dL4;
Fel04=k4*dL04;
Nout=(Fel4-m3*xg3pp-m2*xg2pp)*costh0-(m3*yg3pp+m2*yg2pp)*sinth0-(Fel04*sinth0+m3*g*costh0+m2*g*costh0)*theta_d;
Mout=J1*thetapp;
vett_N=abs(Nout)*cos(ome*vett_t+angle(Nout));
vett_M=abs(Mout)*cos(ome*vett_t+angle(Mout));

y0=0;
F0=F02*exp(i*phi02);
F=[F0;0];
Q0=Lq'*F;
ome=ome2;
A=-ome^2*M+i*ome*C+K;
x0=A\Q0;
theta_d=x0(1);
csi=x0(2);
eta=x0(3);
xg2=(L-L1)*costh0*theta_d-sinth0*csi;
xg3=(2*L-L1-L2)*costh0*theta_d-sinth0*csi-sinth0*eta;
yg2=(L-L1)*sinth0*theta_d+costh0*csi;
yg3=(2*L-L1-L2)*sinth0*theta_d+costh0*csi+costh0*eta;
thetapp=-ome^2*theta_d;
xg2pp=-ome^2*xg2;
xg3pp=-ome^2*xg3;
yg2pp=-ome^2*yg2;
yg3pp=-ome^2*yg3;
dL4=-(2*L-L1)*costh0*theta_d+sinth0*csi+y0;
Fel4=(i*ome*c4+k4)*dL4;
Fel04=k4*dL04;
Nout=(Fel4+F0-m3*xg3pp-m2*xg2pp)*costh0-(m3*yg3pp+m2*yg2pp)*sinth0-(Fel04*sinth0+m3*g*costh0+m2*g*costh0)*theta_d;
Mout=J1*thetapp;
vett_N=vett_N+abs(Nout)*cos(ome*vett_t+angle(Nout));
vett_M=vett_M+abs(Mout)*cos(ome*vett_t+angle(Mout));

figure;plot(vett_t,vett_N);grid;title('N')
figure;plot(vett_t,vett_M);grid;title('M')



