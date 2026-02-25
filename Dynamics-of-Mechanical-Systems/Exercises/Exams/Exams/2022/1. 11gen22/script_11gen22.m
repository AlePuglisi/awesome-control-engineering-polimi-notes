clear all
close all

m1=15;
m2=5;
J1=1.8;
J2=0.4;
L=1;
b=0.5;
d=0.3;
a1=0.5;
a2=0.4;
h1=0.4;
h2=0.2;
k1=6000;
k2=6000;
c1=15;
c2=15;
g=9.81;

mtx_A=[(b+h2)   h2;
       1        1];
vett_b=[-m2*g*a2;0];
x=mtx_A\vett_b;
% dL01=-m1*g/k1*a1/L
% dL02=x(2)/k2
dL01=-0.0123;
dL02=0.0065;


mph=diag([m1 m1 J1 m2 m2 J2]);
cph=diag([c1 c2]);
kph=diag([k1 k2]);

Lm=[b+h2    -h1;
    0       -a1;
    0        1;
    b        0;
    a2       0;
    1        0];
Lk=[0       -L;
    -b       0];
Lq=[0        -a1;
    b         0];
Lc=Lk;

KG1=zeros(2);KG1(2,2)=-m1*g*h1;
KG2=zeros(2);KG2(1,1)=-m2*g*h2;
KelII2=zeros(2);KelII2(1,1)=k2*dL02*(-d);

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KG1+KG2+KelII2;

[modes,eigenvalues]=eig(M\K);
modes
freq=sqrt(diag(eigenvalues))/2/pi

% .............................................................
% FRF 1

i=sqrt(-1);
F01=1;
F02=0;
vett_F0=[F01;F02];
Q0=Lq'*vett_F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    phi=x0(2);
    yg1=-a1*phi;
    yg2=a2*theta;
    mod1(k)=abs(yg1);
    fas1(k)=angle(yg1);
    mod2(k)=abs(yg2);
    fas2(k)=angle(yg2);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/N]');title('yg1/F01')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/N]');title('yg2/F01')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')

% .............................................................
% FRF 2

F01=0;
F02=1;
vett_F0=[F01;F02];
Q0=Lq'*vett_F0;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    phi=x0(2);
    xg1=(b+h2)*theta-h1*phi;
    xg2=b*theta;
    yg1=-a1*phi;
    yg2=a2*theta;
    xddg1=-ome^2*xg1;
    xddg2=-ome^2*xg2;
    yddg1=-ome^2*yg1;
    yddg2=-ome^2*yg2;
    dL1=-L*phi;
    dL2=-b*theta;
    Fel1=(k1+i*ome*c1)*dL1;
    Fel2=(k2+i*ome*c2)*dL2;
    NA=m1*yddg1+m2*yddg2-F01+Fel1;
    NB=m1*xddg1+m2*xddg2-F02-Fel2;
    mod1(k)=abs(NA);
    fas1(k)=angle(NA);
    mod2(k)=abs(NB);
    fas2(k)=angle(NB);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[N/N]');title('NA/F02')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/N]');title('NB/F02')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')



% ......................

m2=10;
mtx_A=[(b+h2)   h2;
       1        1];
vett_b=[-m2*g*a2;0];
x=mtx_A\vett_b;
dL01=-m1*g/k1*a1/L
dL02=x(2)/k2

