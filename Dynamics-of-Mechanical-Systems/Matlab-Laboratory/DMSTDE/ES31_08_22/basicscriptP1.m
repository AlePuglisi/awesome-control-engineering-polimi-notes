%PROBLEM 1 
clear all
close all
% ---PROBLEAM DATA---
g=9.81;
m1=10; m2=15; m3=5;
J1=0.8; J2=2.5; J3=0.1;
L1=0.5; L2=0.75; L0=1; R=0.2;
k1=10000; k2=5000; k3=2500;
DL01=-0.008; DL02=0.01; DL03=0.01;
c1=10; c2=5; c3=1; 
beta=pi/6;

%--MATRIX DEFINITION---(LIN. EQUATION OF MOTION)
mph=diag([m1 m1 J1 m2 m2 J2 m3 m3 J3]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[L1              0;
    0               0;
    1               0;
    2*L1            0;
    L2              0;
    1               0;
    2*L1-R          -R;
    L0              0;
    1              1];

Lk=[2*L2            0;
    -2*L1+R         R;
    0               -2*R];

Lc=Lk;

Lf=[2*L1-R      -R;
    L0           0;]

KelII1=zeros(2,2);KelII1(1,1)=DL01*k1*2*L1;
KelII2=zeros(2,2);KelII2(1,1)=DL02*k2*L0;
KelII3=zeros(2,2);
KelII=KelII1+KelII2+KelII3;

KG1=zeros(2,2);KG1(1,1)=m1*g*L1;
KG2=zeros(2,2);KG2(1,1)=m2*g*2*L1;
KG3=zeros(2,2);KG3(1,1)=m3*g*(2*L1-R);KG3(1,2)=-m3*g*R;KG3(2,1)=KG3(1,2);
KG=KG1+KG2+KG3;

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KelII+KG;

%PARTITIONING OF MATRIX
MFF=M; %select correct (rows,columns) respect free coordinates
CFF=C;
KFF=K;
%IF DISPLACEMENT CONSTRAIN that don't allow usage of SHORTCUT
%(so not applied on extremity of spring+dumbper)
%MFC=M();
%CFC=C();
%KFC=K();
%and so on.. if we were asked for constrain force 
%..............................................
% natural frequencies and modes of vibration

[eigenvectors eigenvalues]=eig(MFF\KFF);

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%..............................................
% frequency response FRF

i=sqrt(-1);
vett_f=[0:0.01:10];
F0=[cos(beta);sin(beta)];%fph vector respect unitary magnitude
F=Lf'*F0;
%if constrain displacement without shortcut
%Y0=1; and not consider F
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    %Q0FC=-(-ome^2*MFC+i*ome*CFC+KFC)*y0;
    x=A\F; %if constrain disp. not F but Q0FC
    %Fy=(-ome^2*MCF+i*ome*CCF+KCF)*x+(-ome^2*MCC+i*ome*CCC+KCC)*y0;
    xc=(2*L1-R)*x(1) - R*x(2);
    yc=L0*x(1);
    xcdd=-ome^2*xc;
    ycdd=-ome^2*yc;
    Np=k2*DL02*x(1)+m3*ycdd-1*sin(beta);
    DL3=-2*R*x(2);
    phidd=-ome^2*x(2);
    Tp=J3/R*phidd-(k3+i*ome*c3)*DL3;
    mod1(k)=abs(xc);
    fas1(k)=angle(xc);
    mod2(k)=abs(yc);
    fas2(k)=angle(yc);
    mod3(k)=abs(Np);
    fas3(k)=angle(Np);
    mod4(k)=abs(Tp);
    fas4(k)=angle(Tp);
end

figure(1)
subplot 211;plot(vett_f,mod1);grid
title('x_{C}/F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure(2)
subplot 211;plot(vett_f,mod2);grid;
title('y_{C}/F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

figure(3)
subplot 211;plot(vett_f,mod3);grid
title('N_{P}/F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas3);grid
xlabel('Freq. [Hz]');

figure(4)
subplot 211;plot(vett_f,mod4);grid;
title('T_{P}/F0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas4);grid
xlabel('Freq. [Hz]');

%PRELOAD:
m3=10;
DL01=(-L2*m2*g-m3*g*L0+(2*L1-R)*k2*DL02)/(2*L2*k1)
DL02=2*k3/k2*DL03


%---TIME HISTORY--- if requested
%REMEMBER TO USE PSE AND CONSIDER SEPARATELY THE EFFECT IF MORE THAN ONE
%t=[];
%PART 1 FORCE EFFECT (CAREFULL IF CONSTRAIN EFFECT)
%F0=F01*exp(i*phi01);
%F=[]*F0;
%ome = ome01; set to the excitement frequence
%A=-ome^2*MFF+i*ome*CFF+KFF; 
%x=A\F;
%out1=  ;
%out1_t=abs(out1)*cos(ome*t + angle(out1));
%PART 2 IF MORE FORCING EFFECT 
%... as before...
%ome=ome02;
%out2=  ;
%out2_t=abs(out2)*cos(ome*t+angle(out2));
%out_t= out1_t + out2_t;
%figure()
%plot(t,out_t); grid
%title('');
