clear all
close all

m1=15;
m2=10;
J1=1.5;
J2=1.0;
L=0.2;
k1=1000;
k2=2500;
k3=500;
k4=500;
c1=0.5;
c2=0.5;
c3=0.5;
c4=0.5;
g=9.81;

mph=diag([m1 J1 m2 J2]);
cph=diag([c1 c2 c3 c4]);
kph=diag([k1 k2 k3 k4]);

Lm=[-3*L 0;
      1 0;
      0  1;
    -0.5 -1/(2*L)];
Lk=[-6*L 0; 
     6*L 2;
     -L/2 -1.5;
      L/2 -0.5];
Lc=Lk;
Lq=[ -0.5 -1/(2*L)];

Kg=zeros(2,2);
Kg(1,1)=-m1*g*3*L;
M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+Kg;

[modi autov]=eig(M\K);
freq=sqrt(diag(autov))/2/pi
modi'


i=sqrt(-1);
vett_f=0:0.01:10;
C0=1; 
F=[C0];
Q0=Lq'*F;
for k=1:length(vett_f)
    ome=2*pi*vett_f(k);
    A=-ome^2*M+i*ome*C+K;
    x0=A\Q0;
    theta=x0(1);
    x=x0(2);
    phi=-0.5*theta-x/(2*L);
    dL2=6*L*theta+2*x;
    dL3=-L/2*theta-1.5*x;
    dL4=L/2*theta-0.5*x;
    Fel2=(k2+i*ome*c2)*dL2;
    Fel3=(k3+i*ome*c3)*dL3;
    Fel4=(k4+i*ome*c4)*dL4;
    xdd=-ome^2*x;
    T_AE=Fel3+Fel4-Fel2-m2*xdd;
    mod1(k)=abs(theta);
    phase1(k)=angle(theta);
    mod2(k)=abs(phi);
    phase2(k)=angle(phi);
    mod3(k)=abs(T_AE);
    phase3(k)=angle(T_AE);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[rad/Nm]');title('theta/C0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[rad/Nm]');title('phi/C0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/Nm]');title('T_AE/C0')
subplot 212;plot(vett_f,phase3);grid;xlabel('[Hz]');ylabel('[rad]')


