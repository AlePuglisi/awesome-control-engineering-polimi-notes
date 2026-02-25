clear all
close all

m1=2;
m2=1;
m3=1;
J1=0.05;
J2=0.02;
J3=0.05;
R1=0.2;
R3=0.2;
L=0.5;
k1=200;
k2=5000;
k3=300;
r1=2.5;
r2=0.01;
r3=0.05;
Fmax=100;
T=0.2;

mf=diag([m1 J1 m2 J2 J3]);
rf=diag([r1 r2 r3]);
kf=diag([k1 k2 k3]);

Lm=[-R1 -L;
    1 0;
    0 L/2;
    0 1;
    0 -2*L/R3];
Lr=[R1 L;
    0 L;
    -2*R1 -3*L];
Lk=Lr;

Kg=zeros(2,2);
M=Lm'*mf*Lm;
R=Lr'*rf*Lr;
K=Lk'*kf*Lk+Kg;

[modi autov]=eig(M\K);

freq=sqrt(diag(autov))/2/pi
modi

i=sqrt(-1);
C0=1;
Q=[1;0]*C0;
vett_f=0:0.01:10;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*R+K;
    x=A\Q;
    yc1=-R1*x(1)-L*x(2);
    beta=-2*L/R3*x(2);
    mod1(k)=abs(yc1);
    fas1(k)=angle(yc1);
    mod2(k)=abs(beta);
    fas2(k)=angle(beta);
end

figure
subplot 211;plot(vett_f,mod1)
subplot 212;plot(vett_f,fas1)
figure
subplot 211;plot(vett_f,mod2)
subplot 212;plot(vett_f,fas2)

T=0.8;

dt=0.001;
t1=0:dt:T/4-dt;
t2=T/4:dt:3/4*T-dt;
t3=3/4*T:dt:T-dt;
m=Fmax/(T/4);
F1=m*t1;
F2=2*Fmax-m*t2;
F3=-4*Fmax+m*t3;
vett_t=[t1 t2 t3];
vett_F=[F1 F2 F3];
figure;plot(vett_t,vett_F);grid

N=length(vett_F);
fftout=fft(vett_F);
modF(1)=abs(fftout(1))/N;
modF(2:N/2)=abs(fftout(2:N/2))*2/N;
fasF(1:N/2)=angle(fftout(1:N/2));
f0=1/T;
df=f0;
fmax=(N/2-1)*f0;
vett_freq=0:df:fmax;

figure
subplot 211; bar(vett_freq,modF)
subplot 212; bar(vett_freq,fasF)

i=sqrt(-1);
for k=1:N/2
   ome=2*pi*vett_freq(k);
   A=-ome^2*M+i*ome*R+K;
   F=modF(k)*exp(i*fasF(k));
   Q=[0;-2*L]*F;
   x=A\Q;
   yc1=-L*x(2)-R1*x(1);
   mody(k)=abs(yc1);
   fasy(k)=angle(yc1);
end

figure
subplot 211;bar(vett_freq,mody)
subplot 212;bar(vett_freq,fasy)

vett_y=zeros(1,N);
narm=N/2;
for iarm=1:narm
   ome=2*pi*vett_freq(iarm);
   vett_y=vett_y+mody(iarm)*cos(ome*vett_t+fasy(iarm));
    
end
figure;plot(vett_t,vett_y);grid;title(['nr. armoniche ' num2str(narm)])




