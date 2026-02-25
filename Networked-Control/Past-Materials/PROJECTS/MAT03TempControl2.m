% Three-rooms building example
% Marcello Farina, 19/12/2018, updated on 25/10/2020

u=2;
U=0.5;
VA=240;
VBC=24;
sr=12;
sA=84;
sBC=24;
c=1.225*1005;

gamma=sr*u/(c*VA);
Gamma=sr*u/(c*VBC);
gammaA=sA*U/(c*VA);
gammar=sBC*U/(c*VBC);

A=[-(Gamma+gammar) Gamma 0
    gamma -(2*gamma+gammaA) gamma
    0 Gamma -(Gamma+gammar)];
B=[[1/c/VBC
    0 
    0],[0
    1/c/VA
    0],[0
    0
    1/c/VBC]];
C=eye(3);