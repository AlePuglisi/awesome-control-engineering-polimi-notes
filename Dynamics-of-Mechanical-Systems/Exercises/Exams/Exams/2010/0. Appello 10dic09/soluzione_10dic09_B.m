clear all
%close all

m1=350;			% [kg]	
m2=500;			% [kg]	
J1=2.5;			% [kg m^2]	
J2=2.5;			% [kg m^2]	
k1=1e3; 	    % [N/m]
k2=2e3; 	    % [N/m]
k3=1e3; 	    % [N/m]
H=10;   		    % [Ns/m]
r1=0.5;   		% [Ns/m]
r2=0.5;   		% [Ns/m]
r3=0.5;   		% [Ns/m]
g=9.81;
t1=6.0;
T=10;
y1=0.1;
y2=-0.0667;

disp('matrice di massa in coordinate fisiche')
mtx_mf  =  diag([m1 J1 m2 J2])
disp(' ')

disp('matrice di rigidezza in coordinate fisiche')
mtx_kf  =  diag([k1 k2 k3])
disp(' ')

disp('matrice di rigidezza gravitazioneale in coordinate indipendenti')
mtx_kg  =  zeros(3);
mtx_kg(2,2)=-2*H*m1*g;
disp(' ')

disp('matrice di smorzamento in coordinate fisiche')
mtx_rf  =  diag([r1 r2 r3])
disp(' ')

disp('jacobiano matrice di massa')
mtx_Jm  =  [0 2*H 1;0 1 0;1 0 0;1/H -3 -1/H]
disp(' ')

disp('jacobiano matrice di rigidezza')
mtx_Jel  =  [0 2*H 1;2 -4*H -2;-1 0 0]
disp(' ')

disp('jacobiano matrice di smorzamento')
mtx_Jr  =  mtx_Jel
disp(' ')

disp('matrice di massa in coordinate indipendenti')
mtx_m  =  mtx_Jm'*mtx_mf*mtx_Jm
disp(' ')

disp('matrice di rigidezza in coordinate indipendenti')
mtx_k  =  mtx_Jel'*mtx_kf*mtx_Jel+mtx_kg
disp(' ')

disp('matrice di smoramento in coordinate indipendenti')
mtx_r  =  mtx_Jr'*mtx_rf*mtx_Jr
disp(' ')

MLL=mtx_m(1:2,1:2);
RLL=mtx_r(1:2,1:2);
KLL=mtx_k(1:2,1:2);

MLV=mtx_m(1:2,3);
RLV=mtx_r(1:2,3);
KLV=mtx_k(1:2,3);

MVL=mtx_m(3,1:2);
RVL=mtx_r(3,1:2);
KVL=mtx_k(3,1:2);

MVV=mtx_m(3,3);
RVV=mtx_r(3,3);
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

ff=0:0.01:2;            %definizione vettore delle frequenze
ome=2*pi*ff;
vett_F=[1/H;-3];             %definizione vettore forzanti
for i=1:length(ff)
    A=-ome(i)^2*MLL+j*ome(i)*RLL+KLL;
    x=inv(A)*vett_F;
    mod1(i)=abs(x(1)); 
    fas1(i)=angle(x(1));
    mod2(i)=abs(x(2));         
    fas2(i)=angle(x(2));
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

% risposta in frequenza: spostamento impresso

y0=1;
for i=1:length(ff)
    A=-ome(i)^2*MLL+j*ome(i)*RLL+KLL;
    x=-inv(A)*(-ome(i)^2*MLV+j*ome(i)*RLV+KLV);
    phi=-3*x(2)-y0/H+x(1)/H;
    xd=4*H*x(2)+y0;
    Rx=(-ome(i)^2*MVL+j*ome(i)*RVL+KVL)*x+(-ome(i)^2*MVV+j*ome(i)*RVV+KVV);
    mod1(i)=abs(phi);              
    fas1(i)=angle(phi);            
    mod2(i)=abs(xd);            
    fas2(i)=angle(xd);
    mod3(i)=abs(Rx);            
    fas3(i)=angle(Rx);          
end

figure
subplot(211)
plot(ff,mod1)
title('FdT rotazione disco/y0')
grid
subplot(212)
plot(ff,fas1)
grid

figure
subplot(211)
plot(ff,mod2)
title('FdT xd/y0')
grid
subplot(212)
plot(ff,fas2)
grid

figure
subplot(211)
plot(ff,mod3)
title('FdT Rx/y0')
grid
subplot(212)
plot(ff,fas3)
grid

%spostamento periodico

dt=0.01;
vt1=0:dt:t1;
vt2=t1+dt:dt:T-dt;
vy1=ones(1,length(vt1))*y2;
vy2=ones(1,length(vt2))*y1;
vett_t=[vt1 vt2];
vett_y=[vy1 vy2];
figure;plot(vett_t,vett_y);grid;axis([0 T -0.15 0.15])

df=1/T;
N=length(vett_t);
vett_f=0:df:df*(N/2-1);
g=fft(vett_y);
mody(1)=abs(g(1))/N;
mody(2:N/2)=abs(g(2:N/2))*2/N;
fasy(1:N/2)=angle(g(1:N/2));
figure
subplot 211;bar(vett_f,mody);grid
subplot 212;bar(vett_f,fasy);grid

tempo=0:dt:2*T;
np=length(tempo);
yimp=zeros(1,np);
xper=zeros(1,np);
for k=1:N/2
    ome=2*pi*vett_f(k);
    A=-ome^2*MLL+j*ome*RLL+KLL;
    x=-inv(A)*(-ome^2*MLV+j*ome*RLV+KLV)*mody(k)*exp(j*fasy(k));
    yimp=yimp+mody(k)*cos(ome*tempo+fasy(k)); 
    xper=xper+abs(x(1))*cos(ome*tempo+angle(x(1))); 
    modxper(k)=abs(x(1));
    fasxper(k)=angle(x(1));
end

figure;plot(tempo,yimp);grid
figure;plot(tempo,xper);grid
figure;bar(vett_f,modxper);grid;ax=axis;axis([0 5 0 ax(4)]);
