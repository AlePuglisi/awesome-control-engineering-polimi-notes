clear all
close all

m1=10;
J1=0.8;
L1=0.5;
m2=15;
J2=2.5;
L2=0.75;
m3=10;
J3=0.3;
R=0.25;
g=9.81;
k1=1000;
k2=2000;
k3=1000;
r1=3;
r2=2;
r3=1;
T=0.28;
t1=0.02;
y1=0.1;

mf=diag([m1 J1 m2 J2 m3 J3]);
rf=diag([r1 r2 r3]);
kf=diag([k1 k2 k3]);

Jm=[L1 0 0;
    1 0 0;
    2*L1 L2 0;
    0 1 0;
    0 0 1;
    2*L1/R 2*L2/R -1/R];
Jel=[L1 0 0; 
    2*L1 2*L2 0;
    -4*L1 -(4*L2-2*R) 2];

Kg=zeros(3,3);
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

%....................................................... PUNTO 3

vett_f=0:0.01:5;
omega=vett_f*2*pi;
vett_Q=[2*L1/R;2*L2/R];
for k=1:length(vett_f)
    A=-omega(k)^2*MLL+i*omega(k)*RLL+KLL;
    x=A\vett_Q;
    yg1=L1*x(1);
    yg2=2*L1*x(1)+L2*x(2);
    mod1(k)=abs(yg1);
    fas1(k)=angle(yg1);
    mod2(k)=abs(yg2);
    fas2(k)=angle(yg2);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('yg1/C')
subplot 212;plot(vett_f,fas1*180/pi);grid

figure
subplot 211;plot(vett_f,mod2);grid;title('yg2/C')
subplot 212;plot(vett_f,fas2*180/pi);grid

%........................................................PUNTO 4

y0=1;
for k=1:length(vett_f)
    A=-omega(k)^2*MLL+i*omega(k)*RLL+KLL;
    Q=-(-omega(k)^2*MLV+i*omega(k)*RLV+KLV)*y0; %Q=Qfc
    x=A\Q;
    phi=(2*L1*x(1)+2*L2*x(2))/R-y0/R;
    Fel1=L1*x(1)*k1;
    mod1(k)=abs(phi);
    fas1(k)=angle(phi);
    mod2(k)=abs(Fel1);
    fas2(k)=angle(Fel1);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('phi/y')
subplot 212;plot(vett_f,fas1*180/pi);grid

figure
subplot 211;plot(vett_f,mod2);grid;title('Fel1/y')
subplot 212;plot(vett_f,fas2*180/pi);grid

%....................................................PUNTO 5+6

%costruisco lo spostamento periodico
dt=0.001;
m=y1/t1;
t2=T/2-t1;
t3=T/2+t1;
t4=T-t1;
vt1=0:dt:t1-dt;
vt2=t1:dt:t2-dt;
vt3=t2:dt:t3-dt;
vt4=t3:dt:t4-dt;
vt5=t4:dt:T-dt;
vy1=m*vt1;
vy2=ones(1,length(vt2))*y1;
vy3=y1-m*(vt3-t2);
vy4=-ones(1,length(vt4))*y1;
vy5=-y1+m*(vt5-t4);
vett_t=[vt1 vt2 vt3 vt4 vt5];
vett_y=[vy1 vy2 vy3 vy4 vy5];
figure;plot(vett_t,vett_y);grid;axis([0 T -0.15 0.15])

%scompongo con Fourier
df=1/T;
N=length(vett_t);
vett_f=0:df:df*(N/2-1); %teorema di Shannon
g=fft(vett_y);
mody(1)=abs(g(1))/N;
mody(2:N/2)=abs(g(2:N/2))*2/N;
fasy(1:N/2)=angle(g(1:N/2));
%rappresento lo spettro
figure
subplot 211;bar(vett_f,mody);grid
subplot 212;bar(vett_f,fasy);grid

tempo=0:dt:T;
np=length(tempo);
%inizializzo le grandezze di cui voglio la storia temporale
yimp=zeros(1,np);
th1=zeros(1,np);
th2=zeros(1,np);
Rvth=zeros(1,np);
Rvth2=zeros(1,np);
for k=1:N/2
    ome=2*pi*vett_f(k);
    A=-ome^2*MLL+j*ome*RLL+KLL;
    x=-inv(A)*(-ome^2*MLV+j*ome*RLV+KLV)*mody(k)*exp(j*fasy(k));    %uso Qfc
    yimp=yimp+mody(k)*cos(ome*tempo+fasy(k));       %spostamento imposto calcolato come somma di armoniche
    th1=th1+abs(x(1))*cos(ome*tempo+angle(x(1)));
    th2=th2+abs(x(2))*cos(ome*tempo+angle(x(2)));
    thpp1=-ome^2*x(1);
    Rv=(m1*L1^2+J1)*thpp1/2/L1+(k1+j*ome*r1)*L1*x(1)/2; %calcolata con la dinamica
    %Rv2=(k1+i*ome*r1)*L1*x(1)-m1*ome^2*L1*x(1);    altro modo per calcolare Rv
    Rvth=Rvth+abs(Rv)*cos(ome*tempo+angle(Rv));
    %Rvth2=Rvth2+abs(Rv2)*cos(ome*tempo+angle(Rv2));
end

figure;plot(tempo,yimp);grid
figure;plot(tempo,th1);grid;title('ecco')
figure;plot(tempo,th2);grid
figure;plot(tempo,Rvth);grid
%figure;plot(tempo,Rvth,tempo,Rvth2);grid

