% Quadruple tank - nominal operating point 1
% Marcello Farina, 19/12/2019

T1=62;
T2=90;
T3=23;
T4=30;
A1=28;
A2=32;
A3=28;
A4=32;
k1=3.33;
k2=3.35;
gamma1=0.7;
gamma2=0.6;

Atot0 =[-1/T1 0 A3/A1/T3 0
    0 -1/T2 0 A4/A2/T4
    0 0 -1/T3 0
    0 0 0 -1/T4];
         
Bdec0{1}=[gamma1*k1/A1 0 0 (1-gamma1)*k1/A4]';
Bdec0{2}=[0 gamma2*k2/A2 (1-gamma2)*k2/A3 0]';
Ctot=eye(4);
Cdec0{1}=Ctot([1,4],:);
Cdec0{2}=Ctot(2:3,:);

% use suitable change of coordinates to make the state partition 
%  xnew=[xnew1',xnew2']', where xnew1 includes h1 and h4, while
% x2 includes h2 and h3

T=[1 0 0 0;
    0 0 0 1
    0 1 0 0
    0 0 1 0];

Atot=T*Atot0/T;
Bdec{1}=T*Bdec0{1};
Bdec{2}=T*Bdec0{2};
Cdec{1}=Cdec0{1}/T;
Cdec{2}=Cdec0{2}/T;