clear all
close all

m1=10;
J1=0.2;
m2=5;
J2=0.5;
m3=10;
J4=0.01;
L=0.5;
R2=0.5;
R4=0.1;
g=9.81;
k1=1000;
k2=2000;
k3=1000;
r1=1;
r2=2;
r3=1;
ome_pt6=10.2;
C01=2;
C02=1;

mf=diag([m1 J1 m2 J2 m3 J4]);
rf=diag([r1 r2 r3]);
kf=diag([k1 k2 k3]);

Jm=[-L 0 1;1 0 0;0 R4 0;0 2*R4/R2 0;0 R4 0;0 1 0];
Jel=[-L 0 1; 2*L -R4 -1;L 3*R4 -1];

Kg=zeros(3,3);Kg(1,1)=m1*g*L;
M=Jm'*mf*Jm;
R=Jel'*rf*Jel;
K=Jel'*kf*Jel+Kg;

MLL=M(1:2,1:2);
RLL=R(1:2,1:2);
KLL=K(1:2,1:2);

MVL=M(3,1:2);
RVL=R(3,1:2);
KVL=K(3,1:2);

[eigenmodes, eigenvalue]=eig(MLL\KLL);
eigenmodes
freq=sqrt(diag(eigenvalue))/2/pi

%........................................................PUNTO 3

i=sqrt(-1);
vett_f=0:0.01:10;
Q=[1;0];
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*MLL+i*ome*RLL+KLL;
   x=A\Q;
   sC=R4*x(2);
   mod1(k)=abs(sC);
   fas1(k)=angle(sC);
   mod2(k)=abs(x(1));
   fas2(k)=angle(x(1));
end
    
figure
subplot 211;plot(vett_f,mod1);grid;title('FdT x2 con C01=1')
subplot 212;plot(vett_f,fas1);grid
    
figure
subplot 211;plot(vett_f,mod2);grid;title('FdT tetha')
subplot 212;plot(vett_f,fas2);grid

%............................................PUNTO 4

Q=[0;2*R4/R2];
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*MLL+i*ome*RLL+KLL;
   x=A\Q;
   sr=2*R4*x(2);
   mod1(k)=abs(x(1));
   fas1(k)=angle(x(1));
   mod2(k)=abs(sr);
   fas2(k)=angle(sr);
end
    
figure
subplot 211;plot(vett_f,mod1);grid;title('FdT 3')
subplot 212;plot(vett_f,fas1);grid
    
figure
subplot 211;plot(vett_f,mod2);grid;title('FdT 4')
subplot 212;plot(vett_f,fas2);grid

%...........................................PUNTO 5
%scrivo la reazione vincolare con la dinamica

Q=[1;0];
C01=1;
for k=1:length(vett_f)
   ome=2*pi*vett_f(k);
   A=-ome^2*MLL+i*ome*RLL+KLL;
   x=A\Q;
   thetapp=-ome^2*x(1);
   dL1=-L*x(1);
   dL2=2*L*x(1)-R4*x(2);
   dL3=L*x(1)+3*R4*x(2);
   Fel1=(k1+i*ome*r1)*dL1;
   Fel2=(k2+i*ome*r2)*dL2;
   Fel3=(k3+i*ome*r3)*dL3;
   Rx=Fel1-(Fel2+Fel3+m1*L*thetapp);
   mod1(k)=abs(Rx);
   fas1(k)=angle(Rx);
end
    
figure
subplot 211;plot(vett_f,mod1);grid;title('Rx')
subplot 212;plot(vett_f,fas1);grid

%........................................... PUNTO 6

T=5*(2*pi/ome_pt6);     %considero 5 periodi
vett_t=0:0.01:T;
A1=-ome_pt6^2*MLL+i*ome_pt6*RLL+KLL;
A2=-(3*ome_pt6)^2*MLL+i*3*ome_pt6*RLL+KLL;  %le coppie hanno due freq diverse
Q1=[1;0]*C01;
Q2=[0;2*R4/R2]*C02;
x1=A1\Q1;
x2=A2\Q2;
alfa1=2*R4*x1(2)/R2;    %alpha dovuta alla prima forza
alfa2=2*R4*x2(2)/R2;    %alpha dovuta alla seconda forza
alfapp1=-ome_pt6^2*alfa1;
alfapp2=-(3*ome_pt6)^2*alfa2;
vett_alfa1=abs(alfa1)*cos(ome_pt6*vett_t+angle(alfa1));
vett_alfa2=abs(alfa2)*cos(3*ome_pt6*vett_t+angle(alfa2));
vett_alfapp1=abs(alfapp1)*cos(ome_pt6*vett_t+angle(alfapp1));
vett_alfapp2=abs(alfapp2)*cos(3*ome_pt6*vett_t+angle(alfapp2));
vett_alfa=vett_alfa1+vett_alfa2;        %sommo gli effetti delle due forze
vett_alfapp=vett_alfapp1+vett_alfapp2;

figure;plot(vett_t,vett_alfa);grid
figure;plot(vett_t,vett_alfapp);grid
