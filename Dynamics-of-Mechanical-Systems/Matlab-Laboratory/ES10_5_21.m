clear all
close all

m1=10; m2=10;
J1=0.15; J2=0.08;
R1=0.25; RG=1; R=RG-R1;
L0=0.35; H=0.1;
k1=3000; k2=3000; k3=3000;
DL01=-0.0041; DL02=-0.0076; DL03=0.02;
c1=3; c2=3; c3=3;
theta0=pi/6; phi0=pi/12;
g=9.81;
ct0=cos(theta0); st0=sin(theta0);
cp0=cos(phi0); sp0=sin(phi0);

mph=diag([m1 m1 J1 m2 m2 J2]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[R*ct0                                   0;
    R*st0                                   0;
    -R/R1                                   0;
    R*ct0+(R1-L0)*R/R1*sp0+H*cp0*R/R1     -cp0;
    R*st0+H*R/R1*sp0-(R1-L0)*cp0*R/R1     -sp0;
    -R/R1                                   0];

Lk=[0                                       1;
    R*ct0+(R1-L0)*R/R1*sp0+H*cp0*R/R1     -cp0;
    -R*st0-H*R/R1*sp0+(R1-L0)*R/R1*cp0     sp0];

Lc=Lk;

KelII1=zeros(2,2);
KelII2=zeros(2,2);KelII2(1,1)=-k2*DL02*(R*st0+(R1-L0)*R^2/R1^2*cp0+H*sp0*R^2/R1^2);
KelII2(1,2)=-k2*DL02*sp0*R/R1; KelII2(2,1)=KelII2(1,2);
KelII3=zeros(2,2);KelII3(1,1)=-k3*DL03*(R*ct0-H*R^2/R1^2*cp0-(R1-L0)*R^2/R1^2*sp0);
KelII3(1,2)=-k3*DL03*cp0*R/R1;KelII3(2,1)=KelII3(1,2);
KelII = KelII1 + KelII2 + KelII3;

KG1=zeros(2,2);KG1(1,1)=m1*g*R*ct0;
KG2=zeros(2,2);KG2(1,1)=m2*g*(R*ct0-R^2/R1^2*(H*cp0+(R1-L0)*sp0));
KG2(1,2)=m2*g*R/R1*cp0;KG2(2,1)=KG2(1,2);
KG = KG1 + KG2;

M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk;
MFF=M;
CFF=C;
KFF=K;

%..............................................
% natural frequencies and modes of vibration

[eigenvectors eigenvalues]=eig(MFF\KFF);

freq=sqrt(diag(eigenvalues))/2/pi
eigenvectors

%..............................................
% frequency response

% i=sqrt(-1);
% vett_f=;
% for k=1:length(vett_f)
%     ome=vett_f(k)*2*pi;
%     A=-ome^2*MFF+i*ome*CFF+KFF;
%     F=[];
%     x=A\Q0;
%     out1=;
%     out2=;
%     mod1(k)=abs(out1);
%     fas1(k)=angle(out1);
%     mod2(k)=abs(out2);
%     fas2(k)=angle(out2);
% end
% 
% figure(1)
% subplot 211;plot(vett_f,mod1);grid
% title('');
% xlabel('Freq. [Hz]');
% subplot 212;plot(vett_f,fas1);grid
% xlabel('Freq. [Hz]');
% 
% figure(2)
% subplot 211;plot(vett_f,mod2);grid;
% title('');
% xlabel('Freq. [Hz]');
% subplot 212;plot(vett_f,fas2);grid
% xlabel('Freq. [Hz]');
% 
% 
