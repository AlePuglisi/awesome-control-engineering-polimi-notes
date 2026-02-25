clear all
close all

m1=6;
m2=1;
m3=4;
J1=0.08;
J2=0.02;
J3=0.06;
L1=0.2;
L3=0.2;
R=0.1;
theta0=pi/6;
k1=5000;
k2=9000;
k3=13000;
k4=2000;
c1=2;
c2=10;
c3=10;
c4=0.5;
sinth0=sin(theta0);
costh0=cos(theta0);
beta=pi/3;
g=9.81;
freq_fsmin=2.5;
dt=0.001;
F0_fsmin=10;


% dL01=-m1*g/2/k1
% dL04=-m3*g/2/k4
% dL02=-0.005;
% Fel03=k2*dL02-m1*g/2+m2*g+m3*g/2;
% dL03=Fel03/k3

dL01=-0.0059;
dL02=-0.005;
dL03=-0.0035;
dL04=-0.0098;

mph=diag([m1 m1 J1 m2 m2 J2 m3 m3 J3]);
cph=diag([c1 c2 c3 c4]);
kph=diag([k1 k2 k3 k4]);

Lm=[0    -2*R+R*sinth0   0;
    -L1  -R*costh0       0;
    1        0           0;
    0    -2*R-R*sinth0   0;
    0     R*costh0       0;
    0        1           0;
    0    -2*R-R*sinth0   0;
    0     R*costh0       L3;
    0        0           1];
Lk=[-2*L1  -R*costh0       0;
      0     R*costh0       0;
      0    -R*costh0       0;
      0     R*costh0       2*L3];
Lc=Lk;
Lq=[0    -R*costh0       0;
    0     R*costh0       0;
    0    -2*R-R*sinth0   0;
    0     R*costh0       2*L3];

Kel1=k1*dL01*[0 0 0;0  R*sinth0 0;0 0 0];
Kel2=k2*dL02*[0 0 0;0 -R*sinth0 0;0 0 0];
Kel3=k3*dL03*[0 0 0;0  R*sinth0 0;0 0 0];
Kel4=k4*dL04*[0 0 0;0 -R*sinth0 0;0 0 0];

Kg1=m1*g*[0 0 0;0  R*sinth0 0;0 0 0];
Kg2=m2*g*[0 0 0;0 -R*sinth0 0;0 0 0];
Kg3=m3*g*[0 0 0;0 -R*sinth0 0;0 0 0];

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+Kel1+Kel2+Kel3+Kel4+Kg1+Kg2+Kg3;

[modes eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi

%............................................
% FRF 1 

i=sqrt(-1);
vett_f=0:0.01:10;
F0=1;
F=[0;0;F0*cos(beta);F0*sin(beta)];
Q0=Lq'*F;
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*M+i*ome*C+K;
   x0=A\Q0;
   phi=x0(1);
   theta_d=x0(2);
   psi=x0(3);
   yg1=-L1*phi-R*costh0*theta_d;
   mod1(k)=abs(psi);
   phase1(k)=angle(psi);
   mod2(k)=abs(yg1);
   phase2(k)=angle(yg1);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[rad/N]');title('psi/F0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/N]');title('yg1/F0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')

%............................................
% FRF 2 

y0=1;
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*M+i*ome*C+K;
   Fel_y2=(i*ome*c2+k2)*y0;
   Fel_y3=(i*ome*c3+k3)*y0;
   F=[Fel_y2;Fel_y3;0;0];
   Q0=Lq'*F;
   x0=A\Q0;
   phi=x0(1);
   theta_d=x0(2);
   psi=x0(3);
   dL4=R*costh0*theta_d+2*L3*psi;
   Fel4=(k4+i*ome*c4)*dL4;
   mod1(k)=abs(theta_d);
   phase1(k)=angle(theta_d);
   mod2(k)=abs(Fel4);
   phase2(k)=angle(Fel4);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[rad/m]');title('theta/y0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/m]');title('Fel4/y0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')

%............................................
% FRF 3 

F0=1;
F=[0;0;F0*cos(beta);F0*sin(beta)];
Q0=Lq'*F;
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*M+i*ome*C+K;
   x0=A\Q0;
   phi=x0(1);
   theta_d=x0(2);
   psi=x0(3);
   xg1=(-2*R+R*sinth0)*theta_d;
   xg2=(-2*R-R*sinth0)*theta_d;
   xg3=(-2*R-R*sinth0)*theta_d;
   yg1=-L1*phi-R*costh0*theta_d;
   yg2=R*costh0*theta_d;
   yg3=R*costh0*theta_d+L3*psi;
   xg1dd=-ome^2*xg1;
   xg2dd=-ome^2*xg2;
   xg3dd=-ome^2*xg3;
   yg1dd=-ome^2*yg1;
   yg2dd=-ome^2*yg2;
   yg3dd=-ome^2*yg3;
   dL1=-2*L1*phi-R*costh0*theta_d;
   dL2=R*costh0*theta_d;
   dL3=-R*costh0*theta_d;
   dL4=R*costh0*theta_d+2*L3*psi;
   Fel1=(k1+i*ome*c1)*dL1;
   Fel2=(k2+i*ome*c2)*dL2;
   Fel3=(k3+i*ome*c3)*dL3;
   Fel4=(k4+i*ome*c4)*dL4;
   T=m1*xg1dd+m2*xg2dd+m3*xg3dd-F0*cos(beta);
   Nd=Fel1-Fel2-Fel3+Fel4+m1*yg1dd+m2*yg2dd+m3*yg3dd-F0*sin(beta);
   mod1(k)=abs(T);
   phase1(k)=angle(T);
   mod2(k)=abs(Nd);
   phase2(k)=angle(Nd);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[N/N]');title('T/F0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/N]');title('Nd/F0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')

%............................................
% Question 7

T_mod=interp1(vett_f,mod1*F0_fsmin,freq_fsmin);
T_phas=interp1(vett_f,phase1,freq_fsmin);
N_mod=interp1(vett_f,mod2*F0_fsmin,freq_fsmin);
N_phas=interp1(vett_f,phase2,freq_fsmin);
T_fsmin=3/freq_fsmin;
vett_t=0:dt:T_fsmin;
vett_T=T_mod*cos(2*pi*freq_fsmin*vett_t+T_phas);
vett_N=N_mod*cos(2*pi*freq_fsmin*vett_t+N_phas);
Nst=(m1+m2+m3)*g+k1*dL01-k2*dL02-k3*dL03+k4*dL04;
vett_Ntot=vett_N+Nst;
vett_fs=abs(vett_T)./vett_Ntot;

figure;plot(vett_t,vett_T);grid;title('T')
figure;plot(vett_t,vett_N);grid;title('Nd')
figure;plot(vett_t,vett_Ntot);grid;title('Ntot')
figure;plot(vett_t,vett_fs);grid;title('fs')

fs_min=max(vett_fs)

%............................................
%% Question 8




k2=4500;
Fel03=k2*dL02-m1*g/2+m2*g+m3*g/2;
dL03=Fel03/k3


