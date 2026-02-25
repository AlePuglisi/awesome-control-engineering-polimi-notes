clear all
close all

m1=5;
R=0.5;
J1=0.6;
b=0.4;
m2=5;
L2=0.5;
J2=0.4;
m3=5;
L3=0.5;
J3=0.4;
k1=2000;
k2=4000;
c1=4;
c2=0.5;
theta_e=-pi/6;
costhe=cos(theta_e);
sinthe=sin(theta_e);
g=9.81;
% dL2e=-m3*g/2/k2
% dL1e=(m1*g*R+(m2*g+m3*g+k2*dL2e)*(R+b*costhe))/2/R/k1
dL1e=0.0434;
dL2e=-0.0061;


mph=diag([m1 J1 m2 m2 J2 m3 m3 J3]);
cph=diag([c1 c2]);
kph=diag([k1 k2]);

Lm=[   R         0    1;
       1         0    0;
    -b*sinthe    L2   0;
    R+b*costhe   0    1;
       0         1    0;
    -b*sinthe   2*L2  0;
    R+b*costhe   L3   1;
       0         1    0];

Lc=[-2*R         0    -1;
    R+b*costhe  2*L3   1];

Lk=Lc;
Lf=[0     0       1];

KelII2=zeros(3,3); KelII2(1,1)=-k2*dL2e*b*sinthe; KelII2(2,2)=k2*dL2e*2*L2;
KG2=zeros(3,3); KG2(1,1)=-m2*g*b*sinthe; KG2(2,2)=m2*g*L2;
KG3=zeros(3,3); KG3(1,1)=-m3*g*b*sinthe; KG3(2,2)=m3*g*2*L2;

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KelII2+KG2+KG3;

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


% ....................................
% natural frequencies and modes of vibration

[eigenvectors,eigenvalues]=eig(MFF\KFF);

modes=eigenvectors
freq=sqrt(diag(eigenvalues))/2/pi


% .........................
% FRF 

i=sqrt(-1);
vect_freq=0:0.01:5;
y0=1;
xc0=y0;
for j=1:length(vect_freq)
    ome=2*pi*vect_freq(j);
    vect_f_FC0=-(-ome^2*MFC+i*ome*CFC+KFC)*xc0;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    vect_x_F0=A\vect_f_FC0;
    phi0=vect_x_F0(1);
    theta0=vect_x_F0(2);
    xG30=-b*sinthe*phi0+2*L2*theta0;
    yG20=(R+b*costhe)*phi0+y0;
    yG30=(R+b*costhe)*phi0+L3*theta0+y0;
    dL20=(R+b*costhe)*phi0+2*L3*theta0+y0;
    Fel20=(k2+i*ome*c2)*dL20;
    yG2dd0=-ome^2*yG20;
    yG3dd0=-ome^2*yG30;
    VA0dyn=m2*yG2dd0+m3*yG3dd0+Fel20;
    
    mod1(j)=abs(xG30);
    phase1(j)=angle(xG30);
    mod2(j)=abs(yG20);
    phase2(j)=angle(yG20);
    mod3(j)=abs(VA0dyn);
    phase3(j)=angle(VA0dyn);
end


figure;
subplot 211;plot(vect_freq,mod1);grid;xlabel('[Hz]');ylabel('[rad/m]');title('xG30/y0')
subplot 212;plot(vect_freq,phase1);grid;xlabel('[Hz]');ylabel('[rad]')

figure;
subplot 211;plot(vect_freq,mod2);grid;xlabel('[Hz]');ylabel('[N/m]');title('yG20/y0')
subplot 212;plot(vect_freq,phase2);grid;xlabel('[Hz]');ylabel('[rad]')

figure;
subplot 211;plot(vect_freq,mod3);grid;xlabel('[Hz]');ylabel('[N/m]');title('VA0dyn/y0')
subplot 212;plot(vect_freq,phase3);grid;xlabel('[Hz]');ylabel('[rad]')

% .........................

dL1e=(m1*g*R+(m2*g+m3*g+k2*dL2e)*(R+b*costhe))/2/R/k1
