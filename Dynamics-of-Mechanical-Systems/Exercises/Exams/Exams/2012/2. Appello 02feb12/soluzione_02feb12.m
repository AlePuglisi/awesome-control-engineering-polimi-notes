clear all
%close all

m1=10;
J1=0.8;
L1=0.5;
m2=15;
J2=2.5;
L2=0.75;
g=9.81;
k1=1000;
k2=2000;
r1=3;
r2=2;
alfa=pi/3;
F0=100;
T=0.5;

mf=diag([m1 J1 m2 m2 J2]);
rf=diag([r1 r2]);
kf=diag([k1 k2]);

Jm=[L1 0;
    1 0;
    2*L1 0;
    0 L2;
    0 1];
Jel=[2*L1 0; 
    0 2*L2];

Kg=zeros(2,2);KII=zeros(2,2);
Kg(1,1)=m1*g*L1+2*m2*g*L1;
dL02=-m2*g/(2*k2);
KII(1,1)=2*k2*L1*dL02;
MLL=Jm'*mf*Jm;
RLL=Jel'*rf*Jel;
KLL=Jel'*kf*Jel+Kg+KII;

[modi autov]=eig(MLL\KLL);
freq=sqrt(diag(autov))/2/pi
modi

%....................................................... PUNTO 3

vett_f=0:0.01:5;
omega=vett_f*2*pi;
vett_Q=[2*L1*cos(alfa);L2*sin(alfa)];
for k=1:length(vett_f)
    A=-omega(k)^2*MLL+i*omega(k)*RLL+KLL;
    x=A\vett_Q;
    xb=2*L1*x(1);
    yb=2*L2*x(2);
    mod1(k)=abs(xb);
    fas1(k)=angle(xb);
    mod2(k)=abs(yb);
    fas2(k)=angle(yb);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('xb/F')
subplot 212;plot(vett_f,fas1*180/pi);grid

figure
subplot 211;plot(vett_f,mod2);grid;title('yb/F')
subplot 212;plot(vett_f,fas2*180/pi);grid

%.......................................................... PUNTO 4

y0=1;
vett_Q=[2*L1;0];        %Fy diverso da 0 e F=0
for k=1:length(vett_f)
    A=-omega(k)^2*MLL+i*omega(k)*RLL+KLL;
    Fy=(k1+i*omega(k)*r1)*y0;       %DEVO FARE COSI' XKE NON HO MESSO Y COME DOF, Fy è la forza della molla/smorzatore su cui agissce il vincolo imposto
    Q=vett_Q*Fy;
    x=A\Q;
    Fel2=2*L2*x(2)*(k2+i*omega(k)*r2);  %forza elastica 2
    mod1(k)=abs(x(1));
    fas1(k)=angle(x(1));
    mod2(k)=abs(Fel2);
    fas2(k)=angle(Fel2);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('theta1/y')
subplot 212;plot(vett_f,fas1*180/pi);grid

figure
subplot 211;plot(vett_f,mod2);grid;title('Fel2/y')
subplot 212;plot(vett_f,fas2*180/pi);grid

%...................................................... PUNTO 5+6

%costruisco la forzante periodica
dt=0.001;
m=F0/(T/2);
vt1=0:dt:T/2-dt;
vt2=T/2+dt:dt:T-dt;
vy1=m*vt1;
vy2=-F0+m*(vt2-T/2);
vett_t=[vt1 T/2 vt2];
vett_y=[vy1 0 vy2];
figure;plot(vett_t,vett_y);grid;

%scompongo la forza con Fourier (si fa sempre così)
df=1/T; %frequenza fondamentale
N=length(vett_t);
vett_f=0:df:df*(N/2-1); %teorema di Shannon
g=fft(vett_y);
mody(1)=abs(g(1))/N;
mody(2:N/2)=abs(g(2:N/2))*2/N;  %raddoppio perchè lo spettro è pari per cui ho due armoniche uguali a -f e +f, per cui ne tengo solo una ma di modulo doppio
fasy(1:N/2)=angle(g(1:N/2));
%rappresento lo spettro
figure
subplot 211;bar(vett_f,mody);grid
subplot 212;bar(vett_f,fasy);grid

tempo=0:dt:T;
np=length(tempo);
%inizializzo le grandezze di cui voglio disegnare la storia temporale
f=zeros(1,np);  %prendo anche la forza per vedere come cambia quando la approssimo con Fourier
th2=zeros(1,np);
Rv=zeros(1,np);
vett_Q=[2*L1*cos(alfa);L2*sin(alfa)];
for k=1:N/2     %prendo tutte le armoniche
    ome=2*pi*vett_f(k);
    A=-ome^2*MLL+j*ome*RLL+KLL;
    x=A\vett_Q*mody(k)*exp(j*fasy(k));      %vett_Q l'ho definito senza la forza F0, che devo scrivere come somma di armoniche
    f=f+mody(k)*cos(ome*tempo+fasy(k));     %riscrivo la forza sommando ad ogni giro una componente armonica in più
    th2=th2+abs(x(2))*cos(ome*tempo+angle(x(2)));   %storia temporale di theta2
    yppg2=-ome^2*L2*x(2);       %accelerazione di G2. Viene da Yg2=L2*theta2
    dL2=2*L2*x(2);              %allungamento 2
    Rvd=-mody(k)*exp(j*fasy(k))*sin(alfa)+m2*yppg2+(k2+j*ome*r2)*dL2;   %Reazione vincolare dinamica (SENZA FORZE PESO!)
    Rv=Rv+abs(Rvd)*cos(ome*tempo+angle(Rvd)); 
end

figure;plot(tempo,f);grid
figure;plot(tempo,th2);grid
figure;plot(tempo,Rv);grid



