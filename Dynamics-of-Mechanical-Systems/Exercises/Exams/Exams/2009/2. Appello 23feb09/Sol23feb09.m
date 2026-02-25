clear all
close all

m1=5;
m2=5;
m3=5;
J1=0.5;
J2=0.5;
J3=0.5;
k1=1000;
k2=1000;
k3=3000;
r1=0.5;
r2=0.5;
r3=50;
R1=0.2;
L2=0.6;
L3=0.6;
g=9.81;


mf=diag([J1 m2 J2 m3 J3]);
rf=diag([r1 r2 r3]);
kf=diag([k1 k2 k3]);


Lm=[-2*L3/R1 0 -1/R1;
    0 L2 0;
    0 1 0;
    L3 0 1;
    1 0 0];

Lr=[2*L3 2*L2 1;
    -2*L3 -2*L2 -1;
    L3 0 1];
Lk=Lr;
Kg=[0 0 0;
    0 L2*m2*g 0;
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

%...................................................PUNTO 3

i=sqrt(-1);
C0=1;
Qc=[1;0]*C0;
ff=0:0.001:10;
for k=1:length(ff)
    ome=2*pi*ff(k);
    A=-ome^2*MLL+RLL*i*ome+KLL;
    x=A\Qc;
    om1=-2*L3/R1*x(1);  %non metto la dipendenza dal vincolo imposto
    mod2(k)=abs(x(2));
    fas2(k)=angle(x(2));
    mod3(k)=abs(om1);
    fas3(k)=angle(om1);
end

figure
subplot 211; plot(ff,mod2);xlabel('f(Hz)');ylabel('deg/N');title('Rotazione pendolo CD/C0')
grid on
subplot 212; plot(ff,fas2);xlabel('f(Hz)');ylabel('deg')
grid on

figure
subplot 211; plot(ff,mod3);xlabel('f(Hz)');ylabel('deg/N');title('Rotazione disco/C0')
grid on
subplot 212; plot(ff,fas3);xlabel('f(Hz)');ylabel('deg')
grid on

%..........................................................PUNTO 4

i=sqrt(-1);
F0=1;
Qf=[0;L2]*F0;
ff=0:0.001:10;
for k=1:length(ff)
    ome=2*pi*ff(k);
    A=-ome^2*MLL+RLL*i*ome+KLL;
    x=A\Qf;
    xe=L2*x(2);
    mod4(k)=abs(x(1));
    fas4(k)=angle(x(1));
    mod5(k)=abs(xe);
    fas5(k)=angle(xe);
end

figure
subplot 211; plot(ff,mod4);xlabel('f(Hz)');ylabel('deg/N');title('Rotazione asta AB/F0')
grid on
subplot 212; plot(ff,fas4);xlabel('f(Hz)');ylabel('deg')
grid on

figure
subplot 211; plot(ff,mod5);xlabel('f(Hz)');ylabel('m/N');title('Spostamento orizzontale E/F0')
grid on
subplot 212; plot(ff,fas5);xlabel('f(Hz)');ylabel('deg')
grid on

%........................................................PUNTO 5+6

y0=1;
xv=[y0];
ff=0:0.001:10;
for k=1:length(ff)
    ome=2*pi*ff(k);
    A=-ome^2*MLL+ome*i*RLL+KLL;
    Q=-(-ome^2*MLV+ome*i*RLV+KLV)*xv;   %Q=Qfc
    x=A\Q;
    Qc=(-ome^2*MVL+ome*i*RVL+KVL)*x+(-ome^2*MVV+i*RVV*ome+KVV)*xv;
    T=k1*(2*L3*x(1)+2*L2*x(2)+1*xv)+r1*(2*L3*x(1)+2*L2*x(2)+1*xv);
    mod7(k)=abs(x(1));
    fas7(k)=angle(x(1));
    mod8(k)=abs(x(2));
    fas8(k)=angle(x(2));
    mod10(k)=abs(Qc);   %la reazione vincolare che mi chiede è pari a Fy che è uguale a Qc
    fas10(k)=angle(Qc);
    mod12(k)=abs(T);
    fas12(k)=angle(T);
end

figure
subplot 211; plot(ff,mod7);xlabel('f(Hz)');ylabel('deg/N');title('Rotazione asta AB/y0')
grid on
subplot 212; plot(ff,fas7);xlabel('f(Hz)');ylabel('deg')
grid on

figure
subplot 211; plot(ff,mod8);xlabel('f(Hz)');ylabel('deg/N');title('Rotazione pendolo/y0')
grid on
subplot 212; plot(ff,fas8);xlabel('f(Hz)');ylabel('deg')
grid on

figure
subplot 211; plot(ff,mod10);xlabel('f(Hz)');ylabel('N/N');title('Reazione vincolare spostamento impresso/y0')
grid on
subplot 212; plot(ff,fas10);xlabel('f(Hz)');ylabel('deg')
grid on

figure
subplot 211; plot(ff,mod12);xlabel('f(Hz)');ylabel('N/m');title('Tiro T/y0')
grid on
subplot 212; plot(ff,fas12);xlabel('f(Hz)');ylabel('deg')
grid on