clear all
%close all

m=2;
J=2e-3;
L=0.1;
g=9.81;
k1=1000;
kt=100;
r=1;
T=0.2;
Fmax=10;
ome_pt6=15;
y01=0.01;
phi01=pi/6;
theta0=pi/6;

mf=diag([m m J m m J]);
rf=diag([r]);
kf=diag([k1 kt]);

Jm=[1 -L*sin(theta0) 0;0 L*cos(theta0) 0;0 1 0;1 -3*L*sin(theta0) 0;0 L*cos(theta0) 0;0 1 0];
Jk=[1 0 -1;0 -2 0];
Jr=[1 0 -1];

Kg=zeros(3);
Kg(2,2)=-2*m*g*L*sin(theta0);
M=Jm'*mf*Jm;
R=Jr'*rf*Jr;
K=Jk'*kf*Jk+Kg;

MLL=M(1:2,1:2);
RLL=R(1:2,1:2);
KLL=K(1:2,1:2);

MVL=M(3,1:2);
RVL=R(3,1:2);
KVL=K(3,1:2);

MLV=M(1:2,3);
RLV=R(1:2,3);
KLV=K(1:2,3);

MVV=M(3,3);
RVV=R(3,3);
KVV=K(3,3);

[modi autov]=eig(MLL\KLL);
freq=sqrt(diag(autov))/2/pi
modi

%........................................................PUNTO 3

i=sqrt(-1);
vett_f=0:0.01:20;
Q=[1;-4*L*sin(theta0)];
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*MLL+i*ome*RLL+KLL;
   x=A\Q;
   xC=-4*L*sin(theta0)*x(2)+x(1);
   mod1(k)=abs(-2*x(2));
   fas1(k)=angle(-2*x(2));
   mod2(k)=abs(xC);
   fas2(k)=angle(xC);
end
    
figure
subplot 211;plot(vett_f,mod1);grid;title('theta rel./F0')
subplot 212;plot(vett_f,fas1);grid
    
figure
subplot 211;plot(vett_f,mod2);grid;title('xC/F0')
subplot 212;plot(vett_f,fas2);grid

%........................................................PUNTO 4

y0=1;
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*MLL+i*ome*RLL+KLL;
   Q=-(-ome^2*MLV+i*ome*RLV+KLV)*y0;
   x=A\Q;
   yB=2*L*cos(theta0)*x(2);
   Fy=(-ome^2*MVL+i*ome*RVL+KVL)*x+(-ome^2*MVV+i*ome*RVV+KVV)*y0;
   mod1(k)=abs(yB);
   fas1(k)=angle(yB);
   mod2(k)=abs(Fy);
   fas2(k)=angle(Fy);
end
    
figure
subplot 211;plot(vett_f,mod1);grid;title('yB/y0')
subplot 212;plot(vett_f,fas1);grid
    
figure
subplot 211;plot(vett_f,mod2);grid;title('Fy/y0')
subplot 212;plot(vett_f,fas2);grid

dt=0.001;
% vt1=0:dt:T/2-dt;
% vt2=T/2:dt:T-dt;
% vy1=Fp*ones(1,length(vt1));
% vy2=-Fp*ones(1,length(vt2));
% vett_t=[vt1 vt2];
% vett_F=[vy1 vy2];
m=4*Fmax/T;
t1=T/4;
t2=3*T/4;
t3=T;
vt1=0:dt:t1-dt;
vt2=t1:dt:t2-dt;
vt3=t2:dt:t3-dt;
vf1=m*vt1;
vf2=2*m*t1-m*vt2;
vf3=-4*m*t1+m*vt3;
vett_t=[vt1 vt2 vt3];
vett_F=[vf1 vf2 vf3];

figure;plot(vett_t,vett_F);grid;


fftout=fft(vett_F);
N=length(vett_F);
df=1/T;
fmax=(N/2-1)*df;
vett_freq=0:df:fmax;
modf(1)=1/N*abs(fftout(1));
modf(2:N/2)=2/N*abs(fftout(2:N/2));
fasf(1:N/2)=angle(fftout(1:N/2));

figure
subplot 211;bar(vett_freq,modf);grid;title('y0')
subplot 212;bar(vett_freq,fasf);grid


vett_t2=0:dt:2*pi/ome_pt6;
np=length(vett_t2);
Q=[1;-4*L*sin(theta0)];
fp=zeros(1,np);
vett_N1=zeros(1,np);
for iarm=1:length(modf)
   F0=modf(iarm)*exp(i*fasf(iarm));
   ome=2*pi*vett_freq(iarm);
   A=-ome^2*MLL+i*ome*RLL+KLL;
   x=A\Q*F0;
   xpp=-ome^2*x(1);
   thetapp=-ome^2*x(2);
   xppG1=xpp-L*thetapp*sin(theta0);
   yppG1=L*thetapp*cos(theta0);
   xppG2=xpp-3*L*thetapp*sin(theta0);
   yppG2=L*thetapp*cos(theta0);
   N1=m*(yppG1*cos(theta0)+3*yppG2*cos(theta0)-xppG1*sin(theta0)-xppG2*sin(theta0))/(4*cos(theta0));
   fp=fp+modf(iarm)*cos(ome*vett_t2+fasf(iarm));
   vett_N1=vett_N1+abs(N1)*cos(ome*vett_t2+angle(N1));
end

figure;plot(vett_t2,vett_N1);grid;title('N1')

y0=y01*exp(i*phi01);
ome=ome_pt6;
A=-ome^2*MLL+i*ome*RLL+KLL;
Q=-(-ome^2*MLV+i*ome*RLV+KLV)*y0;
x=A\Q;
xpp=-ome^2*x(1);
thetapp=-ome^2*x(2);
xppG1=xpp-L*thetapp*sin(theta0);
yppG1=L*thetapp*cos(theta0);
xppG2=xpp-3*L*thetapp*sin(theta0);
yppG2=L*thetapp*cos(theta0);
N1=m*(yppG1*cos(theta0)+3*yppG2*cos(theta0)-xppG1*sin(theta0)-xppG2*sin(theta0))/(4*cos(theta0));
vett_N1=vett_N1+abs(N1)*cos(ome*vett_t2+angle(N1));

figure;plot(vett_t,vett_F,vett_t2,fp);grid
figure;plot(vett_t2,vett_N1);grid;title('N1')



