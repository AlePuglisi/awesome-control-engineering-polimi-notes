clear all
close all

m1=25;				
m2=10;			
J1=2;				
J2=0.25;         	
R=0.25;         
L=1.0;			
k1=2e3; 	    
k2=2e3; 	    
k3=4e3; 	    
c1=10;   		
c2=2;   		
c3=2;   		
g=9.81;

mph=diag([m1 m1 2*J1 m2 J2]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[L/2 0;
   -L/2 0;
    1 0;
    0 1;
    L/R 1/R];
Lk=[L/2 0;
    3/2*L 2;
    0 -1];
Lc=Lk;
Lq=[-L/R -1/R];

Kg=zeros(2,2);
Kg(1,1)=-m1*g*L/2;
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
    yb=L*theta;
    phi=L/R*theta+x/R;
    dL3=-x;
    Fel3=(k3+i*ome*c3)*dL3;
    xg1=-L/2*theta;
    xdd=-ome^2*x;
    xg1dd=-ome^2*xg1;
    HO=m1*xg1dd+m2*xdd-Fel3;
    mod1(k)=abs(yb);
    phase1(k)=angle(yb);
    mod2(k)=abs(phi);
    phase2(k)=angle(phi);
    mod3(k)=abs(HO);
    phase3(k)=angle(HO);
end

figure
subplot 211;plot(vett_f,mod1);grid;xlabel('[Hz]');ylabel('[m/Nm]');title('yb/C0')
subplot 212;plot(vett_f,phase1);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod2);grid;xlabel('[Hz]');ylabel('[rad/Nm]');title('phi/C0')
subplot 212;plot(vett_f,phase2);grid;xlabel('[Hz]');ylabel('[rad]')
figure
subplot 211;plot(vett_f,mod3);grid;xlabel('[Hz]');ylabel('[N/Nm]');title('HO/C0')
subplot 212;plot(vett_f,phase3);grid;xlabel('[Hz]');ylabel('[rad]')


