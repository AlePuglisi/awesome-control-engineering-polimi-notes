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
k2=8e3;         % [N/m]
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
mtx_Jm  =  [L 2*R 0 0;1 0 0 0;0 1 0 0; 0 2*R 0 0;0 0 L/2 0;0 0 1 0]
disp(' ')

disp('jacobiano matrice di rigidezza-smorzamento')
mtx_Jel  =  [0 2*R 0 -1;0 -3*R L 0;0 0 -L/2 0]
disp(' ')
    
disp('matrice di massa in coordinate indipendenti')
mtx_m  =  mtx_Jm'*mtx_mf*mtx_Jm
disp(' ')

disp('matrice di rigidezza (parte gravitazionale) in coordinate indipendenti')
mtx_kg  =  [M1*g*L 0 0 0;0 0 0 0;0 0 -M3*g*L/2 0;0 0 0 0]
disp(' ')

disp('matrice di rigidezza in coordinate indipendenti')
mtx_k  =  mtx_Jel'*mtx_kf*mtx_Jel + mtx_kg
disp(' ')

disp('matrice di smoramento in coordinate indipendenti')
mtx_r  =  mtx_Jel'*mtx_rf*mtx_Jel
disp(' ')


MLL=mtx_m(1:3,1:3);
RLL=mtx_r(1:3,1:3);
KLL=mtx_k(1:3,1:3);

MLV=mtx_m(1:3,4);
RLV=mtx_r(1:3,4);
KLV=mtx_k(1:3,4);

MVL=mtx_m(4,1:3);
RVL=mtx_r(4,1:3);
KVL=mtx_k(4,1:3);

MVV=mtx_m(4,4);
RVV=mtx_r(4,4);
KVV=mtx_k(4,4);


%calcolo delle frequenze proprie e dei modi di vibrare

[modi,d]=eig(inv(MLL)*KLL);
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

for k=1:ngdl
    val_max=max(abs(modi(:,k)));
    modi(:,k)=modi(:,k)/val_max;
    disp(['modo # ' num2str(k) ': ' num2str(fre(k)) ' [Hz]        ' num2str(modi(:,k)') ])
end

%...........................................................PUNTO 5+6

ff=[0:0.01:15];
ome=2*pi*ff;
y0=1;
for k=1:length(ff)
    A=-ome(k)^2*MLL+j*ome(k)*RLL+KLL;
    Q=-(-ome(k)^2*MLV+j*ome(k)*RLV+KLV)*y0;
    x=A\Q;
    Qc=(-ome(k)^2*MVL+j*ome(k)*RVL+KVL)*x +(-ome(k)^2*MVV+j*ome(k)*RVV+KVV)*y0;
    Fy=Qc;      %perchè dentro Qc mi compare solo Fy
    mod1(k)=abs(x(2));
    fas1(k)=angle(x(2));
    mod2(k)=abs(x(1));
    fas2(k)=angle(x(1));
    mod3(k)=abs(Fy);
    fas3(k)=angle(Fy);
end

figure
subplot(211);plot(ff,mod1);title('FdT theta/y0');grid
subplot(212);plot(ff,fas1);grid

figure
subplot(211);plot(ff,mod2);title('FdT phi/y0');grid
subplot(212);plot(ff,fas2);grid

figure
subplot(211);plot(ff,mod3);title('FdT Rx/y0');grid
subplot(212);plot(ff,fas3);grid






