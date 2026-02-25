clear all
close all

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
k3=1000;
r1=2;
r2=1;
r3=1;
T=1.2;
y1=0.1;

mf=diag([m1 m2 J2 m3 J3 m4 J4]);
rf=diag([r1 r2 r3]);
kf=diag([k1 k2 k3]);

Jm=[ 1    0     0;
     1    L     0;
    -1/R2 -L/R2 1/R2;
     1    L     0;
     0   L/R3   0;
     1   L/2    0;
     0    1     0];
Jel=[1   0     0; 
     0  2*L    0;
    -2 -2*L    1];
Kg=zeros(3,3);
Kg(2,2)=(m2+m3+m4/2)*g*L;
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

%modi di vibrare e freq proprie CON SMORZAMENTO
%si fa sempre così!
A1=[MLL zeros(2,2);zeros(2,2) MLL];
B1=[RLL KLL ; -MLL zeros(2,2)];
A=-inv(A1)*B1;
[modid autovd]=eig(A);
freqd=imag(diag(autovd))/2/pi
rrc=-real(diag(autovd))./imag(diag(autovd))
modid

%....................................................PUNTO 4

vett_f=0:0.01:5;
omega=vett_f*2*pi;
vett_Q=[0;L/R3];
for k=1:length(vett_f)
    A=-omega(k)^2*MLL+i*omega(k)*RLL+KLL;
    x=A\vett_Q;
    alpha=-x(1)/R2-x(2)*L/R2;       %non metto y perchè c'è solo la coppia
    Fel3=(k3+i*omega(k)*r3)*(-2*x(1)-x(2)*2*L); %Fel3=(k3+i*omega*r3)*allungamento molla 3
    mod1(k)=abs(alpha);
    fas1(k)=angle(alpha);
    mod2(k)=abs(Fel3);
    fas2(k)=angle(Fel3);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('theta_2/C')
subplot 212;plot(vett_f,fas1*180/pi);grid

figure
subplot 211;plot(vett_f,mod2);grid;title('F3/C')
subplot 212;plot(vett_f,fas2*180/pi);grid

%........................................................PUNTO 5

y0=1;
for k=1:length(vett_f)
    A=-omega(k)^2*MLL+i*omega(k)*RLL+KLL;
    Q=-(-omega(k)^2*MLV+i*omega(k)*RLV+KLV)*y0; %Q=Qfc
    x=A\Q;
    alpha=-x(1)/R2-x(2)*L/R2 + y0/R2;   %qui compare anche la dipendenza da y ma non scrivo x(3) perchè y=y0=1
    Fel3=(k3+i*omega(k)*r3)*(-2*x(1)-x(2)*2*L+y0);  %compare y0
    mod1(k)=abs(alpha);
    fas1(k)=angle(alpha);
    mod2(k)=abs(Fel3);
    fas2(k)=angle(Fel3);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('theta_2/y')
subplot 212;plot(vett_f,fas1*180/pi);grid

figure
subplot 211;plot(vett_f,mod2);grid;title('Fel3/y')
subplot 212;plot(vett_f,fas2*180/pi);grid

%............................................................PUNTO 6+7

%creo spostamento periodico
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
figure(5);plot(vett_t,vett_y);grid;

%scompongo con Fourier
df=1/T;
N=length(vett_t);
vett_f=0:df:df*(N/2-1);
fftout=fft(vett_y);
mody(1)=abs(fftout(1))/N;
mody(2:N/2)=abs(fftout(2:N/2))*2/N;
fasy(1:N/2)=angle(fftout(1:N/2));
%disegno lo spettro
figure(6)
subplot 211;bar(vett_f,mody);grid
subplot 212;bar(vett_f,fasy);grid


tempo=0:dt:T;
np=length(tempo);
%inizializzo tutt e le grandezze che mi interessano
yimp=zeros(1,np);
alpha_tempo=zeros(1,np);
Fel3_tempo=zeros(1,np);
vett_HB=zeros(1,np);
vett_HB2=zeros(1,np);   %altro modo di calcolare la reazione vincolare
C=0;     %COSNIDERO SOLO LO SPOSTAMENTO IMPRESSO E NON LA COPPIA
clear mod1 mod2 fas1 fas2
%considero solo lo spostamento impresso periodico e NON la coppia
for k=1:N/2
    ome=2*pi*vett_f(k);
    y=mody(k)*exp(j*fasy(k));
    A=-ome^2*MLL+j*ome*RLL+KLL;
    x=-inv(A)*(-ome^2*MLV+j*ome*RLV+KLV)*y;     %uso Qfc perchè sto calcolando il contributo dello spostamento impresso
    alpha=-x(1)/R2-x(2)*L/R2+y/R2;
    Fel3=(k3+i*ome*r3)*(-2*x(1)-x(2)*2*L+y);
    thetapp=-x(2)*ome^2;
    betapp=-L/R3*x(2)*ome^2;
    xpp=-x(1)*ome^2;
    dL2=2*L*x(2);
    HB=(m4*L/4-J4/L)*thetapp-(m2+m3+m4/2)*g*x(2);       %non so che cosa sia, ma nel testo non mi è chiesta
    HB2=2*(k2+i*ome*r2)*dL2+(J3*betapp-C)/R3-m1*xpp-(k1+i*ome*r1)*x(1);
    mod1=abs(alpha);
    fas1=angle(alpha);
    mod2=abs(Fel3);
    fas2=angle(Fel3);
    yimp=yimp+mody(k)*cos(ome*tempo+fasy(k));
    alpha_tempo=alpha_tempo+mod1*cos(ome*tempo+fas1);       %sommo i contributi delle varie armoniche per alpha, Fel3 e reazione vincolare
    Fel3_tempo=Fel3_tempo+mod2*cos(ome*tempo+fas2);
    vett_HB=vett_HB+abs(HB)*cos(ome*tempo+angle(HB));
    vett_HB2=vett_HB2+abs(HB2)*cos(ome*tempo+angle(HB2));
end
% figure(7);plot(tempo,yimp);grid;title('Spostamento impresso')
% figure(8);plot(tempo,ygt1);grid;title('Rotazione disco 2')
figure(9);plot(tempo,Fel3_tempo);grid;title('Forza elastica molla')

%ora aggiungo il contributo della coppia armonica
ome=2*pi*1.25;
A=-ome^2*MLL+j*ome*RLL+KLL;
C=25*exp(j*pi/6);
y=0;        %elimino il contributo dello spostamento imposto
x=inv(A)*vett_Q*C;
alpha=-x(1)/R2-x(2)*L/R2+y/R2;
Fel3=(k3+i*ome*r3)*(-2*x(1)-x(2)*2*L+y);
thetapp=-x(2)*ome^2;
betapp=-L/R3*x(2)*ome^2;
xpp=-x(1)*ome^2;
dL2=2*L*x(2);
HB=m4*(xpp+L/2*thetapp)/2-J4/L*thetapp-(m2+m3+m4/2)*g*x(2);
HB2=2*(k2+i*ome*r2)*dL2+(J3*betapp-C)/R3-m1*xpp-(k1+i*ome*r1)*x(1);
mod1=abs(alpha);
fas1=angle(alpha);
mod2=abs(Fel3);
fas2=angle(Fel3);
yimp=yimp+mody(k)*cos(ome*tempo+fasy(k));
alpha_tempo=alpha_tempo+mod1*cos(ome*tempo+fas1);
Fel3_tempo=Fel3_tempo+mod2*cos(ome*tempo+fas2);
vett_HB=vett_HB+abs(HB)*cos(ome*tempo+angle(HB)); 
vett_HB2=vett_HB2+abs(HB2)*cos(ome*tempo+angle(HB2));
% figure(10);plot(tempo,yimp);grid;title('Spostamento impresso')
% figure(11);plot(tempo,ygt1);grid;title('Rotazione disco 2')
figure(12);plot(tempo,Fel3_tempo);grid;title('Forza elastica molla')
figure(13);plot(tempo,vett_HB);grid;title('Reazione orizzontale B')
figure(14);plot(tempo,vett_HB2);grid;title('Reazione orizzontale B (equil. trasl.)')
