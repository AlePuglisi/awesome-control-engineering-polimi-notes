clear all
close all

M1=15;				
R1=0.3;			
J1=0.5;			
M2=60;			
M3=15;			
L=0.3;			
J3=0.5;			
k1=30e3;	   
k2=30e3;		
k3=30e3;		
c1=10;   		
c2=10;   		
c3=0.5;   		
alfa=pi/6;
g=9.81;

mph  =  diag([M2 M1 M1 J1 M3 J3]);
kph  =  diag([k1 k2 k3]);
cph  =  diag([c1 c2 c3]);

Lm  =  [1 0 0;1 R1*cos(alfa) 0;0 R1*sin(alfa) 0; 0 1 0;0 0 L;0 0 1];
Lk  =  [0 -R1 0;-1 0 L;0 0 -2*L];
Lc=Lk;

Kg3=zeros(3);
Kg3(3,3)=-M3*g*L;

MFF=Lm'*mph*Lm;
KFF=Lk'*kph*Lk + Kg3;
CFF=Lc'*cph*Lc;

%...............................................

[eigenmodes eigenvalues]=eig(MFF\KFF);

freq=sqrt(diag(eigenvalues))/2/pi
eigenmodes

%...............................................

ff=0:0.01:20; 
F0=1;
Q0=[1;0;0]*F0;           
for i=1:length(ff)
    ome=2*pi*ff(i);
    A=-ome^2*MFF+j*ome*CFF+KFF;
    x=A\Q0;
    mod1(i)=abs(x(2));              
    fas1(i)=angle(x(2));            
    mod2(i)=abs(x(3));              
    fas2(i)=angle(x(3));
    dL2=L*x(3)-x(1);
    dL3=-2*L*x(3);
    Fel2=dL2*(k2+j*ome*c2);
    Fel3=dL3*(k3+j*ome*c3);
    xg=L*x(3);
    xgdd=-ome^2*xg;
    HA=Fel2-Fel3+M3*xgdd;
    mod3(i)=abs(Fel2);                
    fas3(i)=angle(Fel2);              
    mod4(i)=abs(HA);                
    fas4(i)=angle(HA);              
end

figure
subplot(211)
plot(ff,mod1)
title('theta/F')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('phi/F')
grid
subplot(212)
plot(ff,fas2)
grid

figure
subplot(211)
plot(ff,mod3)
title('Fel2/F')
grid
subplot(212)
plot(ff,fas3)
grid

figure
subplot(211)
plot(ff,mod4)
title('HA/F')
grid
subplot(212)
plot(ff,fas4)
grid


