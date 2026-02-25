% From Siljac book
% Marcello Farina, 19/12/2019

Atot =[1 -24 0 1
    1 -20 0  1
    1 0 -20 1
    1 0 -24 1];
         
Bdec{1}=[2 0 0 0]';
Bdec{2}=[0 0 0 2]';
    
Ctot=eye(4);
Cdec{1}=Ctot(1:2,:);
Cdec{2}=Ctot(3:4,:);
         
     