clear all
close all
%PROBLEM DATA
m1 = 10;
m2 = 5;
m3 = 3;
J1 = 0.2;
J2 = 0.02;
J3 = 0.01;
L1 = 0.50;
L2 = 0.25;
Le = 0.10;
k1 = 3000;
k2 = 1000;
k3 = 1000;
dL3e = 0.02;
c1 = 10;
c2 = 0.5;
c3 = 0.5;
F01 = 100;
y02 = 0.05;
g = 9.81;

%---QUESTION 1: find the equation of motion---
mph=diag([m1 m2 J1 m2 m2 J2 m3 m3 J3]);
cph=diag([c1 c2 c3]);
kph=diag([k1 k2 k3]);

Lm=[-L1/2   0   1;
      0     0   0;
      1     0   0;
      -L1   0   1;
      L2/2  0   0;
      1     0   0;
      -L1   1   1;
      Le    0   0;
      1     0   0];
Lk=[-L1/2   0   1;
     0      1   0;
     L1     -1  -1];
Lc=Lk;

KelII=zeros(3,3);   KelII(1,1) = k3*dL3e*Le;
KG1 = zeros(3,3);   KG1(1,1) = -m1*g*L1/2; 
KG2 = zeros(3,3);   KG2(1,1) = -m2*g*L1; 
KG3 = zeros(3,3);   KG3(1,1) = -m3*g*L1; KG3(1,2) = m3*g; KG3(2,1) = m3*g; 
KG=KG1 + KG2 + KG3;
%computing system matrix
M=Lm'*mph*Lm;
C=Lc'*cph*Lc;
K=Lk'*kph*Lk+KelII+KG;
%compute partition matrix of constraint displacement excitation that cannot
%be simplified, consistent partition 
MFF=M(1:2, 1:2);
CFF=C(1:2, 1:2);
KFF=K(1:2, 1:2);
%..............................................
%QUESTION 2:
% natural frequencies and modes of vibration

[eigenvectors eigenvalues]=eig(MFF\KFF);

%find out the eig values = nat freq and modal shapes
freq=sqrt(diag(eigenvalues))/2/pi %Natural freq in Hz
eigenvectors %modal shapes display on the screen 

%..............................................
%QUESTION 3:
% frequency response of theta = X(1) and of Fel3 when f acts on slider

i=sqrt(-1);
vett_f= [0:0.01:5]; %definition of freq range
F=[-L1; 1];
for k=1:length(vett_f) %loop on all freq of interest 
    ome=vett_f(k)*2*pi; %working on nat freq space 
    A=-ome^2*MFF+i*ome*CFF+KFF; %,mech impedence matrix of the system 
    x=A\F; %find solution of indip cohordinates as A^-1*F
    %so X is 2 complex number as amplitude and phase of the two indip
    %cohord to tranform into our outouts of interest 
    out1= x(1);
    %to produce Fel3 is better to find it cleaner in more steps, define dL3 from Lk 
    dL3 = L1*x(1) - x(2);
    out2=(k3 + i*ome*c3)*dL3;
    %find out the magn and phase of output to make BODE DIAG for each omega
    mod1(k)=abs(out1);
    fas1(k)=angle(out1);
    mod2(k)=abs(out2);
    fas2(k)=angle(out2);
end
%BODE PLOT of the OUTPUTS
figure(1)
subplot 211;plot(vett_f,mod1);grid
title('FRF of \theta for unit f');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas1);grid
xlabel('Freq. [Hz]');

figure(2)
subplot 211;plot(vett_f,mod2);grid;
title('FRF of F_{el3} for unit f');
xlabel('Freq. [Hz]');
subplot 212;plot(vett_f,fas2);grid
xlabel('Freq. [Hz]');

%QUESTION 5:
%PART 1 (EFFECT OF FORCE ON SLIDER) 
t = [0:1e-3:1]; %deep time vector 
F01 = 100; 
phi1 = pi/6;
F=[-L1; 1]*F01*exp(i*phi1); %generalized force vector with not unitary amplitude
ome1=2*pi; 
A=-ome1^2*MFF+i*ome1*CFF+KFF; 
x=A\F; %this time the solution is for a correct magnitude and phase of input 

YG2 = L2/2*x(1);
YG2dd = -ome1^2*YG2; %double derivative
YG3 = Le*x(1);
YG3dd = -ome1^2*YG3;
V_o1 =m2*YG2dd + m3*YG3dd; %contribution to Vo provided by F
%Vo1 is a single complex number representing amplitude and force of
%the reaction force generated bu only f acting on slider 
%DEFINE TIME HISTORY FOR OUTPUT
V_o1t = abs(V_o1)*cos(ome1*t + angle(V_o1)); %armonic funct of time respect Vo1

%PART 2 (EFFECT OF CONSTRAIN DISPLACEMENT) 
Y02 = 0.05;
phi2 = pi/3;
Y = Y02*exp(i*phi2);
ome2=4*pi; 
MFC=M(1:2, 3);
CFC=C(1:2, 3);
KFC=K(1:2, 3);
F=-(-ome2^2*MFC + i*ome2*CFC + KFC)*Y; %generalized force vector with not unitary amplitude
A=-ome2^2*MFF+i*ome1*CFF+KFF; 
x=A\F; %this time the solution is for a correct magnitude and phase of input 

YG2 = L2/2*x(1);
YG2dd = -ome2^2*YG2; %double derivative
YG3 = Le*x(1);
YG3dd = -ome2^2*YG3;
V_o2 =m2*YG2dd + m3*YG3dd; %contribution to Vo provided by F
%Vo2 is a single complex number representing amplitude and force of
%the reaction force generated bu only f acting on slider 
%DEFINE TIME HISTORY FOR OUTPUT
V_o2t = abs(V_o2)*cos(ome2*t + angle(V_o2)); %armonic funct of time respect Vo1

%after evaluating the time history for both the effect:
%SUPER IMPOSITION OF EFFECTS
V_ot = V_o1t + V_o2t; %+(m1 + m2 +m3)*g to include static part %total time history! elemnt wise summ done by matlab

%PLOT:
figure(3)
plot(t, V_ot);grid
%effect of the two inputs in one plot 
figure(4)
plot(t, V_o1t, t, V_o2t);grid

