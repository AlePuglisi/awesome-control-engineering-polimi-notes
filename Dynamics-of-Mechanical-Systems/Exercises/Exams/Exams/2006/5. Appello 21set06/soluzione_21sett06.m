clear all
close all

m=3;			% [kg]	
Jg=1;			% [kgm^2]	
M1=2;			% [kg]
J1=1.75;			% [kgm^2]	
M2=2;			% [kg]
J2=0.75;		% [kgm^2]
R1=1.5;			% [m]
R2=1;			% [m]
L=2;			% [m]
k1=150;		    % [N/m]
k2=400;		    % [N/m]
r1=0.5;   		% [Ns/m]
r2=0.1;   		% [Ns/m]

disp('matrice di massa in coordinate fisiche')
mtx_mf  =  diag([m Jg M1 J1 M2 J2])
disp(' ')
  
disp('matrice di rigidezza in coordinate fisiche')
mtx_kf  =  diag([k1 k2])
disp(' ')

disp('matrice di smoramento in coordinate fisiche')
mtx_rf  =  diag([r1 r2])
disp(' ')

disp('jacobiano matrice di massa')
mtx_Jm  =  [0 0 0.5*L;0 0 1; 0 0 L;1 0 0; 0 1 0; 0 1/R2 0]
disp(' ')
    
disp('jacobiano matrice di rigidezza/smorzamento')
mtx_Jk  =  [R1 0 L;-R1 -2 L]
disp(' ')

disp('matrice di massa in coordinate indipendenti')
mtx_m  =  mtx_Jm'*mtx_mf*mtx_Jm
disp(' ')

disp('matrice di smorzamento in coordinate indipendenti')
mtx_r  =  mtx_Jk'*mtx_rf*mtx_Jk
disp(' ')

disp('matrice di rigidezza in coordinate indipendenti')
mtx_k  =  mtx_Jk'*mtx_kf*mtx_Jk
disp(' ')

%partizione delle matrici

MLL=mtx_m(1:2,1:2);
MLV=mtx_m(1:2,3);
MVL=mtx_m(3,1:2);
MVV=mtx_m(3,3);

RLL=mtx_r(1:2,1:2);
RLV=mtx_r(1:2,3);
RVL=mtx_r(3,1:2);
RVV=mtx_r(3,3);

KLL=mtx_k(1:2,1:2);
KLV=mtx_k(1:2,3);
KVL=mtx_k(3,1:2);
KVV=mtx_k(3,3);

%calcolo delle frequenze proprie e dei modi di vibrare

[modi,d]=eig(inv(MLL)*KLL);
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

% risposta in frequenza: coppia unitaria

ff=0:0.01:10;        %definizione vettore delle frequenze
ome=2*pi*ff;
vett_F=[1;0];             %definizione vettore forzanti
for i=1:length(ff)
    A=-ome(i)^2*MLL+j*ome(i)*RLL+KLL;
    x=inv(A)*vett_F;
    mod1(i)=abs(x(1));              
    fas1(i)=angle(x(1));            
    mod2(i)=abs(x(2))/R2;              
    fas2(i)=angle(x(2));            
end

figure
subplot(211)
plot(ff,mod1)
title('FdT theta1/C')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT theta2/C')
grid
subplot(212)
plot(ff,fas2)
grid

% risposta in frequenza: forza unitaria

ff=0:0.01:10;        %definizione vettore delle frequenze
ome=2*pi*ff;
vett_F=[0;R2];             %definizione vettore forzanti
for i=1:length(ff)
    A=-ome(i)^2*MLL+j*ome(i)*RLL+KLL;
    x=inv(A)*vett_F;
    mod1(i)=abs(x(2))/R2;              
    fas1(i)=angle(x(2));            
    mod2(i)=abs(x(2));              
    fas2(i)=angle(x(2));            
end

figure
subplot(211)
plot(ff,mod1)
title('FdT theta2/F')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT y/F')
grid
subplot(212)
plot(ff,fas2)
grid


% risposta in frequenza: rotazione impressa

for i=1:length(ff)
    A=-ome(i)^2*MLL+j*ome(i)*RLL+KLL;
    forza=-(-ome(i)^2*MLV+j*ome(i)*RLV+KLV);
    x=inv(A)*forza;
    cm=(-ome(i)^2*MVL+j*ome(i)*RVL+KVL)*x+(-ome(i)^2*MVV+j*ome(i)*RVV+KVV);
    mod1(i)=abs(x(2))/R2;              
    fas1(i)=angle(x(2));            
    mod2(i)=abs(x(2));              
    fas2(i)=angle(x(2));            
    mod3(i)=abs(cm);              
    fas3(i)=angle(cm);            
    mod4(i)=abs(x(1));              
    fas4(i)=angle(x(1));            
end

figure
subplot(211)
plot(ff,mod1)
title('FdT theta2/theta imp.')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT y/theta imp.')
grid
subplot(212)
plot(ff,fas2)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT cm/theta imp.')
grid
subplot(212)
plot(ff,fas2)
grid


figure
subplot(211)
plot(ff,mod4)
title('FdT theta1/theta imp.')
grid
subplot(212)
plot(ff,fas4)
grid


