clear all
close all

M1=15;			% [kg]	
L=0.3;			% [m]
J1=1.0;			% [kgm2]
M2=30;			% [kg]
R=0.2;			% [m]
J2=2.5;			% [kgm2]
M3=10;			% [kg]	
J3=0.2;			% [kgm2]
k1=20e3;	    % [N/m]
k2=8e3;		% [N/m]
k3=60e3;		% [N/m]
r1=10;   		% [Ns/m]
r2=10;   		% Ns/m]
r3=0.5;   		% Ns/m]
g=9.81;
j=sqrt(-1);

disp('matrice di massa in coordinate fisiche')
mtx_mf  =  diag([M1 J1 J2 M2 M3 J3])
disp(' ')

disp('matrice di rigidezza (parte elastica) in coordinate fisiche')
mtx_kf  =  diag([k1 k2 k3])
disp(' ')

disp('matrice di smorzamento in coordinate fisiche')
mtx_rf  =  diag([r1 r2 r3])
disp(' ')

disp('jacobiano matrice di massa')
mtx_Jm  =  [L 2*R 0;1 0 0;0 1 0; 0 2*R 0;0 0 L/2;0 0 1]
disp(' ')

disp('jacobiano matrice di rigidezza-smorzamento')
mtx_Jel  =  [0 2*R 0;0 -3*R L;0 0 -L/2]
disp(' ')
    
disp('matrice di massa in coordinate indipendenti')
mtx_m  =  mtx_Jm'*mtx_mf*mtx_Jm
disp(' ')

disp('matrice di rigidezza (parte gravitazionale) in coordinate indipendenti')
mtx_kg  =  [M1*g*L 0 0;0 0 0;0 0 -M3*g*L/2]
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
%i modi sono ordinati per righe
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

%........................................................PUNTO 3

ff=[0:0.01:15];
ome=2*pi*ff;
vett_F=[0;1;0];
for i=1:length(ff)
    A=-ome(i)^2*mtx_m+j*ome(i)*mtx_r+mtx_k;
    x=inv(A)*vett_F;
    xa=L*x(3);
    mod1(i)=abs(xa);           
    fas1(i)=angle(xa);          
    mod2(i)=abs(x(1));              
    fas2(i)=angle(x(1));            
end

figure
subplot(211)
plot(ff,mod1)
title('FdT xa/C')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT rotazione asta/C')
grid
subplot(212)
plot(ff,fas2)
grid

%..........................................................PUNTO 4

vett_F=[0;0;L/2];
for i=1:length(ff)
    A=-ome(i)^2*mtx_m+j*ome(i)*mtx_r+mtx_k;
    x=inv(A)*vett_F;
    xc=2*R*x(2);
    mod1(i)=abs(xc);              
    fas1(i)=angle(xc);            
    mod2(i)=abs(x(3));
    fas2(i)=angle(x(3));
end

figure
subplot(211)
plot(ff,mod1)
title('FdT spostamento disco/forza su asta')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT rotazione asta/forza su ast')
grid
subplot(212)
plot(ff,fas2)
grid

%........................................................PUNTO 5+6

y0=1;
vett_F=[0;2*R;0];
for i=1:length(ff)
    A=-ome(i)^2*mtx_m+j*ome(i)*mtx_r+mtx_k;
    Fy=(k1+j*ome(i)*r1)*y0;
    Q=vett_F*Fy;
    x=inv(A)*Q;
    mod1(i)=abs(x(2));
    fas1(i)=angle(x(2));
    mod2(i)=abs(x(1));
    fas2(i)=angle(x(1));
    xc=2*R*x(2);
    Re=(y0-xc)*(k1+j*ome(i)*r1);
    mod3(i)=abs(Re);
    fas3(i)=angle(Re);
end

figure
subplot(211)
plot(ff,mod1)
title('FdT rotazione dischi/spostamento impressso')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT rotazione asta/spostamento impressso')
grid
subplot(212)
plot(ff,fas2)
grid

figure
subplot(211)
plot(ff,mod3)
title('FdT forza impressa/spostamento impressso')
grid
subplot(212)
plot(ff,fas3)
grid
