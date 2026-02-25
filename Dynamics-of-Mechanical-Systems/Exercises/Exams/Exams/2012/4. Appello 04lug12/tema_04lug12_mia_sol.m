clear all
close all

m1=15;
m2=10;
m3=10;
J1=1.5;
J2=1;
J3=0.7;
L=0.2;
k1=1000;
k2=1000;
k3=500;
k4=2500;
k5=500;
r1=0.5;
r2=0.5;
ymax=0.1;
T=0.73;
g=9.81;
i=sqrt(-1);
nDOFL=2;    %non conta il vincolo impresso

Mph=diag([m1 J1 m2 J2 m3 J3]);
Kph=diag([k1 k2 k3 k4 k5]);
Cph=diag([r1 r2]);

Jm=[3*L 0 0;
    1 0 0;
    0 3*L 0;
    0 1 0;
    0 0 1;
    -1/2 0 1/(2*L)];
Jel=[6*L 0 0;
    0 -6*L 0;
    -6*L 0 2;
    L/2 4*L -3/2;
    -L/2 2*L -1/2];
Jc=[6*L 0 0;
    0 -6*L 0];

Kg=zeros(nDOFL+1,nDOFL+1);
Kg(1,1)=-3*L*m1*g;
Kg(2,2)=-3*L*m2*g;
kII=0;

MM=Jm'*Mph*Jm;
KK=Jel'*Kph*Jel+Kg+kII;
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
%CALCOLARE AUTOVALORI E MODI DEL SISTEMA NON SMORZATO
[eigenvectors, eigenvalues]=eig(MFF\KFF);
freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%.........................................................PUNTO 5+6
%ONDA QUADRA NON SIMMETRICA
t1=T/4;     %cambio di pendenza
y1=3*ymax;  %valore costante iniziale
y2=-ymax;   %valore costante dopo cambio di pendenza

dt=0.001;
vt1=0:dt:t1-dt;
vt2=t1:dt:T-dt;
vy1=ones(1,length(vt1))*y1;% vettore costante unitario per l'ampiezza dell'onda
vy2=ones(1,length(vt2))*y2;
vett_t=[vt1 vt2];
vett_y=[vy1 vy2];
figure;plot(vett_t,vett_y);grid;

%SPETTRO
df=1/T; %frequenza fondamentale
N=length(vett_t);   %campioni del segnale periodico
ff=0:df:df*(N/2-1); %per teorema di Shannon
fftout=fft(vett_y); %controllare che la funzione periodica sia in questo vettore
mody(1)=abs(fftout(1))/N;
mody(2:N/2)=abs(fftout(2:N/2))*2/N; 
fasy(1:N/2)=angle(fftout(1:N/2));
figure
subplot 211;bar(ff,mody);grid
subplot 212;bar(ff,fasy);grid

%INIZIALIZZO LE GRANDEZZE
tempo=0:dt:T;     %dt è il passo con cui ho costruito il segnale
np=length(tempo);   %numero di campioni
yimp=zeros(1,np);
vett_theta=zeros(1,np);
vett_Ta=zeros(1,np);
vett_Ta2=zeros(1,np);

for iarm=1:length(mody)
   ome=2*pi*ff(iarm);
   y0=mody(iarm)*exp(i*fasy(iarm));  %singola armonica dell'ingresso
   A=-ome^2*MFF+i*ome*CFF+KFF;
   Qfc=-(-ome^2*MFC+i*ome*CFC+KFC)*y0;
   x=A\Qfc;
   theta=x(1);
   
   xG1=3*L*x(1);
   xG1dd=-ome^2*xG1;
   thetadd=-ome^2*theta;
   Fel1=(k1+i*ome*r1)*6*L*x(1);
   Fel3=k3*(-6*L*x(1)+2*y0);
   Ta=3*m1*xG1dd-5*Fel3+6*Fel1+J1*thetadd/L-3*m1*g*x(1);
   
   yimp=yimp+mody(iarm)*cos(ome*tempo+fasy(iarm));
   vett_theta=vett_theta+abs(theta)*cos(ome*tempo+angle(theta));
   vett_Ta=vett_Ta+abs(Ta)*cos(ome*tempo+angle(Ta));
   vett_Ta2=vett_Ta2+abs(Ta2)*cos(ome*tempo+angle(Ta2));
end

figure;plot(tempo,yimp);grid
figure;plot(tempo,vett_theta);grid;title('theta')
figure;plot(tempo,vett_Ta);grid;title('Ta')

