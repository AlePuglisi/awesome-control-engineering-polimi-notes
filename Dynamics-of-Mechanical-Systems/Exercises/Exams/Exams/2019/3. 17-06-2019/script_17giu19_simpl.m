clear all
close all

m1=10;
m2=5;
m3=3;
J3=0.01;
L=0.25;
g=9.81;
k1=1000;
k2=1000;
k3=1000;
c1=1;
c2=1;
c3=1;

mph=diag([m1 m2 m1 m3 J3]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[1 -3*L;1 0 ;1 -L;1 -1.5*L;0 1];
Lk=[1 -3*L;0 2*L;-1 L];
Lq=[1 -3*L;1 -L;1 -3*L];

Kg=zeros(2,2);Kg(2,2)=-1.5*m3*g*L;
M=Lm'*mph*Lm;
C=Lk'*cph*Lk;
K=Lk'*kph*Lk+Kg;

[modes eigenvalues]=eig(M\K);
freq=sqrt(diag(eigenvalues))/2/pi
modes

i=sqrt(-1);
vett_f=0:0.01:5;
F01=1;
F=[-F01; F01; 0];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    x=x0(1);
    theta=x0(2);
    mod1(k)=abs(x);
    fas1(k)=angle(x);
    mod2(k)=abs(theta);
    fas2(k)=angle(theta);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('x m2/F01')
subplot 212;plot(vett_f,fas1*180/pi);grid

figure
subplot 211;plot(vett_f,mod2);grid;title('theta/F01')
subplot 212;plot(vett_f,fas2*180/pi);grid

F02=1;
F=[0; 0; F02];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    x=x0(1);
    theta=x0(2);
    dL2=2*L*theta;
    Fel2=(k2+i*ome*c2)*dL2;
    xa=x-3*L*theta;
    dL1=x-3*L*theta;
    Fel1=(k1+i*ome*c1)*dL1;
    xs=xa;
    xpps=-ome^2*xs;
    T=Fel1-Fel2+m1*xpps;
    mod1(k)=abs(Fel2);
    fas1(k)=angle(Fel2);
    mod2(k)=abs(xa);
    fas2(k)=angle(xa);
    mod3(k)=abs(T);
    fas3(k)=angle(T);
end

figure
subplot 211;plot(vett_f,mod1);grid;title('Fel2/F02')
subplot 212;plot(vett_f,fas1*180/pi);grid

figure
subplot 211;plot(vett_f,mod2);grid;title('xA/F02')
subplot 212;plot(vett_f,fas2*180/pi);grid

figure
subplot 211;plot(vett_f,mod3);grid;title('T/F02')
subplot 212;plot(vett_f,fas3*180/pi);grid


