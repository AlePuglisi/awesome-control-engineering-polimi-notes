%PROBLEM 1 
clear all
close all
% ---PROBLEAM DATA---
g=9.81;
m1=10; m2=4;
J1=1.5; J2=0.1; 
R1=1; R2=0.2;
L0=0.75; d=0.5;
k1=10e3; k2=10e3; k3=5e3;
DL01=-0.0015; DL02=0.002; DL03=0.0039;
c1=4; c2=4; c3=2;
theta0=pi/6;
ct0 = cos(theta0); st0=sin(theta0);
fs=0.3;
%--MATRIX DEFINITION---(LIN. EQUATION OF MOTION)
mph=diag([m1 m1 J1 m2 m2 J2]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[-d*ct0+R1                   0;
     d*st0                      0;
     1                          0;
     -(L0-R1)*st0+R1+R2*ct0     R2*ct0;
     (R1-L0)*ct0-R2*st0        -R2*st0;
        1                        1];

Lk=[-R1*ct0             0;
     R1*ct0             0;
     0                  R2];
Lc=Lk;

Lf=[-1          -1;
    -R1*ct0     0];

KelII1=zeros(2,2);KelII1(1,1)=k1*DL01*R1*st0;
KelII2=zeros(2,2);KelII2(1,1)=-k2*DL02*R1*st0;
KelII3=zeros(2,2);
KelII=KelII1+KelII2+KelII3;

KG1=zeros(2,2);KG1(1,1)=m1*g*d*ct0;
KG2=zeros(2,2);KG2(1,1)=m2*g*((L0-R1)*st0-R2*ct0);
KG2(1,2)=-m2*g*R2*ct0; KG2(2,1)=KG2(1,2);
KG=KG1+KG2;

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
F0=[1;  0];%fph vector respect unitary magnitude
F=Lf'*F0;
%if constrain displacement without shortcut
%Y0=1; and not consider F
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    %Q0FC=-(-ome^2*MFC+i*ome*CFC+KFC)*y0;
    x=A\F; %if constrain disp. not F but Q0FC
    %Fy=(-ome^2*MCF+i*ome*CCF+KCF)*x+(-ome^2*MCC+i*ome*CCC+KCC)*y0;
    xc2=((R1-L0)*st0+R1+R2*ct0)*x(1)+R2*ct0*x(2);
    thetad=x(1);
    mod1(k)=abs(xc2);
    fas1(k)=angle(xc2);
    mod2(k)=abs(thetad);
    fas2(k)=angle(thetad);
end

figure(1)
subplot 211;plot(vett_f,mod1);grid
title('x_{C2}/C0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure(2)
subplot 211;plot(vett_f,mod2);grid;
title('/theta/C0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');



%if constrain displacement without shortcut
%Y0=1; and not consider F
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    F=Lf'*[0;k2+i*ome*c2];
    %Q0FC=-(-ome^2*MFC+i*ome*CFC+KFC)*y0;
    x=A\F; %if constrain disp. not F but Q0FC
    %Fy=(-ome^2*MCF+i*ome*CCF+KCF)*x+(-ome^2*MCC+i*ome*CCC+KCC)*y0;
    DL1=-R1*ct0*x(1);
    Fel1=(k1+i*ome*c1)*DL1;
    xc2=((R1-L0)*st0+R1+R2*ct0)*x(1)+R2*ct0*x(2);
    xc2dd=-ome^2*xc2;
    xG1=(-d*ct0+R1)*x(1);
    xG1dd=-ome^2*xG1;
    yG1=d*st0*x(1);
    yG1dd=-ome^2*yG1;
    yc2=((R1-L0)*ct0-R2*st0)*x(1) -R2*st0*x(2);
    yc2dd=-ome^2*yc2;
    DL2=R1*ct0*x(1);
    N1=m1*yG1dd+m2*yc2dd-(k1+i*ome*c1)*DL1-(k2+i*ome*c2)*DL2-(k2+i*ome*c2)*1;
    T1=m1*xG1dd + m2*xc2dd;

    mod1(k)=abs(Fel1);
    fas1(k)=angle(Fel1);
    mod2(k)=abs(xG1);
    fas2(k)=angle(xG1);

    mod3(k)=abs(N1);
    fas3(k)=angle(N1);
    mod4(k)=abs(T1);
    fas4(k)=angle(T1);
end

figure(3)
subplot 211;plot(vett_f,mod1);grid
title('Fel_{1}/y0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure(4)
subplot 211;plot(vett_f,mod2);grid;
title('x_{G1}/y0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

figure(5)
subplot 211;plot(vett_f,mod3);grid;
title('N_{1}/y0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas3);grid
xlabel('Freq. [Hz]');

figure(6)
subplot 211;plot(vett_f,mod4);grid;
title('T_{1}/y0');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas4);grid
xlabel('Freq. [Hz]');

%QUESTION 6:
Nd=mod3.*exp(i*fas3);
Td=mod4.*exp(i*fas4);
rapp=Td./Nd;

Nst=m1*g+m2*g-k2*DL02-k1*DL01;
[rapp_max,imax]=max(abs(rapp));
y0max=Nst*fs/abs(Td(imax));

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

