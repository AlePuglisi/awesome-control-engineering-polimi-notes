clear all
close all

m1=10;
m2=10;
J1=3.0;
J2=1.25;
L=1.0;
R=0.5;
d=0.25;
L0=1.25;
theta0=pi/6;
phi0=pi/6;
k1=30e3;
k2=10e3;
c1=4;
c2=4;
sinth0=sin(theta0);
costh0=cos(theta0);
sinphi0=sin(phi0);
cosphi0=cos(phi0);
g=9.81;

% Fel02=m2*g*R*sinth0/(d*sin(theta0+phi0)+R*costh0); dL02=Fel02/k2
% N=m2*g*costh0+Fel02*sinth0;
% dL01=-(m1*g*L*costh0+N*L0)/(2*k1*L*costh0)

dL01=-0.0041;
dL02=0.0038;

mph=diag([m1 J1 m2 m2 J2]);
cph=diag([c1 c2]);
kph=diag([k1 k2]);

Lm=[   L              0;
       1              0;
    -L0*sinth0-R*costh0   -R*costh0;
     L0*costh0-R*sinth0   -R*sinth0;
       1              1   ];
Lk=[2*L*costh0                                        0;
    L0*sinth0+R*costh0+d*sin(theta0+phi0)     R*costh0+d*sin(theta0+phi0)];
Lc=Lk;
Lq=[ 1             1;
    2*L*costh0    0];

Kel1=k1*dL01*[-2*L*sinth0   0;0 0];
Kel2=k2*dL02*[L0*costh0-R*sinth0+d*cos(theta0+phi0)  -R*sinth0+d*cos(theta0+phi0);-R*sinth0+d*cos(theta0+phi0) d*cos(theta0+phi0)];

Kg1=m1*g*[-L*sinth0 0; 0 0];
Kg2=m2*g*[-L0*sinth0-R*costh0 -R*costh0;-R*costh0 0];

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+Kel1+Kel2+Kg1+Kg2;

[modes eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi

%............................................
% FRF 1 


i=sqrt(-1);
vett_f=0:0.01:15;
C0=1; 
F=[C0;0];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta_d=x0(1);
    phi=x0(2);
    yg1=L*costh0*theta_d;
    xc=(-L0*sinth0-R*costh0)*theta_d-R*costh0*phi;
    mod1(k)=abs(yg1);
    phase1(k)=angle(yg1);
    mod2(k)=abs(xc);
    phase2(k)=angle(xc);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('yg1/C0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('xc/C0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')


%............................................
% FRF 2, 3 

C0=0; y0=1;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    F=[C0;y0*(k1+i*ome*c1)];
    Q0=Lq'*F;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta_d=x0(1);
    phi=x0(2);
    phia=phi+theta_d;
    yc=(L0*costh0-R*sinth0)*theta_d-R*sinth0*phi;
    phiadd=-phia*ome^2;
    yddc=-yc*ome^2;
    dL2=(L0*sinth0+R*costh0+d*sin(theta0+phi0))*theta_d+(R*costh0+d*sin(theta0+phi0))*phi;
    Fel2=(k2+i*ome*c2)*dL2;
    Fel02=k2*dL02;
    Tst=Fel02*d/R*sin(theta0+phi0);
    Td=(J2*phiadd-C0+Fel02*d*cos(theta0+phi0)*phia+Fel2*d*sin(theta0+phi0))/R;
%     xg1=(R1-d*costh0)*theta_d;
%     yg1=d*sinth0*theta_d;
%     xg2=dxg2_dth*theta_d-R2**phi;
%     yg2=dyg2_dth*theta_d+R2*sinth0*phi;
%     yddg1=-yg1*ome^2;
%     xddg2=-xg2*ome^2;
    Nd=(m2*yddc-Tst*costh0*theta_d-Td*sinth0)/costh0;
    mod1(k)=abs(theta_d);
    phase1(k)=angle(theta_d);
    mod2(k)=abs(Fel2);
    phase2(k)=angle(Fel2);
    mod3(k)=abs(Nd);
    phase3(k)=angle(Nd);
    mod4(k)=abs(Td);
    phase4(k)=angle(Td);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[rad/m]');title('theta/y0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/m]');title('Fel2/y0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/m]');title('Nd/y0')
subplot 212;plot(vett_f,phase3);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod4);grid;xlabel('[Hz]');ylabel('[N/m]');title('Td/y0')
subplot 212;plot(vett_f,phase4);grid;xlabel('[Hz]');ylabel('[rad]')

% ..................................................
% question 6

Nst=(m2*g-Tst*sinth0)/costh0
Ndyn_over_y0_max=max(mod3)
y0_max=Nst/Ndyn_over_y0_max

