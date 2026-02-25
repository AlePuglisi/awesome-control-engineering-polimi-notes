clear all
close all

m1 =  10;
m2 =  5;
m3 =  10;
J1 = 0.2;
J2 = 0.5;
k1 =  1000;
k2 =  2000;
k3 =  1000;
L =  0.5;
R =  0.25;
c1 = 1;
c2 = 2;
c3 = 1;
g=9.81;


mph=diag([m1 J1 m2 J2 m3]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[-L 0; 1 0;-2*L R;0 1;-2*L 0];
Lk=[-L 0;-L 2*R;2*L 0];
Lq=[1 0; 0 1];
Lc=Lk;

KG=zeros(2); KG(1,1)=m1*g*L;

MFF=Lm'*mph*Lm;
CFF=Lc'*cph*Lc;
KFF=Lk'*kph*Lk+KG;

%..............................................
% natural frequencies and modes of vibration
[eigenvectors eigenvalues]=eig(MFF\KFF);

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors


%..............................................
% FRF 1

i=sqrt(-1);
C01=1;
F0=[C01;0];
Q0=Lq'*F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    x0=A\Q0;
    theta=x0(1);
    phi=x0(2);
    mod1(k)=abs(phi);
    fas1(k)=angle(phi);
    mod2(k)=abs(theta);
    fas2(k)=angle(theta);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[rad/Nm]');title('disk rotation/C01')
subplot 212;plot(vett_f,fas1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[rad/Nm]');title('bar rotation/C01')
subplot 212;plot(vett_f,fas2*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

%..............................................
% FRF 2


C02=1;
F0=[0;C02];
Q0=Lq'*F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    x0=A\Q0;
    theta=x0(1);
    phi=x0(2);
    s2=-2*L*theta+R*phi;
    s3=-2*L*theta;
    xg1=-L*theta;
    xg1dd=-xg1*ome^2;
    thetadd=-theta*ome^2;
    s2dd=-s2*ome^2;
    s3dd=-s3*ome^2;
    dL1=-L*theta;
    dL2=-L*theta+2*R*phi;
    dL3=2*L*theta;
    Fel1=(k1+i*ome*c1)*dL1;
    Fel2=(k2+i*ome*c2)*dL2;
    Fel3=(k3+i*ome*c3)*dL3;
    HA=(m1*g*theta+J1*thetadd/L+Fel1+m1*xg1dd-Fel2)/2;
    HA2=Fel1+m1*xg1dd-Fel3+m2*s2dd+m3*s3dd;
    mod1(k)=abs(s2);
    fas1(k)=angle(s2);
    mod2(k)=abs(HA);
    fas2(k)=angle(HA);
    mod3(k)=abs(HA2);
    fas3(k)=angle(HA2);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('s2/C02')
subplot 212;plot(vett_f,fas1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/Nm]');title('HA/C02')
subplot 212;plot(vett_f,fas2*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/Nm]');title('HA2/C02')
subplot 212;plot(vett_f,fas3*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

