clear all
close all

M1=15;			% [kg]	
R1=0.3;			% [m]
J1=0.5;			% [kgm2]
M2=60;			% [kg]
M3=15;			% [kg]	
L=0.3;			% [m]
J3=0.5;			% [kgm2]
k1=30e3;	    % [N/m]
k2=30e3;		% [N/m]
k3=30e3;		% [N/m]
r1=10;   		% [Ns/m]
r2=10;   		% Ns/m]
r3=0.5;   		% Ns/m]
alfa=pi/6;
g=9.81;

disp('matrice di massa in coordinate fisiche')
mtx_mf  =  diag([M2 M1 M1 J1 M3 J3])
disp(' ')

disp('matrice di rigidezza (parte elastica) in coordinate fisiche')
mtx_kf  =  diag([k1 k2 k3])
disp(' ')

disp('matrice di smorzamento in coordinate fisiche')
mtx_rf  =  diag([r1 r2 r3])
disp(' ')

disp('jacobiano matrice di massa')
mtx_Jm  =  [1 0 0;1 R1*cos(alfa) 0;0 R1*sin(alfa) 0; 0 1 0;0 0 L;0 0 1]
disp(' ')

disp('jacobiano matrice di rigidezza-smorzamento')
mtx_Jel  =  [0 -R1 0;-1 0 L;0 0 -2*L]
disp(' ')
    
disp('matrice di massa in coordinate indipendenti')
mtx_m  =  mtx_Jm'*mtx_mf*mtx_Jm
disp(' ')

disp('matrice di rigidezza (parte gravitazionale) in coordinate indipendenti')
mtx_kg  =  [0 0 0;0 0 0;0 0 -M3*g*L]
disp(' ')

disp('matrice di rigidezza in coordinate indipendenti')
mtx_k  =  mtx_Jel'*mtx_kf*mtx_Jel + mtx_kg
disp(' ')

disp('matrice di smoramento in coordinate indipendenti')
mtx_r  =  mtx_Jel'*mtx_rf*mtx_Jel
disp(' ')


%calcolo delle frequenze proprie e dei modi di vibrare

[modi,d]=eig(inv(mtx_m)*mtx_k);
fre=sqrt(diag(d))/2/pi;

%crea una matrice temporanea per ordinare frequenze e modi
% i modi sono ordinati per righe
tmp=[fre modi'];

% ordina le frequenze e i modi in ordine crescente 
tmp_out=sortrows(tmp,1);
fre=tmp_out(:,1);                 % frequenze ordinate
ngdl=length(fre);
modi=tmp_out(:,2:ngdl+1)';       % modi ordinati per colonne

% stampa delle frequenze e modi

for i=1:ngdl
    val_max=max(abs(modi(:,i)));
    modi(:,i)=modi(:,i)/val_max;
    disp(['modo # ' num2str(i) ': ' num2str(fre(i)) ' [Hz]        ' num2str(modi(:,i)') ])
end

%......................................................PUNTO 3+5

ff=[0:0.01:20];
ome=2*pi*ff;
vett_F=[1;0;0];
for i=1:length(ff)
    A=-ome(i)^2*mtx_m+j*ome(i)*mtx_r+mtx_k;
    x=inv(A)*vett_F;
    mod1(i)=abs(x(2));
    fas1(i)=angle(x(2));
    mod2(i)=abs(x(3));
    fas2(i)=angle(x(3));
    Rv=-2*L*x(3)*(k3+j*ome(i)*r3);  %reazione vincolare calcolata direttamente con la forza molla/smorzatore
    mod3(i)=abs(Rv);
    fas3(i)=angle(Rv);
end

figure
subplot(211)
plot(ff,mod1)
title('FdT rotazione disco/forza carrello')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT rotazione asta/forza carrello')
grid
subplot(212)
plot(ff,fas2)
grid

figure
subplot(211)
plot(ff,mod3)
title('FdT reazione vincolare/forza carrello')
grid
subplot(212)
plot(ff,fas3)
grid

%.....................................................PUNTO 4

vett_F=[0;0;2*L];
for i=1:length(ff)
    A=-ome(i)^2*mtx_m+j*ome(i)*mtx_r+mtx_k;
    x=inv(A)*vett_F;
    xc=x(1)+R1*x(2);
    xb=2*L*x(3);
    mod1(i)=abs(xc);           
    fas1(i)=angle(xc);          
    mod2(i)=abs(xb);              
    fas2(i)=angle(xb);            
end

figure
subplot(211)
plot(ff,mod1)
title('FdT xc/forza asta')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT xb/forza asta')
grid
subplot(212)
plot(ff,fas2)
grid

%.........................................................PUNTO 6

j=sqrt(-1);
for i=1:length(ff)
    A=-ome(i)^2*mtx_m+j*ome(i)*mtx_r+mtx_k;
    vett_F=[0;0;(k3+j*ome(i)*r3)*2*L];
    x=inv(A)*vett_F;
    mod1(i)=abs(x(2));
    fas1(i)=angle(x(2));
end

figure
subplot(211)
plot(ff,mod1)
title('FdT rotazione disco/spostamento impressso')
grid
subplot(212)
plot(ff,fas1)
grid
