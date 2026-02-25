clear all
close all

M1=5;
M2=20;
M3=5;
J1=0.1;
J2=1.5;
J3=0.1;
k1=5e4;
k2=1e3;
r1=10;
r2=2;
L=0.3;
R=0.2;
g=9.81;
i=sqrt(-1);
nDOFL=2;    %non conta il vincolo impresso

Mph=diag([M1 J1 M2 J2 M3 M3 2*J3]);
Kph=diag([k1 k2]);
Cph=diag([r1 r2]);

Jm=[1 0 0;
    1/R L/R 0;
    1 0 0;
    1/(2*R) 0 0;
    0 L/2 0;
    0 L/2 0;
    0 1 0];
Jel=[-1 0 1;
    -2 -L 0];
Jc=Jel;

Kg=zeros(nDOFL+1,nDOFL+1);
Kg(2,2)=-L/2*g*M3;

MM=Jm'*Mph*Jm;
KK=Jel'*Kph*Jel+Kg;
CC=Jc'*Cph*Jc;

MFF=MM(1:nDOFL,1:nDOFL);
CFF=CC(1:nDOFL,1:nDOFL);
KFF=KK(1:nDOFL,1:nDOFL);

MFC=MM(1:nDOFL,nDOFL+1);
CFC=CC(1:nDOFL,nDOFL+1);
KFC=KK(1:nDOFL,nDOFL+1);

MCC=MM(nDOFL+1,nDOFL+1);
CCC=CC(nDOFL+1,nDOFL+1);
KCC=KK(nDOFL+1,nDOFL+1);

MCF=MM(nDOFL+1,1:nDOFL);
CCF=CC(nDOFL+1,1:nDOFL);
KCF=KK(nDOFL+1,1:nDOFL);

%..................................................................
[eigenvectors, eigenvalues]=eig(MFF\KFF);
freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%..................................................................PUNTO 3
vett_f=0:0.01:10;
Q=[1/R;L/R];
for k=1:length(vett_f)
    omega=2*pi*vett_f(k);
    A=-omega^2*MFF+i*omega*CFF+KFF;
    x=A\Q;
    theta=x(2);
    beta=x(1);
    mod1(k)=abs(theta);
    fas1(k)=angle(theta);
    mod2(k)=abs(beta);
    fas2(k)=angle(beta);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('theta/C01');xlabel('Hz');ylabel('rad/Nm')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;title('x_c/C01');xlabel('Hz');ylabel('m/Nm')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')


%..................................................................PUNTO 4
vett_f=0:0.01:10;
Q=[1/(2*R);0];
for k=1:length(vett_f)
    omega=2*pi*vett_f(k);
    A=-omega^2*MFF+i*omega*CFF+KFF;
    x=A\Q;
    theta=x(1)/R+L/R*x(2);
    beta=x(1)/(2*R);
    mod1(k)=abs(theta);
    fas1(k)=angle(theta);
    mod2(k)=abs(beta);
    fas2(k)=angle(beta);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('alpha/C02');xlabel('Hz');ylabel('rad/Nm')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;title('beta/C02');xlabel('Hz');ylabel('rad/Nm')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')



%................................................................PUNTO 5+6

y0=1;
for k=1:length(vett_f)
    omega=2*pi*vett_f(k);
    A=-omega^2*MFF+i*omega*CFF+KFF;
    Qfc=-(-omega^2*MFC+i*omega*CFC+KFC)*y0;
    x=A\Qfc;
    theta=x(2);
    xc=x(1);
    Qc=(-omega^2*MCF+i*omega*CCF+KCF)*x+(-omega^2*MCC+i*omega*CCC+KCC)*y0;
    Rx=Qc;
    beta=x(1)/(2*R);
    dL2=-2*x(1)-L*x(2);
    T=(-J2*omega^2*beta-(k2+i*omega*r2)*dL2*2*R)/(2*R);
    mod1(k)=abs(theta);
    fas1(k)=angle(theta);
    mod2(k)=abs(xc);
    fas2(k)=angle(xc);
    mod3(k)=abs(Rx);
    fas3(k)=angle(Rx);
    mod4(k)=abs(T);
    fas4(k)=angle(T);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('theta/y0');xlabel('Hz');ylabel('rad/m')
subplot 212;plot(vett_f,fas1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;title('x_c/y0');xlabel('Hz');ylabel('m/m')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod3);grid;title('Rx/y0');xlabel('Hz');ylabel('N/m')
subplot 212;plot(vett_f,fas3);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod4);grid;title('T/y0');xlabel('Hz');ylabel('N/m')
subplot 212;plot(vett_f,fas4);grid;xlabel('[Hz]');ylabel('[rad]')




















