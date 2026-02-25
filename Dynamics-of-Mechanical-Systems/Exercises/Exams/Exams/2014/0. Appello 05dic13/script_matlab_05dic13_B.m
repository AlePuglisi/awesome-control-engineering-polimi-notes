clear all
close all

m1=2;
m2=10;
m3=3;
m4=3;
J1=0.02;
J3=0.06;
J4=0.1;
R1=0.1;
R3=0.2;
L=0.6;
g=9.81;
k1=1000;
k2=1000;
k3=1000;
r1=1;
r2=1;
r3=1;
T=0.5;
ymax=0.01;
ome_pt6=20;
C01=4;
phi01=pi/6;

mf=diag([m1 J1 m2 m3+m4 J3 J4]);
rf=diag([r1 r2 r3]);
kf=diag([k1 k2 k3]);

Jm=[0 0 1;1/R1 0 -1/R1;1 0 0;1 L 0;1/R3 L/R3 0;0 1 0];
Jk=[2 0 -2;0 2*L 0;-2 -2*L 0];

Kg=zeros(3,3);Kg(2,2)=(m3+m4)*g*L;
M=Jm'*mf*Jm;
R=Jk'*rf*Jk;
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

i=sqrt(-1);
vett_f=0:0.01:10;
Q=[0;1];
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*MLL+i*ome*RLL+KLL;
   x=A\Q;
   phi=x(1)/R1;
   alpha=x(1)/R3+L*x(2)/R3;
   mod1(k)=abs(phi);
   fas1(k)=angle(phi);
   mod2(k)=abs(alpha);
   fas2(k)=angle(alpha);
end
    
figure
subplot 211;plot(vett_f,mod1);grid;title('phi/C0')
subplot 212;plot(vett_f,fas1);grid
    
figure
subplot 211;plot(vett_f,mod2);grid;title('alpha/C0')
subplot 212;plot(vett_f,fas2);grid
    
y0=1;
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*MLL+i*ome*RLL+KLL;
   Q=-(-ome^2*MLV+i*ome*RLV+KLV)*y0;
   x=A\Q;
   xg=x(1)+L*x(2);
   dL3=-(2*x(1)+2*L*x(2));
   Fel3=(k3+i*ome*r3)*dL3;
   mod1(k)=abs(xg);
   fas1(k)=angle(xg);
   mod2(k)=abs(Fel3);
   fas2(k)=angle(Fel3);
end
    
figure
subplot 211;plot(vett_f,mod1);grid;title('xg/y0')
subplot 212;plot(vett_f,fas1);grid
    
figure
subplot 211;plot(vett_f,mod2);grid;title('Fel3/y0')
subplot 212;plot(vett_f,fas2);grid

dt=0.001;
m=ymax/T*2;
t1=0:dt:T/2-dt;
t2=T/2+dt:dt:T-dt;
y1=m*t1;
y2=m*t2-2*ymax;
vett_t=[t1 T/2 t2];
vett_y=[y1 0 y2];

figure;plot(vett_t,vett_y);grid

fftout=fft(vett_y);
N=length(vett_y);
df=1/T;
fmax=(N/2-1)*df;
vett_freq=0:df:fmax;
mody(1)=1/N*abs(fftout(1));
mody(2:N/2)=2/N*abs(fftout(2:N/2));
fasy(1:N/2)=angle(fftout(1:N/2));

figure
subplot 211;bar(vett_freq,mody);grid;title('y0')
subplot 212;bar(vett_freq,fasy);grid

yr=zeros(1,N);
vett_Fy=zeros(1,N);
vett_HA2=zeros(1,N);
for iarm=1:length(mody)
   y0=mody(iarm)*exp(i*fasy(iarm));
   ome=2*pi*vett_freq(iarm);
   A=-ome^2*MLL+i*ome*RLL+KLL;
   Q=-(-ome^2*MLV+i*ome*RLV+KLV)*y0;
   x=A\Q;
   Fy=(-ome^2*MVL+i*ome*RVL+KVL)*x+(-ome^2*MVV+i*ome*RVV+KVV)*y0;
   xGpp=-ome^2*(x(1)+L*x(2));
   alphapp=-ome^2*(x(1)/R3+L*x(2)/R3);
   dL2=2*L*x(2);
   dL3=-(2*x(1)+2*L*x(2));
   Fel2=(k2+i*ome*r2)*dL2;
   Fel3=(k3+i*ome*r3)*dL3;
   RI=Fel3-J3*alphapp/R3;
   HA2=Fel3+RI-Fel2-(m3+m4)*xGpp;
   yr=yr+mody(iarm)*cos(ome*vett_t+fasy(iarm));
   vett_Fy=vett_Fy+abs(Fy)*cos(ome*vett_t+angle(Fy));
   vett_HA2=vett_HA2+abs(HA2)*cos(ome*vett_t+angle(HA2));
end

figure;plot(vett_t,vett_y,vett_t,yr);grid
figure;plot(vett_t,vett_Fy);grid;title('Fy')

y0=0;
ome=ome_pt6;
A=-ome^2*MLL+i*ome*RLL+KLL;
Q=[0;1]*C01*exp(i*phi01);
x=A\Q;
Fy=(-ome^2*MVL+i*ome*RVL+KVL)*x+(-ome^2*MVV+i*ome*RVV+KVV)*y0;
xGpp=-ome^2*(x(1)+L*x(2));
alphapp=-ome^2*(x(1)/R3+L*x(2)/R3);
dL2=2*L*x(2);
dL3=-(2*x(1)+2*L*x(2));
Fel2=(k2+i*ome*r2)*dL2;
Fel3=(k3+i*ome*r3)*dL3;
RI=Fel3-J3*alphapp/R3;
HA2=Fel3+RI-Fel2-(m3+m4)*xGpp;
vett_HA2=vett_HA2+abs(HA2)*cos(ome*vett_t+angle(HA2));

figure;plot(vett_t,vett_HA2);grid;title('HA')




