clear all
close all

m1=10;
m2=4;
J1=1.5;
J2=0.1;
R1=1.0;
R2=0.2;
d=0.5;
s0=0.75;
theta0=pi/6;
k1=10e3;
k2=10e3;
k3=5e3;
c1=4;
c2=4;
c3=2;
sinth0=sin(theta0);
costh0=cos(theta0);
g=9.81;
fs=0.3;

% dL02=-0.002; Fel02=dL02*k2;
% dL01=(Fel02*R1*costh0+m2*g*(R1-s0)*costh0-m2*g*R2*sinth0)/(k1*R1*costh0)
% dL03=m2*g*sinth0/k3

dL01=-0.0015;
dL02=-0.002;
dL03=0.0039;

mph=diag([m1 m1 J1 m2 m2 J2]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

dxg2_dth=R1+(R1-s0)*sinth0+R2*costh0;
dyg2_dth=(R1-s0)*costh0-R2*sinth0;

Lm=[R1-d*costh0    0;
    d*sinth0       0;
       1              0;
    dxg2_dth         -R2*costh0;
    dyg2_dth          R2*sinth0;
       -1              1   ];
Lk=[-R1*costh0      0;
     R1*costh0      0;
     0             -R2];
Lc=Lk;
Lq=[-1             1;
    -R1*costh0    0];

Kel1=k1*dL01*[R1*sinth0   0;0 0];
Kel2=k2*dL02*[-R1*sinth0  0;0 0];

Kg1=m1*g*[d*costh0 0; 0 0];
Kg2=m2*g*[-(R1-s0)*sinth0-R2*costh0 R2*costh0;R2*costh0 0];

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+Kel1+Kel2+Kg1+Kg2;

[modes eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi

%............................................
% FRF 1 

i=sqrt(-1);
vett_f=0:0.01:10;
C0=1; 
F=[C0;0];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta_d=x0(1);
    phi=x0(2);
    xg2=dxg2_dth*theta_d-R2*costh0*phi;
    mod1(k)=abs(xg2);
    phase1(k)=angle(xg2);
    mod2(k)=abs(theta_d);
    phase2(k)=angle(theta_d);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('xg2/C0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[rad/Nm]');title('theta/C0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')

%............................................
% FRF 2, 3 

C0=0; y0=1;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    F=[C0;y0*(k2+i*ome*c2)];
    Q0=Lq'*F;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta_d=x0(1);
    phi=x0(2);
    dL1=-R1*costh0*theta_d;
    dL2=(y0+R1*costh0*theta_d);
    Fel1=(k1+i*ome*c1)*dL1;
    Fel2=(k2+i*ome*c2)*dL2;
    xg1=(R1-d*costh0)*theta_d;
    yg1=d*sinth0*theta_d;
    xg2=dxg2_dth*theta_d-R2*costh0*phi;
    yg2=dyg2_dth*theta_d+R2*sinth0*phi;
    xddg1=-xg1*ome^2;
    yddg1=-yg1*ome^2;
    xddg2=-xg2*ome^2;
    yddg2=-yg2*ome^2;
    Nd=m1*yddg1+m2*yddg2-Fel1-Fel2;
    Td=m1*xddg1+m2*xddg2;
    mod1(k)=abs(Fel1);
    phase1(k)=angle(Fel1);
    mod2(k)=abs(xg1);
    phase2(k)=angle(xg1);
    mod3(k)=abs(Nd);
    phase3(k)=angle(Nd);
    mod4(k)=abs(Td);
    phase4(k)=angle(Td);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[N/m]');title('Fel1/y0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/m]');title('xg1/y0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/m]');title('Nd/y0')
subplot 212;plot(vett_f,phase3);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod4);grid;xlabel('[Hz]');ylabel('[N/m]');title('Td/y0')
subplot 212;plot(vett_f,phase4);grid;xlabel('[Hz]');ylabel('[rad]')

% ..................................................
% question 6

Nd=mod3.*exp(i*phase3);
Td=mod4.*exp(i*phase4);
rapp=Td./Nd;
figure
subplot 211;plot(vett_f,abs(rapp));grid;xlabel('[Hz]');ylabel('[1/m]');title('(Td/Nd)/y0')
subplot 212;plot(vett_f,angle(rapp));grid;xlabel('[Hz]');ylabel('[rad]')

Nst=m1*g+m2*g-k1*dL01-k2*dL02
[rapp_max,imax]=max(abs(rapp))
y0max=Nst*fs/abs(Td(imax))
abs(Td(imax))*y0max
abs(Nd(imax))*y0max