clear all
%close all

m1=20;
m2=5;
m3=10;
m4=6;
J2=0.2;
J3=1.25;
J4=0.5;
L=1;
R2=0.25;
R3=0.5;
g=9.81;
k1=1000;
k2=1000;
k3=6000;
r1=1;
r2=1;
r3=1;
T=1.2;
y1=0.1;

mf=diag([m1 m2 J2 m3 J3 m4 J4]);
rf=diag([r1 r2 r3]);
kf=diag([k1 k2 k3]);

Jm=[ 1     0     0;
     0    -L     0;
     0    L/R2 1/R2;
     0    -L     0;
    -1/R3 -L/R3   0;
     0    -L/2    0;
     0     1     0];
Jel=[1   0     0; 
    -2 -2*L    0;
     0  2*L    1];
Kg=zeros(3,3);
Kg(2,2)=-(m2+m3+m4/2)*g*L;
MM=Jm'*mf*Jm;
RR=Jel'*rf*Jel;
KK=Jel'*kf*Jel+Kg;

MLL=MM(1:2,1:2);
RLL=RR(1:2,1:2);
KLL=KK(1:2,1:2);

MLV=MM(1:2,3);
RLV=RR(1:2,3);
KLV=KK(1:2,3);

[modi autov]=eig(MLL\KLL);
freq=sqrt(diag(autov))/2/pi
modi

A1=[MLL zeros(2,2);zeros(2,2) MLL];
B1=[RLL KLL ; -MLL zeros(2,2)];
A=-inv(A1)*B1;
[modid autovd]=eig(A);
freqd=imag(diag(autovd))/2/pi
rrc=-real(diag(autovd))./abs(imag(diag(autovd)))*100

vett_f=0:0.01:10;
omega=vett_f*2*pi;
vett_Q=[-1/R3;-L/R3];
for k=1:length(vett_f)
    A=-omega(k)^2*MLL+i*omega(k)*RLL+KLL;
    x=A\vett_Q;
    yg1=x(2)*L/R2;
    yg2=(k3+i*omega(k)*r3)*(x(2)*2*L);
    mod1(k)=abs(yg1);
    fas1(k)=angle(yg1);
    mod2(k)=abs(yg2);
    fas2(k)=angle(yg2);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('theta_2/C')
subplot 212;plot(vett_f,fas1*180/pi);grid

figure
subplot 211;plot(vett_f,mod2);grid;title('F3/C')
subplot 212;plot(vett_f,fas2*180/pi);grid

y0=1;
for k=1:length(vett_f)
    A=-omega(k)^2*MLL+i*omega(k)*RLL+KLL;
    Q=-(-omega(k)^2*MLV+i*omega(k)*RLV+KLV)*y0;
    x=A\Q;
    yg1=x(2)*L/R2+1/R2;
    yg2=(k3+i*omega(k)*r3)*(x(2)*2*L+1);
    mod1(k)=abs(yg1);
    fas1(k)=angle(yg1);
    mod2(k)=abs(yg2);
    fas2(k)=angle(yg2);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('theta_2/y')
subplot 212;plot(vett_f,fas1*180/pi);grid

figure
subplot 211;plot(vett_f,mod2);grid;title('Fel3/y')
subplot 212;plot(vett_f,fas2*180/pi);grid

% %spostamento periodico
% 
dt=0.001;
m=4*y1/T;
t1=T/4;
t2=3*T/4;
t3=T;
vt1=0:dt:t1-dt;
vt2=t1:dt:t2-dt;
vt3=t2:dt:t3-dt;
vy1=m*vt1;
vy2=2*m*t1-m*vt2;
vy3=-4*m*t1+m*vt3;
vett_t=[vt1 vt2 vt3];
vett_y=[vy1 vy2 vy3];
figure(5);plot(vett_t,vett_y);grid; %axis([0 T -0.15 0.15])

df=1/T;
N=length(vett_t);
vett_f=0:df:df*(N/2-1);
g=fft(vett_y);
mody(1)=abs(g(1))/N;
mody(2:N/2)=abs(g(2:N/2))*2/N;
fasy(1:N/2)=angle(g(1:N/2));
figure(6)
subplot 211;bar(vett_f,mody);grid
subplot 212;bar(vett_f,fasy);grid

tempo=0:dt:2*T;
np=length(tempo);
yimp=zeros(1,np);
ygt1=zeros(1,np);
ygt2=zeros(1,np);
ygt3=zeros(1,np);
C=0;
g=9.81;

clear mod1 mod2 fas1 fas2
for k=1:N/2
    ome=2*pi*vett_f(k);
    y=mody(k)*exp(j*fasy(k));
    A=-ome^2*MLL+j*ome*RLL+KLL;
    x=-inv(A)*(-ome^2*MLV+j*ome*RLV+KLV)*y;
    yg1=x(1)/R2+x(2)*L/R2-y/R2;
    thetapp=-ome^2*x(2);
    alfapp=-ome^2*(L/R2*x(2)+y/R2);
    betapp=-ome^2*(-x(1)/R3-L/R3*x(2));
    Fel2=(k2+i*ome*r2)*(-2*x(1)-2*L*x(2));
    Fel3=(k3+i*ome*r3)*(x(2)*2*L+y);
    T2=Fel3+J2/R2*alfapp;
    T3=Fel2+J3/R3*betapp-C/R3;
    HB=-(m2+m3+m4/2)*L*thetapp+T3+Fel2-T2-Fel3;
    HB2=(J4/L-m4*L/4)*thetapp-(m2+m3-m4/2)*g*x(2);
    mod1=abs(yg1);
    fas1=angle(yg1);
    mod2=abs(Fel3);
    fas2=angle(Fel3);
    mod3=abs(HB);
    fas3=angle(HB);
    yimp=yimp+mody(k)*cos(ome*tempo+fasy(k)); 
    ygt1=ygt1+mod1*cos(ome*tempo+fas1); 
    ygt2=ygt2+mod2*cos(ome*tempo+fas2); 
    ygt3=ygt3+mod3*cos(ome*tempo+fas3); 
end
% figure(7);plot(tempo,yimp);grid;title('Spostamento impresso')
% figure(8);plot(tempo,ygt1);grid;title('Rotazione disco 2')
figure(9);plot(tempo,ygt2);grid;title('Forza elastica molla (solo y)')
figure(10);plot(tempo,ygt3);grid;title('HB (solo y)')

ome=2*pi*2.5;
    A=-ome^2*MLL+j*ome*RLL+KLL;
    C=25*exp(j*pi/6);
    y=0;
    x=inv(A)*vett_Q*C;
    yg1=x(1)/R2+x(2)*L/R2-y/R2;
    thetapp=-ome^2*x(2);
    alfapp=-ome^2*(L/R2*x(2)+y/R2);
    betapp=-ome^2*(-x(1)/R3-L/R3*x(2));
    Fel2=(k2+i*ome*r2)*(-2*x(1)-2*L*x(2));
    Fel3=(k3+i*ome*r3)*(x(2)*2*L+y);
    T2=Fel3+J2/R2*alfapp;
    T3=Fel2+J3/R3*betapp-C/R3;
    HB=-(m2+m3+m4/2)*L*thetapp+T3+Fel2-T2-Fel3;
    mod1=abs(yg1)
    fas1=angle(yg1)
    mod2=abs(Fel3)
    fas2=angle(Fel3)
    mod3=abs(HB);
    fas3=angle(HB);
    yimp=yimp+mody(k)*cos(ome*tempo+fasy(k)); 
    ygt1=ygt1+mod1*cos(ome*tempo+fas1); 
    ygt2=ygt2+mod2*cos(ome*tempo+fas2); 
    ygt3=ygt3+mod3*cos(ome*tempo+fas3); 
% figure(10);plot(tempo,yimp);grid;title('Spostamento impresso')
% figure(11);plot(tempo,ygt1);grid;title('Rotazione disco 2')
figure(12);plot(tempo,ygt2);grid;title('Forza elastica molla')
figure(13);plot(tempo,ygt3);grid;title('Reazione orizzontale B')




