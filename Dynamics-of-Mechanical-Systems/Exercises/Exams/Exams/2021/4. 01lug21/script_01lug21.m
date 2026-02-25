clear all
close all

m=10;
mA=5;
J=0.2;
R=1.0;
L=0.25;
h=0.05;
H=0.15;
k1=3000;
k2=9000;
c1=3;
c2=9;
g=9.81;
theta0=pi/6;
phi0=pi/12;
beta=pi/6;

costh0=cos(theta0);
sinth0=sin(theta0);
cosphi0=cos(phi0);
sinphi0=sin(phi0);
 
mph=diag([m m J mA]);
cph=diag([c1 c2]);
kph=diag([k1 k2]);
 
% mtx=[-2*L*sinphi0          L*cosphi0-H*sinphi0;
%     R*costh0+2*L*sinphi0   R*sinth0-L*cosphi0+H*sinphi0];
% vett_b=m*g*[L*cosphi0-h*sinphi0;R*sinth0-L*cosphi0+h*sinphi0]+mA*g*[0;R*sinth0];
% vett_x=mtx\vett_b;
% dL01=vett_x(1)/k1
% dL02=vett_x(2)/k2

mtx=[R*costh0     R*sinth0     ;
     2*L*sinphi0  -L*cosphi0+H*sinphi0];
vett_b=m*g*[R*sinth0;-L*cosphi0+h*sinphi0]+mA*g*[R*sinth0;0];
vett_x=mtx\vett_b;
% dL01=vett_x(1)/k1
% dL02=vett_x(2)/k2
dL01=0.0051;
dL02=0.0134;


Lm=[-R*costh0       -L*sinphi0-h*cosphi0;
    -R*sinth0        L*cosphi0-h*sinphi0;
         0                    1;
         R                    0];
Lk=[R*costh0   2*L*sinphi0;
    R*sinth0   -L*cosphi0+H*sinphi0];
Lq=[-R*costh0   -2*L*sinphi0;
    -R*sinth0    2*L*cosphi0;
    -R*sinth0    L*cosphi0-H*sinphi0];
Lc=Lk;

KG=m*g*[-R*costh0  0;0 -L*sinphi0-h*cosphi0];
KGA=mA*g*[-R*costh0  0;0 0];
Kel1=k1*dL01*[-R*sinth0  0;0 2*L*cosphi0];
Kel2=k2*dL02*[R*costh0   0;0   L*sinphi0+H*cosphi0];

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KG+KGA+Kel1+Kel2;

[modes,eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi


% .............................................................
% FRF 1

i=sqrt(-1);
F0=1;
y0=0; Fel_y=0;
vett_F0=[F0*cos(beta);F0*sin(beta);Fel_y];
Q0=Lq'*vett_F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta_d=x0(1);
    phi_d=x0(2);
    xg=-R*costh0*theta_d+(-L*sinphi0-h*cosphi0)*phi_d;
    yg=-R*sinth0*theta_d+(L*cosphi0-h*sinphi0)*phi_d;
    mod1(k)=abs(xg);
    fas1(k)=angle(xg);
    mod2(k)=abs(yg);
    fas2(k)=angle(yg);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/N]');title('xg/F0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/N]');title('yg/F0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')


% .............................................................
% FRF 2

F0=0;
y0=1; 
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    Fel_y=(k2+i*ome*c2)*y0;
    vett_F0=[F0;F0;Fel_y];
    Q0=Lq'*vett_F0;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta_d=x0(1);
    phi_d=x0(2);
    dL1=R*costh0*theta_d+2*L*sinphi0*phi_d;
    dL2=R*sinth0*theta_d+(-L*cosphi0+H*sinphi0)*phi_d+y0;
    Fel1= (k1+i*ome*c1)*dL1;
    Fel2= (k2+i*ome*c2)*dL2;
    mod1(k)=abs(Fel1);
    fas1(k)=angle(Fel1);
    mod2(k)=abs(Fel2);
    fas2(k)=angle(Fel2);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[N/m]');title('Fel1/y0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/m]');title('Fel2/y0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')


% .....................................................................
% FRF3

Nst=(m*g+mA*g-k2*dL02)*costh0+k1*dL01*sinth0;

i=sqrt(-1);
F0=1;
y0=0; Fel_y=0;
vett_F0=[F0*cos(beta);F0*sin(beta);Fel_y];
Q0=Lq'*vett_F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta_d=x0(1);
    phi_d=x0(2);
    xa=-R*costh0*theta_d;
    ya=-R*sinth0*theta_d;
    xg=-R*costh0*theta_d+(-L*sinphi0-h*cosphi0)*phi_d;
    yg=-R*sinth0*theta_d+(L*cosphi0-h*sinphi0)*phi_d;
    dL1=R*costh0*theta_d+2*L*sinphi0*phi_d;
    dL2=R*sinth0*theta_d+(-L*cosphi0+H*sinphi0)*phi_d+y0;
    Fel1= (k1+i*ome*c1)*dL1;
    Fel2= (k2+i*ome*c2)*dL2;
    xdda=-ome^2*xa;
    ydda=-ome^2*ya;
    xddg=-ome^2*xg;
    yddg=-ome^2*yg;
    Nd=((k2*dL02-m*g-mA*g)*sinth0+k1*dL01*costh0)*theta_d-(Fel2-m*yddg-mA*ydda+F0*sin(beta))*costh0+(Fel1+F0*cos(beta)-m*xddg-mA*xdda)*sinth0;
    mod1(k)=abs(Nd);
    fas1(k)=angle(Nd);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[N/Nm]');title('Nd/F0')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

Nd_4Hz=mod1(401);
F0_4Hz=F0*Nst/Nd_4Hz

% ......................

m=20;
h=0.15;
H=0.45;
theta0=pi/3;

costh0=cos(theta0);
sinth0=sin(theta0);

mtx=[R*costh0     R*sinth0     ;
     2*L*sinphi0  -L*cosphi0+H*sinphi0];
vett_b=m*g*[R*sinth0;-L*cosphi0+h*sinphi0]+mA*g*[R*sinth0;0];
vett_x=mtx\vett_b;
dL01=vett_x(1)/k1
dL02=vett_x(2)/k2

