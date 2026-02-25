clear all
%close all

M1=2;			% [kg]	
M2=1;			% [kg]
M3=1;			% [kg]
J1=0.05;		% [kg m^2]	
J2=0.02;		% [kg m^2]	
J3=0.05;	    % [kg m^2]	
R1=0.2;	    	% [m]
R3=0.2;  		% [m]
L=0.5;			% [m]
k1=2e2; 	    % [N/m]
k2=50e2; 	    % [N/m]
k3=3e2; 	    % [N/m]
r1=2.5;   		% [Ns/m]
r2=0.01;   		% [Ns/m]
r3=0.05;   		% [Ns/m]

disp('matrice di massa in coordinate fisiche')
mtx_mf  =  diag([M1 J1 M2 J2 J3])
disp(' ')

disp('matrice di rigidezza in coordinate fisiche')
mtx_kf  =  diag([k1 k2 k3])
disp(' ')

disp('matrice di smorzamento in coordinate fisiche')
mtx_rf  =  diag([r1 r2 r3])
disp(' ')

disp('jacobiano matrice di massa')
mtx_Jm  =  [-R1 -L;1 0;0 L/2;0 1;0 -2*L/R3]
disp(' ')

disp('jacobiano matrice di rigidezza')
mtx_Jel  =  [R1 L;0 L;-2*R1 -3*L]
disp(' ')

disp('jacobiano matrice di smorzamento')
mtx_Jr  =  [R1 L;0 L;-2*R1 -3*L]
disp(' ')

disp('matrice di massa in coordinate indipendenti')
mtx_m  =  mtx_Jm'*mtx_mf*mtx_Jm
disp(' ')

disp('matrice di rigidezza in coordinate indipendenti')
mtx_k  =  mtx_Jel'*mtx_kf*mtx_Jel
disp(' ')

disp('matrice di smoramento in coordinate indipendenti')
mtx_r  =  mtx_Jr'*mtx_rf*mtx_Jr
disp(' ')

%calcolo delle frequenze proprie e dei modi di vibrare

[modi,d]=eig(inv(mtx_m)*mtx_k);
fre=sqrt(diag(d))/2/pi;

%crea una matrice temporanea per ordinare frequenze e modi
% i modi sono ordinati per righe
tmp=[fre modi'];                

% ordina le frequenze e i modi in ordine crescente 
tmp_out=sortrows(tmp,1);
fre=tmp_out(:,1);                   % frequenze ordinate
ngdl=length(fre);
modi=tmp_out(:,2:ngdl+1)';          % modi ordinati per colonne

% stampa delle frequenze e modi

for i=1:ngdl
    val_max=max(abs(modi(:,i)));
    modi(:,i)=modi(:,i)/val_max;
    disp(['modo # ' num2str(i) ': ' num2str(fre(i)) ' [Hz]        ' num2str(modi(:,i)') ])
end

%.........................................................PUNTO 3

ff=0:0.01:7.5;
ome=2*pi*ff;
C0=1;
vett_F=[1;0]*C0;
for i=1:length(ff)
    A=-ome(i)^2*mtx_m+j*ome(i)*mtx_r+mtx_k;
    x=inv(A)*vett_F;
    y=-R1*x(1)-L*x(2);
    th3=-2*L/R3*x(2);
    mod1(i)=abs(y); 
    fas1(i)=angle(y);
    mod2(i)=abs(th3);         
    fas2(i)=angle(th3); 
end

figure
subplot(211)
plot(ff,mod1)
title('FdT y1/C')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT rotaz. disco 3/C')
grid
subplot(212)
plot(ff,fas2)
grid

%...........................................................PUNTO 4+5

F0=1;
vett_F=[0;-2*L]*F0;
for i=1:length(ff)
    A=-ome(i)^2*mtx_m+j*ome(i)*mtx_r+mtx_k;
    x=inv(A)*vett_F;
    T=-(k3+j*ome(i)*r3)*(2*R1*x(1)+3*L*x(2));   %T=Fel3
    mod1(i)=abs(x(2));              
    fas1(i)=angle(x(2));            
    mod2(i)=abs(x(1));            
    fas2(i)=angle(x(1));          
    mod3(i)=abs(T);            
    fas3(i)=angle(T);          
end

figure
subplot(211)
plot(ff,mod1)
title('FdT rot. asta/F')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT rot. disco/F')
grid
subplot(212)
plot(ff,fas2)
grid

figure
subplot(211)
plot(ff,mod3)
title('FdT tiro/F')
grid
subplot(212)
plot(ff,fas3)
grid


% .....................................................PUNTO 6
% costrusico la forzante periodica

T=0.2;
fremax=50;
Fmax=100;
t=T/1000*[1:1:1000];
m=Fmax/(0.25*T);
y=[m*t(1:250) 2*Fmax-m*t(251:750) -4*Fmax+m*t(751:1000)];
figure
plot(t,y,'LineWidth',2);grid

%scompongo con fourier
N=length(y);
dt=t(2)-t(1);
grf=fft(y,N);
modF(2:(N/2))=2/N*abs(grf(2:(N/2)));
modF(1)=grf(1)/N;
freqF=(1/dt)/N*(0:(N/2-1));
faseF(2:(N/2))=atan2(imag(grf(2:(N/2))),real(grf(2:(N/2))));
nn=round(fremax*T)+1;
%disegno lo spettro della forza
figure
subplot(211)
bar(freqF(1:nn),modF(1:nn),0.1)
title('spettro F')
subplot(212)
bar(freqF(1:nn),faseF(1:nn),0.1)


pos=[2 4 6];    %vettore con indici prime tre armoniche diverse da zero

vett_F=[0;-2*L];
Fr=zeros(1,N);
yd=zeros(1,N);
for k=1:length(pos)
    omeyk=2*pi*freqF(pos(k));
    modyk=modF(pos(k));
    fasyk=faseF(pos(k));
    A=-omeyk^2*mtx_m+j*omeyk*mtx_r+mtx_k;
    x=inv(A)*vett_F*modyk*exp(j*fasyk);
    y=R1*x(1)+L*x(2);
    y_spettro(k)=y;
    Fr=Fr+modF(pos(k))*cos(2*pi*freqF(pos(k))*t+faseF(pos(k)));
    yd=yd+abs(y)*cos(2*pi*freqF(pos(k))*t+angle(y));
end

figure
subplot(211)
bar(freqF(pos),abs(y_spettro),0.1)
title('spettro y disco')
subplot(212)
bar(freqF(pos),angle(y_spettro),0.1)

figure
subplot(211)
plot(t,Fr);grid
title('Forza ricostruita')
subplot(212)
plot(t,yd);grid
title('spostamento disco')
