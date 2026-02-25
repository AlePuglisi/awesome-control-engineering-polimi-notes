clear all
close all

m1=5;
m2=5;
m3=15;
J1=0.5;
J2=0.5;
R1=0.2;
k1=1000;
k2=1000;
k3=1000;
k4=1000;
r1=2;
r2=2;
r3=2;
r4=2;
f1=1;
f2=2;
alfa=pi/6;


mf=diag([m1 m1 J1 m2 m2 J2 m3]);
rf=diag([r1 r2 r3 r4]);
kf=diag([k1 k2 k3 k4]);

Lm=[2*R1*cos(alfa) 0 1;
    2*R1*sin(alfa) 0 0;
    1 0 0;
    0 3*R1/2*cos(alfa) 1;
    0 3/2*R1*sin(alfa) 0;
    0 1 0;
    0 0 1];
Lr=[2*R1 0 0;
    0 -3*R1/2 0;
    0 0 -1;
    -3*R1 3*R1 0];
Lk=Lr;

Kg=zeros(3,3);
M=Lm'*mf*Lm;
R=Lr'*rf*Lr;
K=Lk'*kf*Lk+Kg;

[modi autov]=eig(M\K);

freq=sqrt(diag(autov))/2/pi
modi

i=sqrt(-1);
F0=1;
Qf=[0;3/2*R1*cos(alfa);1]*F0;
ff=0:0.001:6;

for k=1:length(ff)
    omF=2*pi*ff(k);
    A=-omF^2*M+i*omF*R+K;
    x=A\Qf;
    
          
    mod1(k)=abs(x(3));
    fas1(k)=angle(x(3));
    
    mod2(k)=abs(x(2));
    fas2(k)=angle(x(2));
end

figure
subplot 211;plot(ff,mod1);xlabel('[Hz]');ylabel('[m/N]');title('Spostamento piano inclinato/F0')
grid on
subplot 212;plot(ff,fas1);xlabel('[Hz]');ylabel('[deg/N]')
grid on

figure
subplot 211;plot(ff,mod2);xlabel('[Hz]');ylabel('[deg/N]');title('Rotazione Disco 2/F0')
grid on
subplot 212;plot(ff,fas2);xlabel('[Hz]');ylabel('[deg/N]')
grid on


i=sqrt(-1);
C0=1;
Qc=[1;0;0]*C0;
ff=0:0.001:6;

for k=1:length(ff)
    omF=2*pi*ff(k);
    A=-omF^2*M+i*omF*R+K;
    x=A\Qc;
    
    yc2=3/2*R1*sin(alfa)*x(2);
    
    Fs=(k3+i*omF*r3)*(x(3));
    
    mod3(k)=abs(x(1));
    fas3(k)=angle(x(1));
    
    mod4(k)=abs(yc2);
    fas4(k)=angle(yc2);
    
    mod256(k)=abs(Fs);
    fas256(k)=angle(Fs);
end

figure
subplot 211;plot(ff,mod3);xlabel('[Hz]');ylabel('[deg/N]');title('Rotazione Disco 1/C0')
grid on
subplot 212;plot(ff,fas3);xlabel('[Hz]');ylabel('[deg/N]')
grid on

figure
subplot 211;plot(ff,mod256);xlabel('[Hz]');ylabel('[N/N]');title('Forza scaricata/C0')
grid on
subplot 212;plot(ff,fas256);xlabel('[Hz]');ylabel('[deg/N]')
grid on

figure
subplot 211;plot(ff,mod4);xlabel('[Hz]');ylabel('[m/N]');title('Spostamento verticale Disco 2/C0')
grid on
subplot 212;plot(ff,fas4);xlabel('[Hz]');ylabel('[deg/N]')
grid on


i=sqrt(-1);
C01=2*exp(i*pi/3);
Qc1=[1;0;0]*C01*exp(i*2*pi*f1);
ff=0:0.001:10;
tt=0:0.001:3;

c1=zeros(1,length(tt));


for k=1:length(ff)
    omF=2*pi*ff(k);
    A=-omF^2*M+i*omF*R+K;
    x1=A\(Qc1);
    
    
    c1=c1+abs(x1(1))*cos(omF*tt+angle(x1(1)));
   
end

i=sqrt(-1);
F01=10*exp(i*pi/6);
Qf1=[0;3/2*R1*cos(alfa);1]*F01*exp(i*2*pi*f2);

f11=zeros(1,length(tt));


for k=1:length(ff)
    omF=2*pi*ff(k);
    A=-omF^2*M+i*omF*R+K;
    x1=A\(Qf1);
    
          
    f11=f11+abs(x1(1))*cos(omF*tt+angle(x1(1)));
   
end

piin1=c1+f11;


figure
subplot 311;plot(tt,piin1); grid
subplot 312;plot(tt,c1);grid
subplot 313;plot(tt,f11);grid






% i=sqrt(-1);
% C0=2*exp(i*pi/3);
% Qc=[1;0;0]*C0;
% ff=0:0.001:6;
% tt=0:0.001:3;
% omF1=2*pi*f1;
% omF2=2*pi*f2;
% c1=zeros(1,length(tt));
% c2=zeros(1,length(tt));
% 
% for k=1:length(ff)
%     omF=2*pi*ff(k);
%     A=-omF^2*M+i*omF*R+K;
%     x1=A\(Qc*exp(i*omF1*tt));
%     x2=A\(Qc*exp(i*omF2*tt));
%     
%     c1=c1+abs(x1(1))*cos(omF1*tt+angle(x1(1)));
%     c2=c2+abs(x2(1))*cos(omF2*tt+angle(x2(1)));
% end
% 
% i=sqrt(-1);
% F0=10*exp(i*pi/6);
% Qf=[0;3/2*R1*cos(alfa);1]*F0;
% ff=0:0.001:6;
% f11=zeros(1,length(tt));
% f22=zeros(1,length(tt));
% 
% for k=1:length(ff)
%     omF=2*pi*ff(k);
%     A=-omF^2*M+i*omF*R+K;
%     x1=A\(Qf*exp(i*omF1*tt));
%     x2=A\(Qf*exp(i*omF2*tt));
%           
%     f11=f11+abs(x1(1))*cos(omF1*tt+angle(x1(1)));
%     f22=f22+abs(x2(1))*cos(omF2*tt+angle(x2(1)));
% end
% 
% piin1=c1+f11;
% piin2=c2+f22;
% 
% figure
% subplot 311;plot(tt,piin1); grid
% subplot 312;plot(tt,c1);grid
% subplot 313;plot(tt,f11);grid
% 
% figure
% subplot 311;plot(tt,piin2); grid
% subplot 312;plot(tt,c2);grid
% subplot 313;plot(tt,f22);grid
% 
% df=1/T;
% N=length(vett_t);
% vett_f=0:df:df*(N/2-1);
% g=fft(vett_y);
% mody(1)=abs(g(1))/N;
% mody(2:N/2)=abs(g(2:N/2))*2/N;
% fasy(1:N/2)=angle(g(1:N/2));
% 
% figure
% subplot 211;bar(vett_f,mody);grid;xlabel('[Hz]');ylabel('m');title('Trasformata spostamento periodico')
% subplot 212;bar(vett_f,fasy);grid;xlabel('[Hz]');ylabel('deg')

% t=0:0.001:3;
% i=sqrt(-1);
% F0=10*exp(i*pi/6);
% C0=2*exp(i*pi/3);
% 
% i=sqrt(-1);
% 
% Qf=[1;3/2*R1*cos(alfa)]*F0;
% ff=0:0.001:3;
% 
% for k=1:length(ff)
%     omF=2*pi*ff(k);
%     A=-omF^2*M+i*omF*R+K;
%     x=A\Qf;
%     
%     o=x(1);
%       
% end
% 
% 
% i=sqrt(-1);
% 
% Qc=[0;1]*C0;
% ff=0:0.001:3;
% 
% for k=1:length(ff)
%     omF=2*pi*ff(k);
%     A=-omF^2*M+i*omF*R+K;
%     x=A\Qc;
%     
%   
%     h=x(1);
%     
% end
% 
% for k=1:length(t)
%     omt=t(k);
%     xt=(o+h)*exp(i*omt*2*pi*f1);
%     stor(k)=real(xt);
% end
% 
% figure
% plot(t,stor);xlabel('t');ylabel('x');title('Storia temporale')
% grid on
%     
% 
% T=0.2;
% 
% dt=0.001;
% t1=0:dt:T/4-dt;
% t2=T/4:dt:3/4*T-dt;
% t3=3/4*T:dt:T-dt;
% m=Fmax/(T/4);
% F1=m*t1;
% F2=2*Fmax-m*t2;
% F3=-4*Fmax+m*t3;
% vett_t=[t1 t2 t3];
% vett_F=[F1 F2 F3]
% figure;plot(vett_t,vett_F);grid
% 
% N=length(vett_F);
% fftout=fft(vett_F);
% modF(1)=abs(fftout(1))/N;
% modF(2:N/2)=abs(fftout(2:N/2))*2/N;
% fasF(1:N/2)=angle(fftout(1:N/2));
% f0=1/T;
% df=f0;
% fmax=(N/2-1)*f0;
% vett_freq=0:df:fmax;
% 
% figure
% subplot 211; bar(vett_freq,modF)
% subplot 212; bar(vett_freq,fasF)
% 
% i=sqrt(-1);
% for k=1:N/2
%    ome=2*pi*vett_freq(k);
%    A=-ome^2*M+i*ome*R+K;
%    F=modF(k)*exp(i*fasF(k));
%    Q=[0;-2*L]*F;
%    x=A\Q;
%    yc1=-L*x(2)-R1*x(1);
%    mody(k)=abs(yc1);
%    fasy(k)=angle(yc1);
% end
% 
% figure
% subplot 211;bar(vett_freq,mody)
% subplot 212;bar(vett_freq,fasy)
% 
% vett_y=zeros(1,N);
% narm=N/2;
% for iarm=1:narm
%    ome=2*pi*vett_freq(iarm);
%    vett_y=vett_y+mody(iarm)*cos(ome*vett_t+fasy(iarm));
%     
% end
% figure;plot(vett_t,vett_y);grid;title(['nr. armoniche ' num2str(narm)])
% 
% 
