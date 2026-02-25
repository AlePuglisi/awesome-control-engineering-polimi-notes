clear all
close all

M1=5;
M2=20;
M3=5;
J1=0.1;
J2=1.5;
J3=0.1;
k1=5e4;
k2=1e3;
r1=10;
r2=2;
L=0.3;
R=0.2;
g=9.81;

%......................................................
% TDE 25 FEBBRAIO 2008

mf=diag([M1 J1 M2 J2 M3 M3 2*J3]);
rf=diag([r1 r2]);
kf=diag([k1 k2]);

%.....................................................
% matrici di trasformazione delle coordinate

Lm=[1 0 0;
    1/R L/R 0;
    1 0 0;
    1/(2*R) 0 0;
    0 L/2 0;
    0 L/2 0;
    0 1 0];

%.....................................................
% questo sopra è lo jacobiano lambda delle masse

Lk=[-1 0 1;
    -2 -L 0];

Lr=Lk;

%.....................................................
%matrici in coordinate indipendenti

MM=Lm'*mf*Lm;
RR=Lr'*rf*Lr;
Kg=zeros(3);
Kg(2,2)=-M3*g*L/2;
KK=Lk'*kf*Lk+Kg;

%.....................................................
% partizione delle matrici

MLL=MM(1:2,1:2);     % 1:2 vuol dire mi prendi la prima e la seconda riga e la prima e la seconda colonna
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


%..................................................
%frequenze proprie e modi di vibrare

[modi, lambda]=eig(MLL\KLL);
modi

vett_lambda=diag(lambda);         
omega=sqrt(vett_lambda);
freq=omega/2/pi


% calcolare la risposta in frequenza della rotazione dell’asta ad L e dello spostamento del centro dei due dischi, per coppia armonica C01 di modulo unitario applicata al disco di massa M1

CO1=1;                               %modulo della forza
Q=[1/R; L/R]*CO1;                    
i=sqrt(-1);                        
ff=0:0.01:10;                       
for k=1:length(ff)                  
    omF=2*pi*ff(k);                 
    A=-omF^2*MLL+i*omF*RLL+KLL;
    x=A\Q;
    mod1(k)=abs(x(2));      
    fas1(k)=angle(x(2));     
    mod2(k)=abs(x(1));               
    fas2(k)=angle(x(1));
end


figure
subplot(211)
plot(ff,mod1)
title('FdT rotazione asta theta/C01')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT spostamento centro disco x/C01')
grid
subplot(212)
plot(ff,fas2)
grid


% calcolare la risposta in frequenza della rotazione dei due dischi per coppia armonica C02 di modulo unitario applicata al disco di massa M2

C02=1;                               %modulo della forza
Q=[1/(2*R); 0]*C02;                    
i=sqrt(-1);                        
ff=0:0.01:10;                       
for k=1:length(ff)                  
    omF=2*pi*ff(k);                 
    A=-omF^2*MLL+i*omF*RLL+KLL;
    x=A\Q;
    PHI=1/R*x(1)+L/R*x(2);
    phi=1/(2*R)*x(1);
    mod1(k)=abs(PHI);      
    fas1(k)=angle(PHI);     
    mod2(k)=abs(phi);               
    fas2(k)=angle(phi);
end


figure
subplot(211)
plot(ff,mod1)
title('FdT rotazione disco M1 PHI/C02')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT rotazione disco M2 phi/C02')
grid
subplot(212)
plot(ff,fas2)
grid


%....calcolare la risposta in frequenza della rotazione dell’asta ad L e dello spostamento del centro dei due dischi per spostamento impresso armonico di modulo unitario y0eit rappresentato nella figura.

y0=1;                               %modulo dello spostamento impresso                    
i=sqrt(-1);                        
ff=0:0.01:10;                       
for k=1:length(ff)                  
    omF=2*pi*ff(k);                 
    A=-omF^2*MLL+i*omF*RLL+KLL;
    x=-A\(-omF^2*MLV+i*omF*RLV+KLV);
    mod1(k)=abs(x(2));      
    fas1(k)=angle(x(2));     
    mod2(k)=abs(x(1));               
    fas2(k)=angle(x(1));
end


figure
subplot(211)
plot(ff,mod1)
title('FdT rotazione asta theta/y0')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('spostamento centro dischi x/y0')
grid
subplot(212)
plot(ff,fas2)
grid

%...calcolare la risposta in frequenza della reazione vincolare corrispondente allo spostamento impresso definito nel punto precedente e della forza di contatto tangenziale scambiata tra disco e guida orizzontale, per effetto dello spostamento impresso stesso.

y0=1;                               %modulo dello spostamento impresso                    
i=sqrt(-1);                        
ff=0:0.01:10;                       
for k=1:length(ff)                  
    omF=2*pi*ff(k);                 
    A=-omF^2*MLL+i*omF*RLL+KLL;
    x=-A\(-omF^2*MLV+i*omF*RLV+KLV);
    Ry=(-omF^2*MVL+i*omF*RVL+KVL)*x+(-omF^2*MVV+i*omF*RVV+KVV);
    T=((-omF^2*(1/R*x(1)+L/R*x(2))*J1)+(-omF^2*1/(2*R)*x(1)*J2))/2*R;
    mod1(k)=abs(Ry);      
    fas1(k)=angle(Ry);
    mod2(k)=abs(T);      
    fas2(k)=angle(T);
end


figure
subplot(211)
plot(ff,mod1)
title('FdT Ry/y0')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT forza di contatto T/y0')
grid
subplot(212)
plot(ff,fas2)
grid
