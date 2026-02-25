clear all
close all
clc

m1=5;
m2=5;
J1=0.15;
J2=0.15;
r=0.25;
L2=0.3;
R=1.0;
k1=5000;
k2=5000;
c1=3;
c2=1;
g=9.81;
theta0=pi/6;
phi0=pi/3;
sinth0=sin(theta0);
costh0=cos(theta0);
sinphi0=sin(phi0);
cosphi0=cos(phi0);
RR=R-r;

% dL01=(m1*g+m2*g)*sinth0/(sinphi0+costh0)/k1
dL01=0.0057;

mph=diag([m1 J1 m2 m2 J2]);
cph=diag([c1 c2]);
kph=diag([k1 k2]);

Lm=[RR           0;
    -RR/r        0;
    RR*costh0    L2;
    RR*sinth0    0;
      0          1];
Lk=[-RR*costh0-RR*sinphi0    0;
    -RR*costh0             -2*L2];
Lc=Lk;
Lq=[-RR/r        0];

KII1=zeros(2);KII1(1,1)=k1*dL01*(RR*sinth0+RR^2/r*cosphi0);
KG1=zeros(2);KG1(1,1)=m1*g*RR*costh0;
KG2=m2*g*[RR*costh0   0;
          0          L2];

MFF=Lm'*mph*Lm
CFF=Lc'*cph*Lc
KFF=Lk'*kph*Lk+KII1+KG1+KG2

%..............................................
% natural frequencies and modes of vibration
[eigenvectors eigenvalues]=eig(MFF\KFF)

freq=sqrt(diag(eigenvalues))/2/pi


%..............................................
% FRF 

i=sqrt(-1);
C0=1;
vect_F0=[C0];       % vettore delle forzanti
Q0=Lq'*vect_F0;
vett_f=0:0.01:15;   % vettore delle frequenze
for k=1:length(vett_f)

    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    x0=A\Q0;
    theta=x0(1);
    psi=x0(2);

    xG2=RR*costh0*theta+L2*psi;
    xC=RR*costh0*theta;
    yC=RR*sinth0*theta;
    dL1=(-RR*costh0-RR*sinphi0)*theta;
    dL2=-RR*costh0*theta-2*L2*psi;
    Fel1=(k1+i*ome*c1)*dL1;
    Fel2=(k2+i*ome*c2)*dL2;
    phi=-RR/r*theta;
    phidd=-ome^2*phi;
    xCdd=-ome^2*xC;
    yCdd=-ome^2*yC;
    xG2dd=-ome^2*xG2;
    
    T=(J1*phidd-C0)/r+Fel1*sinphi0+k1*dL01*cosphi0*phi;
    N=(m1+m2)*yCdd*costh0+(Fel1+Fel2-m1*xCdd-m2*xG2dd)*sinth0-(m1*g+m2*g)*sinth0*theta+k1*dL01*costh0*theta;
    
    mod1(k)=abs(xG2);
    fas1(k)=angle(xG2);
    mod2(k)=abs(yC);
    fas2(k)=angle(yC);
    mod3(k)=abs(N);
    fas3(k)=angle(N);
    mod4(k)=abs(T);
    fas4(k)=angle(T);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('xG2/C0')
subplot 212;plot(vett_f,fas1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('yC/C0')
subplot 212;plot(vett_f,fas2*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/Nm]');title('N/C0')
subplot 212;plot(vett_f,fas3*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod4);grid;xlabel('[Hz]');ylabel('[N/Nm]');title('T/C0')
subplot 212;plot(vett_f,fas4*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')


% ..................................................

phi0=pi/4;
sinphi0=sin(phi0);
cosphi0=cos(phi0);
dL01=(m1*g+m2*g)*sinth0/(sinphi0+costh0)/k1

