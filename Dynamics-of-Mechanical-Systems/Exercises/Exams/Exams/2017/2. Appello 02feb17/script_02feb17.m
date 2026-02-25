%clear all
%close all

m1=10;
m2=5;
J1=0.8;
J2=0.15;
L=1.0;
AP=0.75;
R=0.25;
theta0=pi/6;
k1=5000;
k2=7500;
c1=3;
c2=5;
g=9.81;
dL01=-(m1*g*L*cos(theta0)+m2*g*(AP*cos(theta0)-R*sin(theta0))+m2*g*tan(theta0)*(AP*sin(theta0)+R*cos(theta0)))/(2*k1*L*cos(theta0));
dL02=m2*g/k2*tan(theta0);
T=1;
Fmax=100;

mph=diag([m1 J1 m2 m2 J2]);
cph=diag([c1 c2]);
kph=diag([k1 k2]);

Lm=[L                                 0 ;
    1                                 0;
    -AP*sin(theta0)-R*cos(theta0)  -R*cos(theta0);
     AP*cos(theta0)-R*sin(theta0)  -R*sin(theta0);
      1                               1];
Lk=[2*L*cos(theta0)                  0;
    AP*sin(theta0)+R*cos(theta0)  R*cos(theta0)];
Lc=Lk;

KII1=zeros(2);KII1(1,1)=-k1*dL01*2*L*sin(theta0);
KII2=k2*dL02*[AP*cos(theta0)-R*sin(theta0)  -R*sin(theta0);
              -R*sin(theta0)                  0];
KG1=zeros(2);KG1(1,1)=-m1*g*L*sin(theta0);
KG2=m2*g*[-AP*sin(theta0)-R*cos(theta0)   -R*cos(theta0);
          -R*cos(theta0)                       0];

MFF=Lm'*mph*Lm;
CFF=Lc'*cph*Lc;
KFF=Lk'*kph*Lk+KII1+KII2+KG1+KG2;

%..............................................
% natural frequencies and modes of vibration
[eigenvectors eigenvalues]=eig(MFF\KFF);

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%..............................................
% FRF 1 - question nr. 7

i=sqrt(-1);
F0=1;
Q0=[AP*cos(theta0)-R*sin(theta0);  -R*sin(theta0)]*F0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    x0=A\Q0;
    theta=x0(1);
    phi=x0(2);
    xC=(-AP*sin(theta0)-R*cos(theta0))*theta-R*cos(theta0)*phi;
    yC=(AP*cos(theta0)-R*sin(theta0))*theta-R*sin(theta0)*phi;
    dL2=(AP*sin(theta0)+R*cos(theta0))*theta+R*cos(theta0)*phi;
    Fel2=(k2+i*ome*c2)*dL2;
    xCdd=-ome^2*xC;
    yCdd=-ome^2*yC;
    N=Fel2*sin(theta0)-m2*xCdd*sin(theta0)-(F0-m2*yCdd)*cos(theta0);
    mod1(k)=abs(theta);
    fas1(k)=angle(theta);
    mod2(k)=abs(xC);
    fas2(k)=angle(xC);
    mod3(k)=abs(N);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[rad/N]');title('AB bar rotation/F0')
subplot 212;plot(vett_f,fas1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[m/N]');title('xC/F0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[deg]')

figure
plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/N]');title('N/F0')
Nmax=max(mod3);
Nst=k2*dL02*sin(theta0)+m2*g*cos(theta0);
Flim=abs(-Nst/Nmax)


%..............................................
% FRF 2

z0=1;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    Q0=[(k1+i*ome*c1)*z0*2*L*cos(theta0);0];
    x0=A\Q0;
    theta=x0(1);
    phi=x0(2);
    yC=(AP*cos(theta0)-R*sin(theta0))*theta-R*sin(theta0)*phi;
%     dL1=-2*L*cos(theta0)*theta-z0;
%     Fel1=(k1+i*ome*c1)*dL1;
    mod1(k)=abs(yC);
    fas1(k)=angle(yC);
    mod2(k)=abs(Fel1);
    fas2(k)=angle(Fel1);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/m]');title('yC/z0')
subplot 212;plot(vett_f,fas1*180/pi);grid;xlabel('[Hz]');ylabel('[deg]')

figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[N/m]');title('Fel1/z0')
subplot 212;plot(vett_f,fas2);grid;xlabel('[Hz]');ylabel('[deg]')

%..............................................
% question nr. 6

dt=0.001;
vt1=0:dt:T/2-dt;
vt2=T/2:dt:T-dt;
vF1=Fmax*ones(1,length(vt1));
vF2=-Fmax*ones(1,length(vt2));
vett_t=[vt1 vt2];
vett_F=[vF1 vF2];
figure;plot(vett_t,vett_F);grid;

df=1/T;
N=length(vett_t);
vett_f=0:df:df*(N/2-1);
FFTout=fft(vett_F);
modF(1)=abs(FFTout(1))/N;
modF(2:N/2)=abs(FFTout(2:N/2))*2/N;
fasF(1:N/2)=angle(FFTout(1:N/2));
figure
subplot 211;bar(vett_f,modF);grid
subplot 212;bar(vett_f,fasF);grid

tempo=0:dt:T;
np=length(tempo);
vett_Fr=zeros(1,np);
vett_yC=zeros(1,np);
Q0=[AP*cos(theta0)-R*sin(theta0);  -R*sin(theta0)];
for k=1:N/2
    ome=2*pi*vett_f(k);
    A=-ome^2*MFF+i*ome*CFF+KFF;
    Fcmplx=modF(k)*exp(i*fasF(k));
    vett_Q=Q0*Fcmplx;
    x0=A\vett_Q;
    theta=x0(1);
    phi=x0(2);
    yC=(AP*cos(theta0)-R*sin(theta0))*theta-R*sin(theta0)*phi;
    vett_Fr=vett_Fr+modF(k)*cos(ome*tempo+fasF(k)); 
    vett_yC=vett_yC+abs(yC)*cos(ome*tempo+angle(yC)); 
end
figure;plot(tempo,vett_Fr);grid;title('F')
figure;plot(tempo,vett_yC);grid;title('yC')

