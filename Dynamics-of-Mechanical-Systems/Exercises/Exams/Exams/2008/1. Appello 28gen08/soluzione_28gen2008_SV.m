clear all
close all

M1=10;			% [kg]	
M2=30;			% [kg]
M3=5;			% [kg]
M4=0.5;			% [kg]
J1=0.5;			% [kg m^2]	
J3=0.25;		% [kg m^2]	
R1=0.25;		% [m]
R3=0.25;		% [m]
L=1.0;			% [m]
k1=2e3; 	    % [N/m]
k2=1e3; 	    % [N/m]
r2=2;   		% [Ns/m]
g=9.81;

disp('matrice di massa in coordinate fisiche')
mtx_mf  =  diag([M1 J1 M2 M3 J3 M4])
disp(' ')

disp('matrice di rigidezza in coordinate fisiche')
mtx_kf  =  diag([k1 k2])
disp(' ')

disp('matrice di rigidezza gravitazioneale in coordinate indipendenti')
mtx_kg  =  zeros(4);mtx_kg(3,3)=M4*g*L;
disp(' ')

disp('matrice di smorzamento in coordinate fisiche')
mtx_rf  =  diag([r2])
disp(' ')

disp('jacobiano matrice di massa')
mtx_Jm  =  [0 0 0 1; 1/R1 0 0 -1/R1; 1 0 0 0;1 R3 0 0; 0 1 0 0; 1 R3 L 0]
disp(' ')

disp('jacobiano matrice di rigidezza')
mtx_Jel  =  [2 0 0 -2;0 R3 0 0]
disp(' ')

disp('jacobiano matrice di smorzamento')
mtx_Jr  =  [0 R3 0 0]
disp(' ')

disp('matrice di massa in coordinate indipendenti')
MM  =  mtx_Jm'*mtx_mf*mtx_Jm
disp(' ')

disp('matrice di rigidezza in coordinate indipendenti')
KK  =  mtx_Jel'*mtx_kf*mtx_Jel+mtx_kg
disp(' ')

disp('matrice di smoramento in coordinate indipendenti')
RR  =  mtx_Jr'*mtx_rf*mtx_Jr
disp(' ')

mtx_m=MM(1:3,1:3);
mtx_r=RR(1:3,1:3);
mtx_k=KK(1:3,1:3);

MLV=MM(1:3,4);
RLV=RR(1:3,4);
KLV=KK(1:3,4);

MVL=MM(4,1:3);
RVL=RR(4,1:3);
KVL=KK(4,1:3);

MVV=MM(4,4);
RVV=RR(4,4);
KVV=KK(4,4);

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

% risposta in frequenza: forza unitaria

ff=0:0.01:4;            %definizione vettore delle frequenze
ome=2*pi*ff;
vett_F=[1;R3;L];             %definizione vettore forzanti
for i=1:length(ff)
    A=-ome(i)^2*mtx_m+j*ome(i)*mtx_r+mtx_k;
    x=inv(A)*vett_F;
    mod1(i)=abs(x(1)); 
    fas1(i)=angle(x(1));
    mod2(i)=abs(x(2));         
    fas2(i)=angle(x(2)); 
end

figure
subplot(211)
plot(ff,mod1)
title('FdT x/F')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT rotaz. disco 3/F')
grid
subplot(212)
plot(ff,fas2)
grid

% risposta in frequenza: coppia unitaria

vett_F=[1/R1;0;0];             %definizione vettore forzanti
for i=1:length(ff)
    A=-ome(i)^2*mtx_m+j*ome(i)*mtx_r+mtx_k;
    x=inv(A)*vett_F;
    mod1(i)=abs(x(1));              
    fas1(i)=angle(x(1));            
    mod2(i)=abs(x(3));            
    fas2(i)=angle(x(3));          
end

figure
subplot(211)
plot(ff,mod1)
title('FdT x/C')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT rot. asta/C')
grid
subplot(212)
plot(ff,fas2)
grid


% risposta in frequenza: reazione vincolare

vett_F=[1/R1;0;0];             %definizione vettore forzanti
C0=1;
QL=-C0/R1;                  %reazione vincolare relativa a C0
for i=1:length(ff)
    A=-ome(i)^2*mtx_m+j*ome(i)*mtx_r+mtx_k;
    x=inv(A)*vett_F;
    Ho=(-ome(i)^2*MVL+j*ome(i)*RVL+KVL)*x-QL;
    modHo(i)=abs(Ho);
    fasHo(i)=angle(Ho);
end

figure
subplot(211)
plot(ff,modHo)
title('FdT Ho/C')
grid
subplot(212)
plot(ff,fasHo)
grid

%senza partizione delle matrici
for i=1:length(ff)
    A=-ome(i)^2*mtx_m+j*ome(i)*mtx_r+mtx_k;
    x=inv(A)*vett_F;
    Ho=1/R1-(4*k1-ome(i)^2*J1/R1^2)*x(1);
    modHo(i)=abs(Ho);
    fasHo(i)=angle(Ho);
end

figure
subplot(211)
plot(ff,modHo)
title('FdT Ho/C')
grid
subplot(212)
plot(ff,fasHo)
grid
