clear all
close all

M1=20;			% [kg]	
M2=30;			% [kg]
M3=15;			% [kg]
J1=0.5;			% [kg m^2]	
J2=1.0;			% [kg m^2]	
J3=0.2;			% [kg m^2]	
R=0.25;			% [m]
L1=0.3;			% [m]
L3=0.2;			% [m]
k1=2e3; 	    % [N/m]
k2=2e3; 	    % [N/m]
r1=4;   		% [Ns/m]
r2=1;   		% [Ns/m]
g=9.81;

disp('matrice di massa in coordinate fisiche')
mtx_mf  =  diag([M1 J1 J2 M3 J3])
disp(' ')

disp('matrice di rigidezza in coordinate fisiche')
mtx_kf  =  diag([k1 k2])
disp(' ')

disp('matrice di rigidezza gravitazioneale in coordinate indipendenti')
mtx_kg  =  [M1*g*L1 0;0 -M3*g*R^2/L3]
disp(' ')

disp('matrice di smorzamento in coordinate fisiche')
mtx_rf  =  diag([r1 r2])
disp(' ')

disp('jacobiano matrice di massa')
mtx_Jm  =  [L1 0; 1 0; 0 1; 0 -R; 0 R/L3]
disp(' ')

disp('jacobiano matrice di rigidezza-smorzamento')
mtx_Jel  =  [-L1 2*R;2*L1 -R]
disp(' ')

disp('matrice di massa in coordinate indipendenti')
mtx_m  =  mtx_Jm'*mtx_mf*mtx_Jm
disp(' ')

disp('matrice di rigidezza in coordinate indipendenti')
mtx_k  =  mtx_Jel'*mtx_kf*mtx_Jel+mtx_kg
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

%.......................................................PUNTO 3

ff=0:0.01:7.5;
ome=2*pi*ff;
vett_F=[0;-R];
for i=1:length(ff)
    A=-ome(i)^2*mtx_m+j*ome(i)*mtx_r+mtx_k;
    x=inv(A)*vett_F;
    xa=L1*x(1);
    mod1(i)=abs(xa);              
    fas1(i)=angle(xa);            
    mod2(i)=abs(x(2));            
    fas2(i)=angle(x(2));          
end

figure
subplot(211)
plot(ff,mod1)
title('FdT xa/Fg')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT theta/Fg')
grid
subplot(212)
plot(ff,fas2)
grid

%.........................................................PUNTO 4

vett_F=[2*L1;0];
for i=1:length(ff)
    A=-ome(i)^2*mtx_m+j*ome(i)*mtx_r+mtx_k;
    x=inv(A)*vett_F;
    xg=R*x(2);
    mod1(i)=abs(xg); 
    fas1(i)=angle(xg);
    mod2(i)=abs(x(1));         
    fas2(i)=angle(x(1));       
end

figure
subplot(211)
plot(ff,mod1)
title('FdT xg/Fb')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT phi/Fb')
grid
subplot(212)
plot(ff,fas2)
grid

% ...................................................PUNTO 5

%costruisco la forzante periodica
T=0.8;
fremax=20;
Fmax=10;
t=T/1000*[1:1:1000];
F=[Fmax*ones(1,250) -Fmax*ones(1,500) Fmax*ones(1,250)];
figure
plot(t,F,'LineWidth',2);grid

%scompongo con Fourier
N=length(F);
dt=t(2)-t(1);
grf=fft(F,N);
modF(2:(N/2))=2/N*abs(grf(2:(N/2)));
modF(1)=grf(1)/N;
freqF=(1/dt)/N*(0:(N/2-1));
faseF(2:(N/2))=atan2(imag(grf(2:(N/2))),real(grf(2:(N/2))));
nn=round(fremax*T)+1;
%disegno spettro
figure
subplot(211)
bar(freqF(1:nn),modF(1:nn),0.1)
title('spettro F')
subplot(212)
bar(freqF(1:nn),faseF(1:nn),0.1)


pos=[2 4 6];    %vettore con indici prime tre armoniche diverse da zero

for k=1:length(pos)
    omeFk=2*pi*freqF(pos(k));
    modFk=modF(pos(k));
    fasFk=faseF(pos(k));
    A=-omeFk^2*mtx_m+j*omeFk*mtx_r+mtx_k;
    x=inv(A)*vett_F*modFk*exp(j*fasFk);
    xout(k)=x(1);
end

figure
subplot(211)
bar(freqF(pos),abs(xout),0.1)
title('spettro phi')
subplot(212)
bar(freqF(pos),angle(xout),0.1)

