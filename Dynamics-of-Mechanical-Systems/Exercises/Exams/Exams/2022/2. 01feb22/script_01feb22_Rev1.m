clear all
close all

m1=10;
m2=10;
J1=3.0;
J2=0.45;
L=1;
L0=1.5;
R=0.3;
k1=2500;
k2=2500;
k3=5000;
c2=0.5;
c3=1;
theta0=pi/6;
g=9.81;
sinth0=sin(theta0);
costh0=cos(theta0);

dL02=0.01;
dL01=-0.0396;
dL03=0.0245;

mph=diag([m1 J1 m2 m2 J2]);
cph=diag([c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[L              0;
    1              0;
    -L0*sinth0     costh0;
     L0*costh0     sinth0;
    1              -1/R];
Lk=[0              1;
    0              2;
    -2*L*costh0    0];
Lc=[0              2;
    -2*L*costh0    0];
Lq=[1     -1/R];

KG1=zeros(2);KG1(1,1)=-m1*g*L*sinth0;
KG2=m2*g*[-L0*sinth0  costh0; costh0  0];
KelII3=zeros(2);KelII3(1,1)=k3*dL03*2*L*sinth0;

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KG1+KG2+KelII3;

[modes,eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi


% .............................................................
% FRF 1-2

i=sqrt(-1);
C0=1;
vett_F0=[C0];
Q0=Lq'*vett_F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta_d=x0(1);
    s_dyn=x0(2);
    phi=theta_d-s_dyn/R;
    phidd=-ome^2*phi;
    dL2=2*s_dyn;
    dL3=-2*L*costh0*theta_d;
    Fel2=(k2+i*ome*c2)*dL2;
    Fel3=(k3+i*ome*c3)*dL3;
    T=Fel2-J2*phidd/R+C0/R;
    mod1(k)=abs(phi);
    fas1(k)=angle(phi);
    mod2(k)=abs(Fel3);
    fas2(k)=angle(Fel3);
    mod3(k)=abs(T);
    fas3(k)=angle(T);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[rad/Nm]');title('phi/C0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/Nm]');title('Fel3/C0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/Nm]');title('T/C0')
subplot 212;plot(vett_f,fas3);grid;xlabel('[Hz]');ylabel('[rad]')

% ......................

dL02=0.015;
dL01=-(m2*g*sinth0+2*k2*dL02)/k1
dL03=(m1*g*L+m2*g*L0)/2/L/k3


