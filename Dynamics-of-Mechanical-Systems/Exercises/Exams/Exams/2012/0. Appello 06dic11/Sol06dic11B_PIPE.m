clear all
%close all

m1=10;
m2=15;
m3=10;
J1=0.8;
J2=2.5;
J3=0.3;
k1=1000;
k2=2000;
k3=1000;
r1=3;
r2=2;
r3=1;
L1=0.5;
L2=0.75;
R=0.25;
t1=0.02;
T=0.28;
y1=0.1;
g=9.81;


mf=diag([m1 J1 m2 J2 m3 J3]);
rf=diag([r1 r2 r3]);
kf=diag([k1 k2 k3]);


Lm=[L1 0 0;
    1 0 0;
    2*L1 L2 0;
    0 1 0;
    0 0 1;
    2*L1/R 2*L2/R -1/R];
Lr=[L1 0 0;
    2*L1 2*L2 0;
    -4*L1 -4*L2+2*R 2];
Lk=Lr;
Kg=[m1*g*L1+m2*g*2*L1 0 0;
    0 m2*g*L2 0;
    0 0 0];
   
MM=Lm'*mf*Lm;
RR=Lr'*rf*Lr;
KK=Lk'*kf*Lk+Kg;

MLL=MM(1:2,1:2);
MLV=MM(1:2,3);
MVL=MM(3,1:2);
MVV=MM(3,3);

RLL=RR(1:2,1:2);
RLV=RR(1:2,3);
RVL=RR(3,1:2);
RVV=RR(3,3);

KLL=KK(1:2,1:2);
KLV=KK(1:2,3);
KVL=KK(3,1:2);
KVV=KK(3,3);


[modi,vettl]=eig(MLL\KLL);
modi
autov=diag(vettl);
puls=sqrt(autov);
freqpr=puls/2/pi

i=sqrt(-1);
C0=1;
Qc=[2*L1/R;2*L2/R]*C0;
ff=0:0.01:5;

for k=1:length(ff)
    omF=2*pi*ff(k);
    A=-omF^2*MLL+RLL*i*omF+KLL;
    x=A\Qc;
    
    xg1=L1*x(1);
    xg2=2*L1*x(1)+L2*x(2);
    
    mod1(k)=abs(xg1);
    fas1(k)=angle(xg1);
    
    mod2(k)=abs(xg2);
    fas2(k)=angle(xg2);
    
  
end


figure
subplot 211; plot(ff,mod1);xlabel('f(Hz)');ylabel('deg/N');title('Rotazione O1/C0')
grid on
subplot 212; plot(ff,fas1);xlabel('f(Hz)');ylabel('deg')
grid on

figure
subplot 211; plot(ff,mod2);xlabel('f(Hz)');ylabel('deg/N');title('Rotazione O2/C0')
grid on
subplot 212; plot(ff,fas2);xlabel('f(Hz)');ylabel('deg')
grid on



y0=1;
ff=0:0.01:5;

for k=1:length(ff)
    omF=2*pi*ff(k);
    A=-omF^2*MLL+i*omF*RLL+KLL;
    Q=-(-omF^2*MLV+i*omF*RLV+KLV)*y0;
    x=A\Q;
    
    w3=(2*L1*x(1)+2*L2*x(2))/R-y0/R;
    Fel1=L1*x(1)*k1;
    
    mod7(k)=abs(w3);
    fas7(k)=angle(w3);
    mod9(k)=abs(Fel1);
    fas9(k)=angle(Fel1);
end

figure
subplot 211; plot(ff,mod7);xlabel('f(Hz)');ylabel('deg/m');title('Rotazione/y0')
grid on
subplot 212; plot(ff,fas7*180/pi);xlabel('f(Hz)');ylabel('deg')
grid on

figure
subplot 211; plot(ff,mod9);xlabel('f(Hz)');ylabel('N/m');title('Forza elastica/y0')
grid on
subplot 212; plot(ff,fas9);xlabel('f(Hz)');ylabel('deg')
grid on




dt=0.001;

t2=T/2-t1;
t3=T/2+t1;
t4=T-t1;
t5=T;

vt1=0:dt:t1-dt;
vt2=t1:dt:t2-dt;
vt3=t2:dt:t3-dt;
vt4=t3:dt:t4-dt;
vt5=t4:dt:T-dt;

vy1=(y1/t1)*vt1;
vy2=ones(1,length(vt2))*y1;
vy3=y1-y1/t1*(vt3-t2);
vy4=-y1*ones(1,length(vt4));
vy5=-y1+y1/(T-t4)*(vt5-t4);

vett_t=[vt1 vt2 vt3 vt4 vt5];
vett_y=[vy1 vy2 vy3 vy4 vy5];

figure
plot(vett_t,vett_y);grid on;axis([0 T -0.5 0.15]);xlabel('t');ylabel('m');title('Spostamento periodico')


df=1/T;
N=length(vett_t);
vett_f=0:df:df*(N/2-1);
g=fft(vett_y);
mody(1)=abs(g(1))/N;
mody(2:N/2)=abs(g(2:N/2))*2/N;
fasy(1:N/2)=angle(g(1:N/2));

figure
subplot 211;bar(vett_f,mody);grid;xlabel('[Hz]');ylabel('m');title('Trasformata spostamento periodico')
subplot 212;bar(vett_f,fasy);grid;xlabel('[Hz]');ylabel('deg')



tt=0:dt:2*T;
i=sqrt(-1);
w1=zeros(1,length(tt));
w2=zeros(1,length(tt));
Rat=zeros(1,length(tt));

for k=1:N/2
    omF=2*pi*vett_f(k);
    A=-omF^2*MLL+i*omF*RLL+KLL;
    Q=-(-omF^2*MLV+i*omF*RLV+KLV)*mody(k)*exp(i*fasy(k));
    x=A\Q;
    
    w1=w1+abs(x(1))*cos(omF*tt+angle(x(1)));
    w2=w2+abs(x(2))*cos(omF*tt+angle(x(1)));
    
   % Ra=((m1*L1^2+J1)/(2*L1)*(-omF^2*x(1))+(k1+r1*i*omF)*(L1*x(1))/(2*L1))+2*m2*g*x(1)*L1/(2*L1)+m1*g*L1/(2*L1);
   % Ra=(m1*L1^2+J1)/(2*L1)*(-omF^2*x(1))+(k1+r1*i*omF)*(L1*x(1))/(2*L1)+2*m2*g*x(1)*L1/(2*L1)+m1*g*L1*x(1)/(2*L1);
%    Ra=(m1*L1*x(1)*(-omF^2)+2*m2*g*x(1)+(k1+i*r1*omF)*L1*x(1))/2+m1*g*x(1)/2+J1*L1*x(1)*(-omF^2)/(2*L1);
%    Rat=Rat+abs(Ra)*cos(omF*tt+angle(Ra));
end


figure
plot(tt,w1);grid;xlabel('t');ylabel('deg');title('Storia temporale w1')
figure
plot(tt,w2);grid;ylabel('deg');title('Storia temporale w1')
figure
plot(tt,Rat);grid;ylabel('deg');title('Storia temporale w1')